import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';

/// Serves the Vaulta API from canned JSON so the app runs fully offline.
///
/// Sits **last** in the interceptor chain: requests pass through idempotency,
/// auth, retry and logging first, so the entire real pipeline is exercised —
/// only the socket is fake. Error responses are rejected as
/// [DioExceptionType.badResponse] with `callFollowingErrorInterceptor`, so
/// the auth interceptor handles mock 401s exactly like real ones.
///
/// Demo rules:
/// - login: any well-formed email + password of 8+ chars
/// - OTP code: `123456`
/// - refresh: any token previously issued by this mock
class MockApiInterceptor extends Interceptor {
  MockApiInterceptor({this.latency = const Duration(milliseconds: 350)});

  /// Simulated network delay; pass [Duration.zero] in tests.
  final Duration latency;

  static const otpCode = '123456';

  /// One source of truth for account data — the dashboard summary and every
  /// `/accounts*` route derive from it, so balances never disagree between
  /// screens. IBANs are mod-97 valid so Phase 8's validator accepts them.
  static const _accountFixtures = <_AccountFixture>[
    _AccountFixture(
      id: 'acc_chk',
      name: 'Main Checking',
      type: 'checking',
      iban: 'JO82VBNK0001000000000010204573',
      currency: 'USD',
      balanceMinor: 1248050,
      openedAt: '2022-03-14T00:00:00.000',
      dashboardDeltasMinor: [
        52100, -8620, -1250, 31000, -4370, 425000, -12480,
        -8790, -1599, -21500, -6213, -50000, -475, //
      ],
    ),
    _AccountFixture(
      id: 'acc_sav',
      name: 'Savings',
      type: 'savings',
      iban: 'JO55VBNK0001000000000010204574',
      currency: 'EUR',
      balanceMinor: 893200,
      openedAt: '2023-01-05T00:00:00.000',
      dashboardDeltasMinor: [
        0, 25000, 0, 0, 25000, 0, 0, 25000, 0, 0, 25000, 0, 0, //
      ],
    ),
    _AccountFixture(
      id: 'acc_jod',
      name: 'Amman Account',
      type: 'checking',
      iban: 'JO73VBNK0002000000000010209981',
      currency: 'JOD',
      balanceMinor: 3415750,
      openedAt: '2021-11-20T00:00:00.000',
      dashboardDeltasMinor: [
        -14200, 0, 88000, -9350, 0, -24500, 12000,
        0, -7800, 150000, -5400, 0, -18750, //
      ],
    ),
  ];

  /// Merchant → category pairs for the synthetic transaction backlog.
  static const _merchants = <(String, String)>[
    ('Carrefour', 'groceries'),
    ('C-Town', 'groceries'),
    ('Careem', 'transport'),
    ('Blue Fig Caf\u00e9', 'dining'),
    ('Talabat', 'dining'),
    ('Amazon', 'shopping'),
    ('Manara Books', 'shopping'),
    ('Netflix', 'entertainment'),
    ('Orange JO', 'utilities'),
    ('Zain', 'utilities'),
    ('Pharmacy One', 'other'),
  ];

  /// Cards FK into [_accountFixtures] — never parallel account ids.
  /// `crd_jod_phys` doubles as the JOD limits canary (3 minor digits) and
  /// starts frozen so the unfreeze path is visible without setup. The
  /// savings account deliberately has no card. Schema sketch (§6.14):
  ///
  ///     cards(id pk, account_id fk, label, type, network, status,
  ///           pan, cvv, expiry_month int, expiry_year int,
  ///           daily_limit_minor bigint, monthly_limit_minor bigint)
  ///     -- spent_today/spent_this_month are views over transactions in
  ///     -- prod; the mock materializes seed-stable stand-ins.
  static const _cardFixtures = <_CardFixture>[
    _CardFixture(
      id: 'crd_chk_phys',
      accountId: 'acc_chk',
      label: 'Everyday',
      type: 'physical',
      network: 'visa',
      expiryMonth: 9,
      expiryYear: 2028,
      dailyLimitMinor: 50000,
      monthlyLimitMinor: 1200000,
    ),
    _CardFixture(
      id: 'crd_chk_virt',
      accountId: 'acc_chk',
      label: 'Online shopping',
      type: 'virtual',
      network: 'mastercard',
      expiryMonth: 3,
      expiryYear: 2027,
      dailyLimitMinor: 25000,
      monthlyLimitMinor: 400000,
    ),
    _CardFixture(
      id: 'crd_jod_phys',
      accountId: 'acc_jod',
      label: 'Amman debit',
      type: 'physical',
      network: 'mastercard',
      expiryMonth: 11,
      expiryYear: 2027,
      dailyLimitMinor: 150000,
      monthlyLimitMinor: 2500000,
      initialStatus: 'frozen',
    ),
  ];

  /// Saved payees. IBANs are mod-97 valid so the client's `Iban` parser
  /// accepts them; currencies are deliberately mixed so the FX path is
  /// reachable from the default USD account. Schema sketch (§6.14):
  ///
  ///     beneficiaries(id pk, name, iban, bank_name, currency char(3))
  static const _beneficiaryFixtures = <_BeneficiaryFixture>[
    _BeneficiaryFixture(
      id: 'ben_layla',
      name: 'Layla Haddad',
      iban: 'JO47ARAB0010000000000012009901',
      bankName: 'Arab Bank',
      currency: 'JOD',
    ),
    _BeneficiaryFixture(
      id: 'ben_omar',
      name: 'Omar Nasser',
      iban: 'JO71HBHO0020000000000012009902',
      bankName: 'Housing Bank',
      currency: 'JOD',
    ),
    _BeneficiaryFixture(
      id: 'ben_sara',
      name: 'Sara Malik',
      iban: 'JO85CABK0030000000000012009903',
      bankName: 'Cairo Amman Bank',
      currency: 'USD',
    ),
    _BeneficiaryFixture(
      id: 'ben_studio',
      name: 'Meridian Studio',
      iban: 'JO86ETIH0040000000000012009904',
      bankName: 'Etihad Bank',
      currency: 'EUR',
    ),
  ];

  /// FX rates as exact integer fractions plus the wire string.
  ///
  /// Stored as `(numerator, denominator, wireValue)` rather than a
  /// `double`: a rate multiplies a balance, so the mock converts with
  /// integer arithmetic only — the same discipline the client applies
  /// with `Decimal`. A missing pair means the corridor is unsupported.
  static const _fxRates = <String, (int, int, String)>{
    'USD:JOD': (709, 1000, '0.709'),
    'JOD:USD': (1410, 1000, '1.410'),
    'USD:EUR': (920, 1000, '0.920'),
    'EUR:USD': (1087, 1000, '1.087'),
    'EUR:JOD': (771, 1000, '0.771'),
    'JOD:EUR': (1297, 1000, '1.297'),
  };

