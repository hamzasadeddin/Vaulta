// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedAccountsTable extends CachedAccounts
    with TableInfo<$CachedAccountsTable, CachedAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ibanMeta = const VerificationMeta('iban');
  @override
  late final GeneratedColumn<String> iban = GeneratedColumn<String>(
      'iban', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMinorMeta =
      const VerificationMeta('balanceMinor');
  @override
  late final GeneratedColumn<BigInt> balanceMinor = GeneratedColumn<BigInt>(
      'balance_minor', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        iban,
        currency,
        balanceMinor,
        openedAt,
        position,
        fetchedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<CachedAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('iban')) {
      context.handle(
          _ibanMeta, iban.isAcceptableOrUnknown(data['iban']!, _ibanMeta));
    } else if (isInserting) {
      context.missing(_ibanMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('balance_minor')) {
      context.handle(
          _balanceMinorMeta,
          balanceMinor.isAcceptableOrUnknown(
              data['balance_minor']!, _balanceMinorMeta));
    } else if (isInserting) {
      context.missing(_balanceMinorMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      iban: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}iban'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      balanceMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}balance_minor'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $CachedAccountsTable createAlias(String alias) {
    return $CachedAccountsTable(attachedDatabase, alias);
  }
}

class CachedAccount extends DataClass implements Insertable<CachedAccount> {
  final String id;
  final String name;
  final String type;
  final String iban;
  final String currency;
  final BigInt balanceMinor;
  final DateTime openedAt;

  /// Preserves the server's list ordering across cache round trips.
  final int position;

  /// When this row was written — staleness signal for future policies.
  final DateTime fetchedAt;
  const CachedAccount(
      {required this.id,
      required this.name,
      required this.type,
      required this.iban,
      required this.currency,
      required this.balanceMinor,
      required this.openedAt,
      required this.position,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['iban'] = Variable<String>(iban);
    map['currency'] = Variable<String>(currency);
    map['balance_minor'] = Variable<BigInt>(balanceMinor);
    map['opened_at'] = Variable<DateTime>(openedAt);
    map['position'] = Variable<int>(position);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedAccountsCompanion toCompanion(bool nullToAbsent) {
    return CachedAccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      iban: Value(iban),
      currency: Value(currency),
      balanceMinor: Value(balanceMinor),
      openedAt: Value(openedAt),
      position: Value(position),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAccount(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      iban: serializer.fromJson<String>(json['iban']),
      currency: serializer.fromJson<String>(json['currency']),
      balanceMinor: serializer.fromJson<BigInt>(json['balanceMinor']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      position: serializer.fromJson<int>(json['position']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'iban': serializer.toJson<String>(iban),
      'currency': serializer.toJson<String>(currency),
      'balanceMinor': serializer.toJson<BigInt>(balanceMinor),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'position': serializer.toJson<int>(position),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedAccount copyWith(
          {String? id,
          String? name,
          String? type,
          String? iban,
          String? currency,
          BigInt? balanceMinor,
          DateTime? openedAt,
          int? position,
          DateTime? fetchedAt}) =>
      CachedAccount(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        iban: iban ?? this.iban,
        currency: currency ?? this.currency,
        balanceMinor: balanceMinor ?? this.balanceMinor,
        openedAt: openedAt ?? this.openedAt,
        position: position ?? this.position,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  CachedAccount copyWithCompanion(CachedAccountsCompanion data) {
    return CachedAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      iban: data.iban.present ? data.iban.value : this.iban,
      currency: data.currency.present ? data.currency.value : this.currency,
      balanceMinor: data.balanceMinor.present
          ? data.balanceMinor.value
          : this.balanceMinor,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      position: data.position.present ? data.position.value : this.position,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iban: $iban, ')
          ..write('currency: $currency, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('openedAt: $openedAt, ')
          ..write('position: $position, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, iban, currency, balanceMinor,
      openedAt, position, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.iban == this.iban &&
          other.currency == this.currency &&
          other.balanceMinor == this.balanceMinor &&
          other.openedAt == this.openedAt &&
          other.position == this.position &&
          other.fetchedAt == this.fetchedAt);
}

class CachedAccountsCompanion extends UpdateCompanion<CachedAccount> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> iban;
  final Value<String> currency;
  final Value<BigInt> balanceMinor;
  final Value<DateTime> openedAt;
  final Value<int> position;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.iban = const Value.absent(),
    this.currency = const Value.absent(),
    this.balanceMinor = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.position = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAccountsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String iban,
    required String currency,
    required BigInt balanceMinor,
    required DateTime openedAt,
    required int position,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        iban = Value(iban),
        currency = Value(currency),
        balanceMinor = Value(balanceMinor),
        openedAt = Value(openedAt),
        position = Value(position),
        fetchedAt = Value(fetchedAt);
  static Insertable<CachedAccount> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? iban,
    Expression<String>? currency,
    Expression<BigInt>? balanceMinor,
    Expression<DateTime>? openedAt,
    Expression<int>? position,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (iban != null) 'iban': iban,
      if (currency != null) 'currency': currency,
      if (balanceMinor != null) 'balance_minor': balanceMinor,
      if (openedAt != null) 'opened_at': openedAt,
      if (position != null) 'position': position,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? iban,
      Value<String>? currency,
      Value<BigInt>? balanceMinor,
      Value<DateTime>? openedAt,
      Value<int>? position,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return CachedAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iban: iban ?? this.iban,
      currency: currency ?? this.currency,
      balanceMinor: balanceMinor ?? this.balanceMinor,
      openedAt: openedAt ?? this.openedAt,
      position: position ?? this.position,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (iban.present) {
      map['iban'] = Variable<String>(iban.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (balanceMinor.present) {
      map['balance_minor'] = Variable<BigInt>(balanceMinor.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iban: $iban, ')
          ..write('currency: $currency, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('openedAt: $openedAt, ')
          ..write('position: $position, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedBalancePointsTable extends CachedBalancePoints
    with TableInfo<$CachedBalancePointsTable, CachedBalancePoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedBalancePointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rangeDaysMeta =
      const VerificationMeta('rangeDays');
  @override
  late final GeneratedColumn<int> rangeDays = GeneratedColumn<int>(
      'range_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMinorMeta =
      const VerificationMeta('balanceMinor');
  @override
  late final GeneratedColumn<BigInt> balanceMinor = GeneratedColumn<BigInt>(
      'balance_minor', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [accountId, rangeDays, date, currency, balanceMinor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_balance_points';
  @override
  VerificationContext validateIntegrity(Insertable<CachedBalancePoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('range_days')) {
      context.handle(_rangeDaysMeta,
          rangeDays.isAcceptableOrUnknown(data['range_days']!, _rangeDaysMeta));
    } else if (isInserting) {
      context.missing(_rangeDaysMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('balance_minor')) {
      context.handle(
          _balanceMinorMeta,
          balanceMinor.isAcceptableOrUnknown(
              data['balance_minor']!, _balanceMinorMeta));
    } else if (isInserting) {
      context.missing(_balanceMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId, rangeDays, date};
  @override
  CachedBalancePoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedBalancePoint(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      rangeDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}range_days'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      balanceMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}balance_minor'])!,
    );
  }

  @override
  $CachedBalancePointsTable createAlias(String alias) {
    return $CachedBalancePointsTable(attachedDatabase, alias);
  }
}

class CachedBalancePoint extends DataClass
    implements Insertable<CachedBalancePoint> {
  final String accountId;
  final int rangeDays;
  final DateTime date;
  final String currency;
  final BigInt balanceMinor;
  const CachedBalancePoint(
      {required this.accountId,
      required this.rangeDays,
      required this.date,
      required this.currency,
      required this.balanceMinor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['range_days'] = Variable<int>(rangeDays);
    map['date'] = Variable<DateTime>(date);
    map['currency'] = Variable<String>(currency);
    map['balance_minor'] = Variable<BigInt>(balanceMinor);
    return map;
  }

  CachedBalancePointsCompanion toCompanion(bool nullToAbsent) {
    return CachedBalancePointsCompanion(
      accountId: Value(accountId),
      rangeDays: Value(rangeDays),
      date: Value(date),
      currency: Value(currency),
      balanceMinor: Value(balanceMinor),
    );
  }

  factory CachedBalancePoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedBalancePoint(
      accountId: serializer.fromJson<String>(json['accountId']),
      rangeDays: serializer.fromJson<int>(json['rangeDays']),
      date: serializer.fromJson<DateTime>(json['date']),
      currency: serializer.fromJson<String>(json['currency']),
      balanceMinor: serializer.fromJson<BigInt>(json['balanceMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'rangeDays': serializer.toJson<int>(rangeDays),
      'date': serializer.toJson<DateTime>(date),
      'currency': serializer.toJson<String>(currency),
      'balanceMinor': serializer.toJson<BigInt>(balanceMinor),
    };
  }

  CachedBalancePoint copyWith(
          {String? accountId,
          int? rangeDays,
          DateTime? date,
          String? currency,
          BigInt? balanceMinor}) =>
      CachedBalancePoint(
        accountId: accountId ?? this.accountId,
        rangeDays: rangeDays ?? this.rangeDays,
        date: date ?? this.date,
        currency: currency ?? this.currency,
        balanceMinor: balanceMinor ?? this.balanceMinor,
      );
  CachedBalancePoint copyWithCompanion(CachedBalancePointsCompanion data) {
    return CachedBalancePoint(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      rangeDays: data.rangeDays.present ? data.rangeDays.value : this.rangeDays,
      date: data.date.present ? data.date.value : this.date,
      currency: data.currency.present ? data.currency.value : this.currency,
      balanceMinor: data.balanceMinor.present
          ? data.balanceMinor.value
          : this.balanceMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedBalancePoint(')
          ..write('accountId: $accountId, ')
          ..write('rangeDays: $rangeDays, ')
          ..write('date: $date, ')
          ..write('currency: $currency, ')
          ..write('balanceMinor: $balanceMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(accountId, rangeDays, date, currency, balanceMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedBalancePoint &&
          other.accountId == this.accountId &&
          other.rangeDays == this.rangeDays &&
          other.date == this.date &&
          other.currency == this.currency &&
          other.balanceMinor == this.balanceMinor);
}

class CachedBalancePointsCompanion extends UpdateCompanion<CachedBalancePoint> {
  final Value<String> accountId;
  final Value<int> rangeDays;
  final Value<DateTime> date;
  final Value<String> currency;
  final Value<BigInt> balanceMinor;
  final Value<int> rowid;
  const CachedBalancePointsCompanion({
    this.accountId = const Value.absent(),
    this.rangeDays = const Value.absent(),
    this.date = const Value.absent(),
    this.currency = const Value.absent(),
    this.balanceMinor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedBalancePointsCompanion.insert({
    required String accountId,
    required int rangeDays,
    required DateTime date,
    required String currency,
    required BigInt balanceMinor,
    this.rowid = const Value.absent(),
  })  : accountId = Value(accountId),
        rangeDays = Value(rangeDays),
        date = Value(date),
        currency = Value(currency),
        balanceMinor = Value(balanceMinor);
  static Insertable<CachedBalancePoint> custom({
    Expression<String>? accountId,
    Expression<int>? rangeDays,
    Expression<DateTime>? date,
    Expression<String>? currency,
    Expression<BigInt>? balanceMinor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (rangeDays != null) 'range_days': rangeDays,
      if (date != null) 'date': date,
      if (currency != null) 'currency': currency,
      if (balanceMinor != null) 'balance_minor': balanceMinor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedBalancePointsCompanion copyWith(
      {Value<String>? accountId,
      Value<int>? rangeDays,
      Value<DateTime>? date,
      Value<String>? currency,
      Value<BigInt>? balanceMinor,
      Value<int>? rowid}) {
    return CachedBalancePointsCompanion(
      accountId: accountId ?? this.accountId,
      rangeDays: rangeDays ?? this.rangeDays,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      balanceMinor: balanceMinor ?? this.balanceMinor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (rangeDays.present) {
      map['range_days'] = Variable<int>(rangeDays.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (balanceMinor.present) {
      map['balance_minor'] = Variable<BigInt>(balanceMinor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedBalancePointsCompanion(')
          ..write('accountId: $accountId, ')
          ..write('rangeDays: $rangeDays, ')
          ..write('date: $date, ')
          ..write('currency: $currency, ')
          ..write('balanceMinor: $balanceMinor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedAccountsTable cachedAccounts = $CachedAccountsTable(this);
  late final $CachedBalancePointsTable cachedBalancePoints =
      $CachedBalancePointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cachedAccounts, cachedBalancePoints];
}

typedef $$CachedAccountsTableCreateCompanionBuilder = CachedAccountsCompanion
    Function({
  required String id,
  required String name,
  required String type,
  required String iban,
  required String currency,
  required BigInt balanceMinor,
  required DateTime openedAt,
  required int position,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$CachedAccountsTableUpdateCompanionBuilder = CachedAccountsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> iban,
  Value<String> currency,
  Value<BigInt> balanceMinor,
  Value<DateTime> openedAt,
  Value<int> position,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$CachedAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAccountsTable> {
  $$CachedAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iban => $composableBuilder(
      column: $table.iban, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get balanceMinor => $composableBuilder(
      column: $table.balanceMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAccountsTable> {
  $$CachedAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iban => $composableBuilder(
      column: $table.iban, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get balanceMinor => $composableBuilder(
      column: $table.balanceMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAccountsTable> {
  $$CachedAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get iban =>
      $composableBuilder(column: $table.iban, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<BigInt> get balanceMinor => $composableBuilder(
      column: $table.balanceMinor, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedAccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedAccountsTable,
    CachedAccount,
    $$CachedAccountsTableFilterComposer,
    $$CachedAccountsTableOrderingComposer,
    $$CachedAccountsTableAnnotationComposer,
    $$CachedAccountsTableCreateCompanionBuilder,
    $$CachedAccountsTableUpdateCompanionBuilder,
    (
      CachedAccount,
      BaseReferences<_$AppDatabase, $CachedAccountsTable, CachedAccount>
    ),
    CachedAccount,
    PrefetchHooks Function()> {
  $$CachedAccountsTableTableManager(
      _$AppDatabase db, $CachedAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> iban = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<BigInt> balanceMinor = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedAccountsCompanion(
            id: id,
            name: name,
            type: type,
            iban: iban,
            currency: currency,
            balanceMinor: balanceMinor,
            openedAt: openedAt,
            position: position,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String iban,
            required String currency,
            required BigInt balanceMinor,
            required DateTime openedAt,
            required int position,
            required DateTime fetchedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedAccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            iban: iban,
            currency: currency,
            balanceMinor: balanceMinor,
            openedAt: openedAt,
            position: position,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedAccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedAccountsTable,
    CachedAccount,
    $$CachedAccountsTableFilterComposer,
    $$CachedAccountsTableOrderingComposer,
    $$CachedAccountsTableAnnotationComposer,
    $$CachedAccountsTableCreateCompanionBuilder,
    $$CachedAccountsTableUpdateCompanionBuilder,
    (
      CachedAccount,
      BaseReferences<_$AppDatabase, $CachedAccountsTable, CachedAccount>
    ),
    CachedAccount,
    PrefetchHooks Function()>;
typedef $$CachedBalancePointsTableCreateCompanionBuilder
    = CachedBalancePointsCompanion Function({
  required String accountId,
  required int rangeDays,
  required DateTime date,
  required String currency,
  required BigInt balanceMinor,
  Value<int> rowid,
});
typedef $$CachedBalancePointsTableUpdateCompanionBuilder
    = CachedBalancePointsCompanion Function({
  Value<String> accountId,
  Value<int> rangeDays,
  Value<DateTime> date,
  Value<String> currency,
  Value<BigInt> balanceMinor,
  Value<int> rowid,
});

class $$CachedBalancePointsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedBalancePointsTable> {
  $$CachedBalancePointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rangeDays => $composableBuilder(
      column: $table.rangeDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get balanceMinor => $composableBuilder(
      column: $table.balanceMinor, builder: (column) => ColumnFilters(column));
}

class $$CachedBalancePointsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedBalancePointsTable> {
  $$CachedBalancePointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rangeDays => $composableBuilder(
      column: $table.rangeDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get balanceMinor => $composableBuilder(
      column: $table.balanceMinor,
      builder: (column) => ColumnOrderings(column));
}

class $$CachedBalancePointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedBalancePointsTable> {
  $$CachedBalancePointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get rangeDays =>
      $composableBuilder(column: $table.rangeDays, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<BigInt> get balanceMinor => $composableBuilder(
      column: $table.balanceMinor, builder: (column) => column);
}

class $$CachedBalancePointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedBalancePointsTable,
    CachedBalancePoint,
    $$CachedBalancePointsTableFilterComposer,
    $$CachedBalancePointsTableOrderingComposer,
    $$CachedBalancePointsTableAnnotationComposer,
    $$CachedBalancePointsTableCreateCompanionBuilder,
    $$CachedBalancePointsTableUpdateCompanionBuilder,
    (
      CachedBalancePoint,
      BaseReferences<_$AppDatabase, $CachedBalancePointsTable,
          CachedBalancePoint>
    ),
    CachedBalancePoint,
    PrefetchHooks Function()> {
  $$CachedBalancePointsTableTableManager(
      _$AppDatabase db, $CachedBalancePointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedBalancePointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedBalancePointsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedBalancePointsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> accountId = const Value.absent(),
            Value<int> rangeDays = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<BigInt> balanceMinor = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedBalancePointsCompanion(
            accountId: accountId,
            rangeDays: rangeDays,
            date: date,
            currency: currency,
            balanceMinor: balanceMinor,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String accountId,
            required int rangeDays,
            required DateTime date,
            required String currency,
            required BigInt balanceMinor,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedBalancePointsCompanion.insert(
            accountId: accountId,
            rangeDays: rangeDays,
            date: date,
            currency: currency,
            balanceMinor: balanceMinor,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedBalancePointsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedBalancePointsTable,
    CachedBalancePoint,
    $$CachedBalancePointsTableFilterComposer,
    $$CachedBalancePointsTableOrderingComposer,
    $$CachedBalancePointsTableAnnotationComposer,
    $$CachedBalancePointsTableCreateCompanionBuilder,
    $$CachedBalancePointsTableUpdateCompanionBuilder,
    (
      CachedBalancePoint,
      BaseReferences<_$AppDatabase, $CachedBalancePointsTable,
          CachedBalancePoint>
    ),
    CachedBalancePoint,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedAccountsTableTableManager get cachedAccounts =>
      $$CachedAccountsTableTableManager(_db, _db.cachedAccounts);
  $$CachedBalancePointsTableTableManager get cachedBalancePoints =>
      $$CachedBalancePointsTableTableManager(_db, _db.cachedBalancePoints);
}