  /// Cross-currency transfers carry 0.5% of the sent amount; everything
  /// else is free. One rule, so the fee is trivially reproducible.
  static const _fxFeeBasisPoints = 50;

  static final _historyPath = RegExp(r'^/accounts/([^/]+)/history$');
  static final _statementsPath = RegExp(r'^/accounts/([^/]+)/statements$');
  static final _statementDetailPath =
      RegExp(r'^/accounts/([^/]+)/statements/([^/]+)$');
  static final _transactionDetailPath = RegExp(r'^/transactions/([^/]+)$');
  static final _disputePath = RegExp(r'^/transactions/([^/]+)/dispute$');
  static final _cardFreezePath = RegExp(r'^/cards/([^/]+)/freeze$');
  static final _cardUnfreezePath = RegExp(r'^/cards/([^/]+)/unfreeze$');
  static final _cardRevealPath = RegExp(r'^/cards/([^/]+)/reveal$');
  static final _cardLimitsPath = RegExp(r'^/cards/([^/]+)/limits$');
  static final _transferConfirmPath = RegExp(r'^/transfers/([^/]+)/confirm$');

  final _challenges = <String, String>{}; // challengeId → email
  var _counter = 0;
  String? _sessionEmail;

  /// Session-scoped card mutations layered over the fixtures: freezing a
  /// card or changing its limits must persist across subsequent `GET
  /// /cards` calls within the run, exactly like a stateful backend —
  /// while the deterministic base stays untouched.
  final _cardStatusOverrides = <String, String>{};
  final _cardLimitOverrides = <String, (int, int)>{};

  /// Session-scoped ledger movements. A confirmed transfer debits the
  /// source and credits an own-account destination here, layered over the
  /// immutable fixtures exactly like [_cardStatusOverrides] — so balances
  /// stay internally consistent across `/accounts`, `/dashboard/summary`
  /// and the transaction feed for the rest of the run.
  final _balanceOverrides = <String, int>{};

  /// Priced drafts awaiting confirmation: draft id → draft row.
  final _drafts = <String, _Draft>{};

  /// The idempotency ledger: `Idempotency-Key` → the transfer that key
  /// produced. This is what makes a retried confirm safe — the second
  /// request is answered from here and never moves money again.
  final _transfersByKey = <String, Map<String, dynamic>>{};

  /// Transactions produced by confirmed transfers, newest last. They join
  /// the shared pool so a transfer shows up in Activity immediately.
  final _postedTransactions = <Map<String, dynamic>>[];

  /// Day-cached transaction pool — see [_transactionPool].
  DateTime? _poolDay;
  List<Map<String, dynamic>>? _pool;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(latency);
    final response = _route(options);
    if (response == null) {
      // Unmocked route → let it hit the real network.
      return handler.next(options);
    }
    final status = response.statusCode ?? 500;
    if (status >= 400) {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    }
    handler.resolve(response, true);
  }

  Response<dynamic>? _route(RequestOptions options) {
    final method = options.method.toUpperCase();
    final path = options.path;
    final exact = switch ('$method $path') {
      'POST /auth/login' => _login(options),
      'POST /auth/otp/verify' => _verifyOtp(options),
      'POST /auth/refresh' => _refresh(options),
      'POST /auth/logout' => _respond(options, 204),
      'GET /auth/me' => _me(options),
      'GET /dashboard/summary' => _dashboardSummary(options),
      'GET /accounts' => _accountsList(options),
      'GET /transactions' => _transactions(options),
      'GET /cards' => _cardsList(options),
      'GET /beneficiaries' => _beneficiaries(options),
      'POST /transfers' => _createTransfer(options),
      _ => null,
    };
    if (exact != null) return exact;

    if (method == 'POST') {
      final confirm = _transferConfirmPath.firstMatch(path);
      if (confirm != null) return _confirmTransfer(options, confirm[1]!);
      final dispute = _disputePath.firstMatch(path);
      if (dispute != null) return _submitDispute(options, dispute[1]!);
      final freeze = _cardFreezePath.firstMatch(path);
      if (freeze != null) return _setCardFrozen(options, freeze[1]!, true);
      final unfreeze = _cardUnfreezePath.firstMatch(path);
      if (unfreeze != null) {
        return _setCardFrozen(options, unfreeze[1]!, false);
      }
      final reveal = _cardRevealPath.firstMatch(path);
      if (reveal != null) return _revealCardPan(options, reveal[1]!);
      return null;
    }
    if (method == 'PATCH') {
      final limits = _cardLimitsPath.firstMatch(path);
      if (limits != null) return _updateCardLimits(options, limits[1]!);
      return null;
    }
    if (method != 'GET') return null;

    final history = _historyPath.firstMatch(path);
    if (history != null) return _accountHistory(options, history[1]!);
    final detail = _statementDetailPath.firstMatch(path);
    if (detail != null) {
      return _statementDetail(options, detail[1]!, detail[2]!);
    }
    final statements = _statementsPath.firstMatch(path);
    if (statements != null) return _statements(options, statements[1]!);
    final transaction = _transactionDetailPath.firstMatch(path);
    if (transaction != null) {
      return _transactionDetail(options, transaction[1]!);
    }
    return null;
  }

  Response<dynamic> _login(RequestOptions options) {
    final body = _body(options);
    final email = body['email'] as String? ?? '';
    final password = body['password'] as String? ?? '';
    final emailOk = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email);
    if (!emailOk || password.length < 8) {
      return _respond(options, 401, {
        'message': 'Invalid email or password',
        'code': 'INVALID_CREDENTIALS',
      });
    }
    final challengeId = 'chl_${++_counter}';
    _challenges[challengeId] = email;
    return _respond(options, 200, {
      'challengeId': challengeId,
      'method': 'otp',
      'expiresInSeconds': 120,
      'maskedDestination': _mask(email),
    });
  }

  Response<dynamic> _verifyOtp(RequestOptions options) {
    final body = _body(options);
    final email = _challenges.remove(body['challengeId']);
    if (email == null) {
      return _respond(options, 401, {
        'message': 'Challenge expired',
        'code': 'CHALLENGE_EXPIRED',
      });
    }
    if (body['code'] != otpCode) {
      _challenges[body['challengeId'] as String] = email; // retry allowed
      return _respond(options, 422, {
        'message': 'Incorrect code',
        'errors': {
          'code': ['Incorrect or expired code'],
        },
      });
    }
    _sessionEmail = email;
    return _respond(options, 200, {
      ..._issueTokens(),
      'user': _user(email),
    });
  }

  Response<dynamic> _refresh(RequestOptions options) {
    final token = _body(options)['refreshToken'] as String? ?? '';
    if (!token.startsWith('mock-refresh-')) {
      return _respond(options, 401, {
        'message': 'Invalid refresh token',
        'code': 'INVALID_REFRESH_TOKEN',
      });
    }
    return _respond(options, 200, _issueTokens());
  }

  Response<dynamic> _me(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    return _respond(
      options,
      200,
      _user(_sessionEmail ?? 'demo@vaulta.app'),
    );
  }

  Response<dynamic> _dashboardSummary(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final now = DateTime.now();
    return _respond(options, 200, {
      'accounts': [
        for (final fixture in _accountFixtures)
          _account(
            id: fixture.id,
            name: fixture.name,
            currency: fixture.currency,
            balanceMinor: _balanceOf(fixture),
            deltasMinor: fixture.dashboardDeltasMinor,
            now: now,
          ),
      ],
      // Head of the shared transaction pool (§9 "one shared source"):
      // the dashboard feed and `/transactions` can never disagree. The
      // extra receipt fields (reference, balanceAfterMinor) are ignored
      // by the dashboard DTO.
      'recentTransactions':
          _recentTransactions(DateTime(now.year, now.month, now.day)),
    });
  }

  Response<dynamic> _accountsList(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    return _respond(options, 200, {
      'accounts': [
        for (final fixture in _accountFixtures)
          {
            'id': fixture.id,
            'name': fixture.name,
            'type': fixture.type,
            'iban': fixture.iban,
            'currency': fixture.currency,
            'balanceMinor': _balanceOf(fixture),
            'openedAt': fixture.openedAt,
          },
      ],
    });
  }

  Response<dynamic> _accountHistory(RequestOptions options, String accountId) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _fixtureById(accountId);
    if (fixture == null) return _notFound(options);
    final days =
        (int.tryParse('${options.queryParameters['days'] ?? ''}') ?? 90)
            .clamp(7, 730);
    return _respond(options, 200, {
      'accountId': fixture.id,
      'currency': fixture.currency,
      'points': _history(
        endBalanceMinor: _balanceOf(fixture),
        deltasMinor: _syntheticDeltas(fixture: fixture, days: days),
        now: DateTime.now(),
      ),
    });
  }

  Response<dynamic> _statements(RequestOptions options, String accountId) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _fixtureById(accountId);
    if (fixture == null) return _notFound(options);
    return _respond(options, 200, {
      'statements': [
        for (final statement in _statementsFor(fixture, DateTime.now()))
          ({...statement}..remove('lines')),
      ],
    });
  }

  Response<dynamic> _statementDetail(
    RequestOptions options,
    String accountId,
    String statementId,
  ) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _fixtureById(accountId);
    if (fixture == null) return _notFound(options);
    for (final statement in _statementsFor(fixture, DateTime.now())) {
      if (statement['id'] == statementId) {
        return _respond(options, 200, statement);
      }
    }
    return _notFound(options);
  }

  /// `GET /transactions` — the keyset-paginated feed. Filters compose
  /// server-side (the shape Postgres would serve, §6.14):
  ///
  ///     WHERE ... AND (occurred_at, id) < (:cursor_at, :cursor_id)
  ///     ORDER BY occurred_at DESC, id DESC LIMIT :limit
  ///
  /// The cursor is an opaque base64 of `occurredAt|id`; `nextCursor` is
  /// `null` once the feed is exhausted.
  Response<dynamic> _transactions(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    String? param(String key) {
      final value = options.queryParameters[key];
      final text = value == null ? '' : '$value';
      return text.isEmpty ? null : text;
    }

    final limit = (int.tryParse(param('limit') ?? '') ?? 25).clamp(1, 100);
    final accountId = param('accountId');
    final category = param('category');
    final status = param('status');
    final query = param('q')?.toLowerCase();

    (String, String)? cursor;
    final rawCursor = param('cursor');
    if (rawCursor != null) {
      cursor = _decodeCursor(rawCursor);
      if (cursor == null) {
        return _respond(options, 422, {
          'message': 'Invalid cursor',
          'errors': {
            'cursor': ['Malformed pagination cursor'],
          },
        });
      }
    }

    final filtered = [
      for (final txn in _transactionPool(DateTime.now()))
        if ((accountId == null || txn['accountId'] == accountId) &&
            (category == null || txn['category'] == category) &&
            (status == null || txn['status'] == status) &&
            (query == null ||
                (txn['title'] as String).toLowerCase().contains(query)))
          txn,
    ];

    var start = 0;
    if (cursor != null) {
      final (cursorAt, cursorId) = cursor;
      start = filtered.indexWhere((txn) {
        final occurredAt = txn['occurredAt'] as String;
        final byTime = occurredAt.compareTo(cursorAt);
        if (byTime != 0) return byTime < 0;
        return (txn['id'] as String).compareTo(cursorId) < 0;
      });
      if (start == -1) start = filtered.length;
    }

    final end = math.min(start + limit, filtered.length);
    final page = filtered.sublist(start, end);
    final hasMore = end < filtered.length;
    return _respond(options, 200, {
      'transactions': page,
      'nextCursor': hasMore
          ? _encodeCursor(
              page.last['occurredAt'] as String,
              page.last['id'] as String,
            )
          : null,
    });
  }

  Response<dynamic> _transactionDetail(
    RequestOptions options,
    String transactionId,
  ) {
    if (!_authenticated(options)) return _unauthenticated(options);
    for (final txn in _transactionPool(DateTime.now())) {
      if (txn['id'] == transactionId) return _respond(options, 200, txn);
    }
    return _notFound(options);
  }

  Response<dynamic> _submitDispute(
    RequestOptions options,
    String transactionId,
  ) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final exists = _transactionPool(DateTime.now())
        .any((txn) => txn['id'] == transactionId);
    if (!exists) return _notFound(options);

    const reasons = {'unauthorized', 'wrongAmount', 'duplicate', 'other'};
    final reason = _body(options)['reason'];
    if (reason is! String || !reasons.contains(reason)) {
      return _respond(options, 422, {
        'message': 'Invalid dispute reason',
        'errors': {
          'reason': ['Pick a valid dispute reason'],
        },
      });
    }
    return _respond(options, 202, {
      'disputeId': 'dsp_${++_counter}',
      'transactionId': transactionId,
      'status': 'received',
    });
  }

  Response<dynamic> _cardsList(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    return _respond(options, 200, {
      'cards': [for (final fixture in _cardFixtures) _card(fixture)],
    });
  }

  Response<dynamic> _setCardFrozen(
    RequestOptions options,
    String cardId,
    bool frozen,
  ) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _cardFixtureById(cardId);
    if (fixture == null) return _notFound(options);
    // Idempotent by construction: repeating either verb lands on the same
    // state, matching the data-source contract.
    _cardStatusOverrides[cardId] = frozen ? 'frozen' : 'active';
    return _respond(options, 200, _card(fixture));
  }

  Response<dynamic> _updateCardLimits(RequestOptions options, String cardId) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _cardFixtureById(cardId);
    if (fixture == null) return _notFound(options);

    final body = _body(options);
    final daily = body['dailyMinor'];
    final monthly = body['monthlyMinor'];
    if (daily is! int || monthly is! int || daily <= 0 || monthly <= 0) {
      return _respond(options, 422, {
        'message': 'Invalid limits',
        'errors': {
          'limits': ['Limits must be positive amounts'],
        },
      });
    }
    if (daily > monthly) {
      return _respond(options, 422, {
        'message': 'Invalid limits',
        'errors': {
          'dailyMinor': ['Daily limit cannot exceed the monthly limit'],
        },
      });
    }
    _cardLimitOverrides[cardId] = (daily, monthly);
    return _respond(options, 200, _card(fixture));
  }

  Response<dynamic> _revealCardPan(RequestOptions options, String cardId) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final fixture = _cardFixtureById(cardId);
    if (fixture == null) return _notFound(options);
    final pan = _cardPan(fixture);
    return _respond(options, 200, {
      'cardId': fixture.id,
      'pan': pan,
      'cvv': (_seed('${fixture.id}:cvv') % 900 + 100).toString(),
      'expiryMonth': fixture.expiryMonth,
      'expiryYear': fixture.expiryYear,
    });
  }

  Response<dynamic> _beneficiaries(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    return _respond(options, 200, {
      'beneficiaries': [
        for (final fixture in _beneficiaryFixtures)
          {
            'id': fixture.id,
            'name': fixture.name,
            'iban': fixture.iban,
            'bankName': fixture.bankName,
            'currency': fixture.currency,
          },
      ],
    });
  }

  /// `POST /transfers` — prices a transfer and returns a draft. Nothing
  /// moves here, so creating several drafts is harmless.
  ///
  /// Schema sketch (§6.14):
  ///
  ///     transfers(id pk, source_account_id fk, destination_label,
  ///               destination_detail, destination_account_id fk null,
  ///               amount_minor bigint, currency char(3),
  ///               fee_minor bigint, total_debit_minor bigint,
  ///               destination_amount_minor bigint,
  ///               destination_currency char(3), rate numeric null,
  ///               status, reference, note, scheduled_for timestamptz
  ///               null, created_at timestamptz)
  ///     transfer_idempotency(key pk, transfer_id fk, created_at)
  ///       -- unique on key; the confirm endpoint reads it before doing
  ///       -- any work, which is what makes a retry safe in prod too.
  Response<dynamic> _createTransfer(RequestOptions options) {
    if (!_authenticated(options)) return _unauthenticated(options);
    final body = _body(options);

    final source = _fixtureById(body['sourceAccountId'] as String? ?? '');
    if (source == null) {
      return _invalid(options, 'destination', 'Pick an account to send from');
    }

    final amountMinor = body['amountMinor'];
    if (amountMinor is! int || amountMinor <= 0) {
      return _invalid(
        options,
        'amountMinor',
        'Enter an amount greater than zero',
      );
    }

    final destination = body['destination'];
    if (destination is! Map<String, dynamic>) {
      return _invalid(options, 'destination', 'Pick a recipient');
    }

    final type = destination['type'];
    _ResolvedDestination? target;
    if (type == 'own') {
      final account = _fixtureById(destination['accountId'] as String? ?? '');
      if (account == null || account.id == source.id) {
        return _invalid(options, 'destination', 'Pick a different account');
      }
      target = _ResolvedDestination(
        label: account.name,
        detail: _maskIban(account.iban),
        currency: account.currency,
        accountId: account.id,
      );
    } else if (type == 'beneficiary') {
      final payee =
          _beneficiaryById(destination['beneficiaryId'] as String? ?? '');
      if (payee == null) {
        return _invalid(options, 'destination', 'Unknown payee');
      }
      target = _ResolvedDestination(
        label: payee.name,
        detail: '${payee.bankName} \u00b7 ${_maskIban(payee.iban)}',
        currency: payee.currency,
      );
    } else if (type == 'iban') {
      final iban = _normalizeIban(destination['iban'] as String? ?? '');
      if (!_ibanValid(iban)) {
        return _invalid(options, 'iban', 'That IBAN is not valid');
      }
      final holder = (destination['holderName'] as String? ?? '').trim();
      if (holder.isEmpty) {
        return _invalid(options, 'destination', 'Enter the payee name');
      }
      target = _ResolvedDestination(
        label: holder,
        detail: _maskIban(iban),
        // A raw-IBAN payee settles in the sender's currency here; a real
        // rail would resolve it from the receiving institution.
        currency: source.currency,
      );
    }
    if (target == null) {
      return _invalid(options, 'destination', 'Pick a recipient');
    }

    DateTime? scheduledFor;
    final rawSchedule = body['scheduledFor'];
    if (rawSchedule is String && rawSchedule.isNotEmpty) {
      final parsed = DateTime.tryParse(rawSchedule);
      if (parsed == null || !parsed.isAfter(DateTime.now())) {
        return _invalid(options, 'scheduledFor', 'Pick a future date');
      }
      scheduledFor = parsed;
    }

    var feeMinor = 0;
    var destinationAmountMinor = amountMinor;
    String? rateWire;
    if (source.currency != target.currency) {
      final rate = _fxRates['${source.currency}:${target.currency}'];
      if (rate == null) {
        return _invalid(
          options,
          'destination',
          'That currency corridor is not supported',
        );
      }
      final (numerator, denominator, wire) = rate;
      rateWire = wire;
      // Half-up on 0.5%, in integers — no double touches a fee.
      feeMinor = (amountMinor * _fxFeeBasisPoints + 5000) ~/ 10000;
      destinationAmountMinor = _convertMinor(
        amountMinor: amountMinor,
        from: source.currency,
        to: target.currency,
        numerator: numerator,
        denominator: denominator,
      );
    }

    final totalDebitMinor = amountMinor + feeMinor;
    if (totalDebitMinor > _balanceOf(source)) {
      return _invalid(
        options,
        'amountMinor',
        'Not enough available balance to cover the amount and fee',
      );
    }

    final id = 'trf_${++_counter}';
    final quote = <String, dynamic>{
      'id': id,
      // Issued with the draft, not at send time: a client that is killed
      // between review and confirm can replay the very same key.
      'idempotencyKey': 'idem_$id',
      'sourceAccountId': source.id,
      'destinationLabel': target.label,
      'destinationDetail': target.detail,
      'amountMinor': amountMinor,
      'currency': source.currency,
      'feeMinor': feeMinor,
      'totalDebitMinor': totalDebitMinor,
      'destinationAmountMinor': destinationAmountMinor,
      'destinationCurrency': target.currency,
      'rate': rateWire,
      'scheduledFor': scheduledFor?.toIso8601String(),
    };
    _drafts[id] = _Draft(
      quote: quote,
      destinationAccountId: target.accountId,
      scheduled: scheduledFor != null,
    );
    return _respond(options, 201, quote);
  }

  /// `POST /transfers/:id/confirm` — the only route that moves money.
  ///
  /// Idempotency is enforced *before* any work: if the presented
  /// `Idempotency-Key` has been seen, the original transfer is returned
  /// unchanged and no balance is touched. That is what makes a retried
  /// confirm — from `dio_smart_retry`, a double-tap, or a replayed
  /// outbox entry — safe rather than a double spend.
  Response<dynamic> _confirmTransfer(RequestOptions options, String draftId) {
    if (!_authenticated(options)) return _unauthenticated(options);

    final key = _idempotencyKey(options);
    if (key != null) {
      final replay = _transfersByKey[key];
      if (replay != null) return _respond(options, 201, replay);
    }

    final draft = _drafts[draftId];
    if (draft == null) return _notFound(options);

    final source = _fixtureById(draft.quote['sourceAccountId'] as String);
    if (source == null) return _notFound(options);

    final totalDebitMinor = draft.quote['totalDebitMinor'] as int;
    if (!draft.scheduled && totalDebitMinor > _balanceOf(source)) {
      return _invalid(
        options,
        'amountMinor',
        'Not enough available balance to cover the amount and fee',
      );
    }

    final now = DateTime.now();
    final transfer = <String, dynamic>{
      ...draft.quote,
      'reference': 'VLT-${now.year}-${_seed(draftId) % 900000 + 100000}',
      'status': draft.scheduled ? 'scheduled' : 'completed',
      'createdAt': now.toIso8601String(),
    };

    if (!draft.scheduled) {
      _applyTransfer(
        draft: draft,
        source: source,
        at: now,
        reference: transfer['reference'] as String,
      );
      transfer['balanceAfterMinor'] = _balanceOf(source);
    }

    // The draft is single-use: consuming it means even a caller that
    // omits the header entirely cannot confirm the same draft twice.
    _drafts.remove(draftId);
    if (key != null) _transfersByKey[key] = transfer;
    return _respond(options, 201, transfer);
  }

  /// Moves the money and posts the ledger rows.
  void _applyTransfer({
    required _Draft draft,
    required _AccountFixture source,
    required DateTime at,
    required String reference,
  }) {
    final quote = draft.quote;
    final totalDebitMinor = quote['totalDebitMinor'] as int;
    _balanceOverrides[source.id] = _balanceOf(source) - totalDebitMinor;
    _postedTransactions.add({
      'id': 'txn_${quote['id']}_out',
      'accountId': source.id,
      'title': 'To ${quote['destinationLabel']}',
      'category': 'transfer',
      'amountMinor': -totalDebitMinor,
      'currency': source.currency,
      'occurredAt': at.toIso8601String(),
      'status': 'completed',
      'reference': reference,
    });

    final destinationId = draft.destinationAccountId;
    final destination =
        destinationId == null ? null : _fixtureById(destinationId);
    if (destination != null) {
      final credited = quote['destinationAmountMinor'] as int;
      _balanceOverrides[destination.id] = _balanceOf(destination) + credited;
      _postedTransactions.add({
        'id': 'txn_${quote['id']}_in',
        'accountId': destination.id,
        'title': 'From ${source.name}',
        'category': 'transfer',
        'amountMinor': credited,
        'currency': destination.currency,
        'occurredAt': at.toIso8601String(),
        'status': 'completed',
        'reference': reference,
      });
    }

    // The pool caches a day of rows and derives running balances from the
    // account balances — both just changed, so it has to be rebuilt.
    _pool = null;
  }

  /// Exact minor-unit conversion: `amount * rate`, carried entirely in
  /// integers and rounded half-up once, at the end.
  int _convertMinor({
    required int amountMinor,
    required String from,
    required String to,
    required int numerator,
    required int denominator,
  }) {
    final sourceDigits = _minorDigits(from);
    final destinationDigits = _minorDigits(to);
    var scaledNumerator = amountMinor * numerator;
    var scaledDenominator = denominator;
    if (destinationDigits >= sourceDigits) {
      scaledNumerator *= _pow10(destinationDigits - sourceDigits);
    } else {
      scaledDenominator *= _pow10(sourceDigits - destinationDigits);
    }
    return (scaledNumerator + scaledDenominator ~/ 2) ~/ scaledDenominator;
  }

  static int _minorDigits(String code) => switch (code) {
        'JOD' => 3,
        'JPY' => 0,
        _ => 2,
      };

  static int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  /// Case-insensitive header lookup — deliberately not relying on the
  /// header map's own casing behaviour.
  String? _idempotencyKey(RequestOptions options) {
    for (final entry in options.headers.entries) {
      if (entry.key.toLowerCase() != 'idempotency-key') continue;
      final value = entry.value;
      if (value is String && value.isNotEmpty) return value;
      if (value is List && value.isNotEmpty) return '${value.first}';
    }
    return null;
  }

  static String _normalizeIban(String input) =>
      input.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');

  /// The server validates check digits itself; the client's identical
  /// check is a convenience, never the authority.
  static bool _ibanValid(String iban) {
    if (iban.length < 15 || iban.length > 34) return false;
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]+$').hasMatch(iban)) return false;
    final rearranged = '${iban.substring(4)}${iban.substring(0, 4)}';
    var remainder = 0;
    for (final unit in rearranged.codeUnits) {
      if (unit >= 0x30 && unit <= 0x39) {
        remainder = (remainder * 10 + (unit - 0x30)) % 97;
      } else {
        remainder = (remainder * 100 + (unit - 0x41 + 10)) % 97;
      }
    }
    return remainder == 1;
  }

  static String _maskIban(String iban) => iban.length <= 4
      ? iban
      : '\u2022\u2022\u2022\u2022 ${iban.substring(iban.length - 4)}';

  _BeneficiaryFixture? _beneficiaryById(String id) {
    for (final fixture in _beneficiaryFixtures) {
      if (fixture.id == id) return fixture;
    }
    return null;
  }

  int _balanceOf(_AccountFixture fixture) =>
      _balanceOverrides[fixture.id] ?? fixture.balanceMinor;

  Response<dynamic> _invalid(
    RequestOptions options,
    String field,
    String message,
  ) {
    return _respond(options, 422, {
      'message': message,
      'errors': {
        field: [message],
      },
    });
  }

  Map<String, dynamic> _card(_CardFixture fixture) {
    final account = _fixtureById(fixture.accountId)!;
    final pan = _cardPan(fixture);
    final (dailyMinor, monthlyMinor) = _cardLimitOverrides[fixture.id] ??
        (fixture.dailyLimitMinor, fixture.monthlyLimitMinor);
    // Seed-stable usage under the *base* limits, so lowering a limit can
    // legitimately push utilisation to 100% (the UI clamps the bar).
    final spentToday =
        _seed('${fixture.id}:today') % (fixture.dailyLimitMinor ~/ 2);
    final spentThisMonth = fixture.dailyLimitMinor ~/ 2 +
        _seed('${fixture.id}:month') % (fixture.monthlyLimitMinor ~/ 2);
    return {
      'id': fixture.id,
      'accountId': fixture.accountId,
      'label': fixture.label,
      'type': fixture.type,
      'network': fixture.network,
      'status': _cardStatusOverrides[fixture.id] ?? fixture.initialStatus,
      'panLast4': pan.substring(pan.length - 4),
      'expiryMonth': fixture.expiryMonth,
      'expiryYear': fixture.expiryYear,
      'currency': account.currency,
      'limits': {
        'dailyMinor': dailyMinor,
        'monthlyMinor': monthlyMinor,
        'spentTodayMinor': spentToday,
        'spentThisMonthMinor': spentThisMonth,
      },
    };
  }

  /// Deterministic, Luhn-valid PAN: network prefix + `_seed`-driven body
  /// + computed check digit. `panLast4` in the card list is derived from
  /// the same value, so a reveal always matches the mask — like a real
  /// issuer, and asserted by the pipeline tests.
  String _cardPan(_CardFixture fixture) {
    final rng = math.Random(_seed('${fixture.id}:pan'));
    final buffer = StringBuffer(fixture.network == 'visa' ? '4' : '52');
    while (buffer.length < 15) {
      buffer.write(rng.nextInt(10));
    }
    final partial = buffer.toString();
    return '$partial${_luhnCheckDigit(partial)}';
  }

  int _luhnCheckDigit(String partial) {
    var sum = 0;
    var doubleIt = true; // rightmost partial digit doubles once appended
    for (var i = partial.length - 1; i >= 0; i--) {
      var digit = partial.codeUnitAt(i) - 0x30;
      if (doubleIt) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      doubleIt = !doubleIt;
    }
    return (10 - sum % 10) % 10;
  }

  _CardFixture? _cardFixtureById(String id) {
    for (final fixture in _cardFixtures) {
      if (fixture.id == id) return fixture;
    }
    return null;
  }

  _AccountFixture? _fixtureById(String id) {
    for (final fixture in _accountFixtures) {
      if (fixture.id == id) return fixture;
    }
    return null;
  }

  /// The mock's stand-in for the `transactions` table (§9 schema sketch).
  ///
  /// Built once per calendar day and cached: every timestamp is anchored
  /// to midnight-relative offsets (like [_history]'s dates), so a paged
  /// session sees identical bytes across requests and keyset cursors stay
  /// stable — a `now`-relative pool would shift by seconds between pages
  /// and duplicate or skip rows at the cursor boundary.
  List<Map<String, dynamic>> _transactionPool(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final cached = _pool;
    if (cached != null && _poolDay == today) return cached;

    // Keyset order: (occurred_at DESC, id DESC). The ISO-8601 strings all
    // come from DateTime.toIso8601String() with zero microseconds, so they
    // are fixed-width and lexicographic order == chronological order.
    final txns = <Map<String, dynamic>>[
      ..._postedTransactions,
      ..._recentTransactions(today),
      for (final fixture in _accountFixtures)
        ..._syntheticTransactions(fixture: fixture, today: today),
    ]..sort((a, b) {
        final byTime =
            (b['occurredAt'] as String).compareTo(a['occurredAt'] as String);
        if (byTime != 0) return byTime;
        return (b['id'] as String).compareTo(a['id'] as String);
      });
    _applyRunningBalances(txns);
    _poolDay = today;
    _pool = txns;
    return txns;
  }

  /// The eight curated entries the dashboard has always shown, now
  /// day-anchored (fixed clock times instead of `now`-relative offsets)
  /// so they participate in the deterministic pool. Same titles, amounts,
  /// order and statuses as before.
  List<Map<String, dynamic>> _recentTransactions(DateTime today) {
    final checking = _accountFixtures[0];
    final amman = _accountFixtures[2];
    DateTime at(int daysBack, int hour, int minute) {
      final day = today.subtract(Duration(days: daysBack));
      return DateTime(day.year, day.month, day.day, hour, minute);
    }

    return [
      _record(
        fixture: checking,
        id: 'txn_101',
        title: 'Blue Fig Caf\u00e9',
        category: 'dining',
        amountMinor: -475,
        occurredAt: at(0, 10, 24),
        status: 'pending',
      ),
      _record(
        fixture: checking,
        id: 'txn_102',
        title: 'Careem',
        category: 'transport',
        amountMinor: -1250,
        occurredAt: at(0, 7, 41),
      ),
      _record(
        fixture: checking,
        id: 'txn_103',
        title: 'Carrefour',
        category: 'groceries',
        amountMinor: -8620,
        occurredAt: at(1, 19, 5),
      ),
      _record(
        fixture: checking,
        id: 'txn_104',
        title: 'Salary \u2014 Vaulta Labs',
        category: 'salary',
        amountMinor: 425000,
        occurredAt: at(1, 9, 0),
      ),
      _record(
        fixture: checking,
        id: 'txn_105',
        title: 'Netflix',
        category: 'entertainment',
        amountMinor: -1599,
        occurredAt: at(2, 20, 15),
      ),
      _record(
        fixture: checking,
        id: 'txn_106',
        title: 'To Savings',
        category: 'transfer',
        amountMinor: -50000,
        occurredAt: at(3, 11, 30),
      ),
      _record(
        fixture: checking,
        id: 'txn_107',
        title: 'Amazon',
        category: 'shopping',
        amountMinor: -6213,
        occurredAt: at(4, 16, 45),
      ),
      _record(
        fixture: amman,
        id: 'txn_108',
        title: 'Zain',
        category: 'utilities',
        amountMinor: -24500,
        occurredAt: at(5, 13, 20),
      ),
    ];
  }

  /// Deterministic backlog behind the curated recents: ~8 months of daily
  /// activity per account, seeded per account with the content-stable
  /// hash. Checking accounts get a monthly salary; the savings account
  /// gets its monthly inbound transfer (matching its sparkline) plus the
  /// occasional interest credit. Starts 6 days back so the curated
  /// entries own the recent window.
  List<Map<String, dynamic>> _syntheticTransactions({
    required _AccountFixture fixture,
    required DateTime today,
  }) {
    final rng = math.Random(_seed('${fixture.id}:txns'));
    final base = math.max(1000, fixture.balanceMinor.abs() ~/ 70);
    final txns = <Map<String, dynamic>>[];

    for (var daysBack = 6; daysBack <= 240; daysBack++) {
      final day = today.subtract(Duration(days: daysBack));

      if (fixture.type == 'savings') {
        if (day.day == 1) {
          txns.add(
            _record(
              fixture: fixture,
              id: 'txn_${fixture.id}_${daysBack}_in',
              title: 'From Main Checking',
              category: 'transfer',
              amountMinor: 25000,
              occurredAt: DateTime(day.year, day.month, day.day, 9),
            ),
          );
        }
        if (rng.nextInt(100) < 3) {
          txns.add(
            _record(
              fixture: fixture,
              id: 'txn_${fixture.id}_${daysBack}_int',
              title: 'Interest',
              category: 'other',
              amountMinor: base ~/ 8 + rng.nextInt(math.max(1, base ~/ 4)),
              occurredAt: DateTime(day.year, day.month, day.day, 6),
            ),
          );
        }
        continue;
      }

      if (day.day == 27) {
        txns.add(
          _record(
            fixture: fixture,
            id: 'txn_${fixture.id}_${daysBack}_salary',
            title: 'Salary \u2014 Vaulta Labs',
            category: 'salary',
            amountMinor: base * 25,
            occurredAt: DateTime(day.year, day.month, day.day, 9),
          ),
        );
      }

      final roll = rng.nextInt(100);
      final count = roll < 25 ? 0 : (roll < 80 ? 1 : 2);
      for (var i = 0; i < count; i++) {
        final (title, category) = _merchants[rng.nextInt(_merchants.length)];
        final failed = rng.nextInt(100) < 2;
        txns.add(
          _record(
            fixture: fixture,
            id: 'txn_${fixture.id}_${daysBack}_$i',
            title: title,
            category: category,
            amountMinor: -(base ~/ 5 + rng.nextInt(base)),
            occurredAt: DateTime(
              day.year,
              day.month,
              day.day,
              8 + rng.nextInt(13),
              rng.nextInt(60),
            ),
            status: failed ? 'failed' : 'completed',
          ),
        );
      }
    }
    return txns;
  }

  /// Walks the sorted pool newest → oldest per account: a settled entry's
  /// `balanceAfterMinor` is the running balance, which then rewinds by the
  /// entry's amount — so the newest settled entry lands exactly on the
  /// fixture balance and the chain stays internally consistent (the same
  /// invariant the statements generator keeps). Pending and failed entries
  /// never moved the ledger, so they carry no balance.
  void _applyRunningBalances(List<Map<String, dynamic>> sortedDesc) {
    final running = {
      for (final fixture in _accountFixtures) fixture.id: _balanceOf(fixture),
    };
    for (final txn in sortedDesc) {
      if (txn['status'] != 'completed') continue;
      final accountId = txn['accountId'] as String;
      final balance = running[accountId];
      if (balance == null) continue;
      txn['balanceAfterMinor'] = balance;
      running[accountId] = balance - (txn['amountMinor'] as int);
    }
  }

  Map<String, dynamic> _record({
    required _AccountFixture fixture,
    required String id,
    required String title,
    required String category,
    required int amountMinor,
    required DateTime occurredAt,
    String status = 'completed',
  }) {
    return {
      'id': id,
      'accountId': fixture.id,
      'title': title,
      'category': category,
      'amountMinor': amountMinor,
      'currency': fixture.currency,
      'occurredAt': occurredAt.toIso8601String(),
      'status': status,
      'reference': 'VLT-${occurredAt.year}-${_seed(id) % 900000 + 100000}',
    };
  }

  String _encodeCursor(String occurredAt, String id) =>
      base64Url.encode(utf8.encode('$occurredAt|$id'));

  (String, String)? _decodeCursor(String cursor) {
    try {
      final decoded = utf8.decode(base64Url.decode(cursor));
      final split = decoded.lastIndexOf('|');
      if (split <= 0) return null;
      return (decoded.substring(0, split), decoded.substring(split + 1));
    } on FormatException {
      return null;
    }
  }

  /// Deterministic pseudo-random daily deltas, seeded per (account, window)
  /// with a content-stable hash so charts don't reshuffle between reloads.
  /// A Postgres backend would compute these points from the transactions
  /// table; the wire shape matches that view (§6.14).
  List<int> _syntheticDeltas({
    required _AccountFixture fixture,
    required int days,
  }) {
    final rng = math.Random(_seed('${fixture.id}:$days'));
    final base = math.max(1000, fixture.balanceMinor.abs() ~/ 70);
    return List<int>.generate(days, (_) {
      final roll = rng.nextInt(100);
      if (roll < 6) return base * (5 + rng.nextInt(6)); // salary / inbound
      if (roll < 26) return 0; // quiet day
      return -(base ~/ 5 + rng.nextInt(base)); // day-to-day spend
    });
  }

  /// Last three full months, walked backwards from (roughly) the current
  /// balance. Each statement is internally consistent — `closing ==
  /// opening + sum(lines)` — and chains into the previous month, exactly
  /// like a ledger-backed view would.
  List<Map<String, dynamic>> _statementsFor(
    _AccountFixture fixture,
    DateTime now,
  ) {
    final rng = math.Random(_seed(fixture.id));
    var closingMinor =
        fixture.balanceMinor - rng.nextInt(fixture.balanceMinor ~/ 25 + 1);
    final statements = <Map<String, dynamic>>[];
    for (var monthsBack = 1; monthsBack <= 3; monthsBack++) {
      final start = DateTime(now.year, now.month - monthsBack);
      final end = DateTime(now.year, now.month - monthsBack + 1, 0);
      final lines = _statementLines(
        rng: rng,
        fixture: fixture,
        start: start,
        end: end,
        index: monthsBack,
      );
      final netMinor =
          lines.fold<int>(0, (sum, line) => sum + (line['amountMinor'] as int));
      final openingMinor = closingMinor - netMinor;
      statements.add({
        'id': 'stm_${fixture.id}_'
            '${start.year}${start.month.toString().padLeft(2, '0')}',
        'accountId': fixture.id,
        'periodStart': start.toIso8601String(),
        'periodEnd': end.toIso8601String(),
        'currency': fixture.currency,
        'openingBalanceMinor': openingMinor,
        'closingBalanceMinor': closingMinor,
        'transactionCount': lines.length,
        'lines': lines,
      });
      closingMinor = openingMinor;
    }
    return statements;
  }

  List<Map<String, dynamic>> _statementLines({
    required math.Random rng,
    required _AccountFixture fixture,
    required DateTime start,
    required DateTime end,
    required int index,
  }) {
    const merchants = [
      'Carrefour',
      'Careem',
      'Blue Fig Caf\u00e9',
      'Orange JO',
      'Talabat',
      'Amazon',
      'C-Town',
      'Netflix',
      'Zain',
      'Pharmacy One',
      'Manara Books',
    ];
    final base = math.max(1000, fixture.balanceMinor.abs() ~/ 70);
    final count = 6 + rng.nextInt(6);
    final lines = <Map<String, dynamic>>[
      for (var i = 0; i < count; i++)
        {
          'id': 'stl_${fixture.id}_${index}_$i',
          'title': merchants[rng.nextInt(merchants.length)],
          'amountMinor': -(base ~/ 5 + rng.nextInt(base * 2)),
          'occurredAt': DateTime(
            start.year,
            start.month,
            1 + rng.nextInt(end.day),
            8 + rng.nextInt(12),
            rng.nextInt(60),
          ).toIso8601String(),
        },
    ];
    if (fixture.type == 'checking') {
      lines.add({
        'id': 'stl_${fixture.id}_${index}_salary',
        'title': 'Salary \u2014 Vaulta Labs',
        'amountMinor': base * 25,
        'occurredAt': DateTime(
          start.year,
          start.month,
          math.min(27, end.day),
          9,
        ).toIso8601String(),
      });
    }
    lines.sort(
      (a, b) =>
          (a['occurredAt'] as String).compareTo(b['occurredAt'] as String),
    );
    return lines;
  }

  /// Content-stable hash: `String.hashCode` isn't guaranteed stable across
  /// runs, and `Object.hash` is per-process seeded — this is neither.
  int _seed(String key) {
    var hash = 17;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x3FFFFFFF;
    }
    return hash;
  }

  bool _authenticated(RequestOptions options) {
    final header = options.headers['Authorization'] as String? ?? '';
    return header.startsWith('Bearer mock-access-');
  }

  Response<dynamic> _unauthenticated(RequestOptions options) {
    return _respond(options, 401, {
      'message': 'Session expired',
      'code': 'UNAUTHENTICATED',
    });
  }

  Response<dynamic> _notFound(RequestOptions options) {
    return _respond(options, 404, {
      'message': 'Not found',
      'code': 'NOT_FOUND',
    });
  }

  Map<String, dynamic> _account({
    required String id,
    required String name,
    required String currency,
    required int balanceMinor,
    required List<int> deltasMinor,
    required DateTime now,
  }) {
    return {
      'id': id,
      'name': name,
      'currency': currency,
      'balanceMinor': balanceMinor,
      'history': _history(
        endBalanceMinor: balanceMinor,
        deltasMinor: deltasMinor,
        now: now,
      ),
    };
  }

  /// Builds a daily balance history that ends at [endBalanceMinor] today,
  /// walking backwards through [deltasMinor] (day-over-day changes).
  List<Map<String, dynamic>> _history({
    required int endBalanceMinor,
    required List<int> deltasMinor,
    required DateTime now,
  }) {
    final count = deltasMinor.length + 1;
    final balances = List<int>.filled(count, endBalanceMinor);
    for (var i = count - 2; i >= 0; i--) {
      balances[i] = balances[i + 1] - deltasMinor[i];
    }
    final today = DateTime(now.year, now.month, now.day);
    return [
      for (var i = 0; i < count; i++)
        {
          'date':
              today.subtract(Duration(days: count - 1 - i)).toIso8601String(),
          'balanceMinor': balances[i],
        },
    ];
  }

  Map<String, dynamic> _issueTokens() {
    _counter++;
    return {
      'accessToken': 'mock-access-$_counter',
      'refreshToken': 'mock-refresh-$_counter',
    };
  }

  Map<String, dynamic> _user(String email) => {
        'id': 'usr_001',
        'fullName': 'Dana Khoury',
        'email': email,
        'kycStatus': 'verified',
      };

  Map<String, dynamic> _body(RequestOptions options) {
    final data = options.data;
    return data is Map<String, dynamic> ? data : const {};
  }

  String _mask(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts.first.isEmpty) return '***';
    return '${parts.first[0]}***@${parts.last}';
  }

  Response<dynamic> _respond(
    RequestOptions options,
    int status, [
    Object? data,
  ]) {
    return Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: data,
    );
  }
}

/// Canonical account row — the mock's stand-in for the `accounts` table.
class _AccountFixture {
  const _AccountFixture({
    required this.id,
    required this.name,
    required this.type,
    required this.iban,
    required this.currency,
    required this.balanceMinor,
    required this.openedAt,
    required this.dashboardDeltasMinor,
  });

  final String id;
  final String name;
  final String type;
  final String iban;
  final String currency;
  final int balanceMinor;
  final String openedAt;

  /// The 14-point sparkline history shown on the dashboard.
  final List<int> dashboardDeltasMinor;
}

/// Canonical card row — the mock's stand-in for the `cards` table.
class _CardFixture {
  const _CardFixture({
    required this.id,
    required this.accountId,
    required this.label,
    required this.type,
    required this.network,
    required this.expiryMonth,
    required this.expiryYear,
    required this.dailyLimitMinor,
    required this.monthlyLimitMinor,
    this.initialStatus = 'active',
  });

  final String id;
  final String accountId;
  final String label;
  final String type;
  final String network;
  final int expiryMonth;
  final int expiryYear;
  final int dailyLimitMinor;
  final int monthlyLimitMinor;

  /// Base status; session freeze/unfreeze overrides layer on top.
  final String initialStatus;
}

/// Canonical beneficiary row — the mock's stand-in for the
/// `beneficiaries` table.
class _BeneficiaryFixture {
  const _BeneficiaryFixture({
    required this.id,
    required this.name,
    required this.iban,
    required this.bankName,
    required this.currency,
  });

  final String id;
  final String name;
  final String iban;
  final String bankName;
  final String currency;
}

/// A priced, unconfirmed transfer. [quote] is exactly what the client was
/// shown; the other fields are server-side columns the client never sees.
class _Draft {
  const _Draft({
    required this.quote,
    required this.destinationAccountId,
    required this.scheduled,
  });

  final Map<String, dynamic> quote;

  /// Set only for own-account transfers — the leg that gets credited.
  final String? destinationAccountId;

  final bool scheduled;
}

/// A destination resolved to the fields pricing and the receipt need.
class _ResolvedDestination {
  const _ResolvedDestination({
    required this.label,
    required this.detail,
    required this.currency,
    this.accountId,
  });

  final String label;
  final String detail;
  final String currency;
  final String? accountId;
}
