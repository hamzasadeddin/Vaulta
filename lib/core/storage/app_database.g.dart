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

class $OutboxTransfersTable extends OutboxTransfers
    with TableInfo<$OutboxTransfersTable, OutboxTransfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transferIdMeta =
      const VerificationMeta('transferId');
  @override
  late final GeneratedColumn<String> transferId = GeneratedColumn<String>(
      'transfer_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attentionMeta =
      const VerificationMeta('attention');
  @override
  late final GeneratedColumn<String> attention = GeneratedColumn<String>(
      'attention', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _serverErrorsMeta =
      const VerificationMeta('serverErrors');
  @override
  late final GeneratedColumn<int> serverErrors = GeneratedColumn<int>(
      'server_errors', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _queuedAtMeta =
      const VerificationMeta('queuedAt');
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
      'queued_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>('next_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceAccountIdMeta =
      const VerificationMeta('sourceAccountId');
  @override
  late final GeneratedColumn<String> sourceAccountId = GeneratedColumn<String>(
      'source_account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _destinationTypeMeta =
      const VerificationMeta('destinationType');
  @override
  late final GeneratedColumn<String> destinationType = GeneratedColumn<String>(
      'destination_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<String> destinationAccountId =
      GeneratedColumn<String>('destination_account_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _destinationBeneficiaryIdMeta =
      const VerificationMeta('destinationBeneficiaryId');
  @override
  late final GeneratedColumn<String> destinationBeneficiaryId =
      GeneratedColumn<String>('destination_beneficiary_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _destinationIbanMeta =
      const VerificationMeta('destinationIban');
  @override
  late final GeneratedColumn<String> destinationIban = GeneratedColumn<String>(
      'destination_iban', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _destinationHolderNameMeta =
      const VerificationMeta('destinationHolderName');
  @override
  late final GeneratedColumn<String> destinationHolderName =
      GeneratedColumn<String>('destination_holder_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMinorMeta =
      const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<BigInt> amountMinor = GeneratedColumn<BigInt>(
      'amount_minor', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledForMeta =
      const VerificationMeta('scheduledFor');
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
      'scheduled_for', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _destinationLabelMeta =
      const VerificationMeta('destinationLabel');
  @override
  late final GeneratedColumn<String> destinationLabel = GeneratedColumn<String>(
      'destination_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _destinationDetailMeta =
      const VerificationMeta('destinationDetail');
  @override
  late final GeneratedColumn<String> destinationDetail =
      GeneratedColumn<String>('destination_detail', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalDebitMinorMeta =
      const VerificationMeta('totalDebitMinor');
  @override
  late final GeneratedColumn<BigInt> totalDebitMinor = GeneratedColumn<BigInt>(
      'total_debit_minor', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _destinationAmountMinorMeta =
      const VerificationMeta('destinationAmountMinor');
  @override
  late final GeneratedColumn<BigInt> destinationAmountMinor =
      GeneratedColumn<BigInt>('destination_amount_minor', aliasedName, false,
          type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _destinationCurrencyMeta =
      const VerificationMeta('destinationCurrency');
  @override
  late final GeneratedColumn<String> destinationCurrency =
      GeneratedColumn<String>('destination_currency', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transferId,
        idempotencyKey,
        status,
        attention,
        attempts,
        serverErrors,
        queuedAt,
        nextAttemptAt,
        reference,
        sourceAccountId,
        destinationType,
        destinationAccountId,
        destinationBeneficiaryId,
        destinationIban,
        destinationHolderName,
        amountMinor,
        currency,
        note,
        scheduledFor,
        destinationLabel,
        destinationDetail,
        totalDebitMinor,
        destinationAmountMinor,
        destinationCurrency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_transfers';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxTransfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
          _transferIdMeta,
          transferId.isAcceptableOrUnknown(
              data['transfer_id']!, _transferIdMeta));
    } else if (isInserting) {
      context.missing(_transferIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attention')) {
      context.handle(_attentionMeta,
          attention.isAcceptableOrUnknown(data['attention']!, _attentionMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('server_errors')) {
      context.handle(
          _serverErrorsMeta,
          serverErrors.isAcceptableOrUnknown(
              data['server_errors']!, _serverErrorsMeta));
    }
    if (data.containsKey('queued_at')) {
      context.handle(_queuedAtMeta,
          queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta));
    } else if (isInserting) {
      context.missing(_queuedAtMeta);
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
          _sourceAccountIdMeta,
          sourceAccountId.isAcceptableOrUnknown(
              data['source_account_id']!, _sourceAccountIdMeta));
    } else if (isInserting) {
      context.missing(_sourceAccountIdMeta);
    }
    if (data.containsKey('destination_type')) {
      context.handle(
          _destinationTypeMeta,
          destinationType.isAcceptableOrUnknown(
              data['destination_type']!, _destinationTypeMeta));
    } else if (isInserting) {
      context.missing(_destinationTypeMeta);
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
          _destinationAccountIdMeta,
          destinationAccountId.isAcceptableOrUnknown(
              data['destination_account_id']!, _destinationAccountIdMeta));
    }
    if (data.containsKey('destination_beneficiary_id')) {
      context.handle(
          _destinationBeneficiaryIdMeta,
          destinationBeneficiaryId.isAcceptableOrUnknown(
              data['destination_beneficiary_id']!,
              _destinationBeneficiaryIdMeta));
    }
    if (data.containsKey('destination_iban')) {
      context.handle(
          _destinationIbanMeta,
          destinationIban.isAcceptableOrUnknown(
              data['destination_iban']!, _destinationIbanMeta));
    }
    if (data.containsKey('destination_holder_name')) {
      context.handle(
          _destinationHolderNameMeta,
          destinationHolderName.isAcceptableOrUnknown(
              data['destination_holder_name']!, _destinationHolderNameMeta));
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
          _amountMinorMeta,
          amountMinor.isAcceptableOrUnknown(
              data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
          _scheduledForMeta,
          scheduledFor.isAcceptableOrUnknown(
              data['scheduled_for']!, _scheduledForMeta));
    }
    if (data.containsKey('destination_label')) {
      context.handle(
          _destinationLabelMeta,
          destinationLabel.isAcceptableOrUnknown(
              data['destination_label']!, _destinationLabelMeta));
    } else if (isInserting) {
      context.missing(_destinationLabelMeta);
    }
    if (data.containsKey('destination_detail')) {
      context.handle(
          _destinationDetailMeta,
          destinationDetail.isAcceptableOrUnknown(
              data['destination_detail']!, _destinationDetailMeta));
    } else if (isInserting) {
      context.missing(_destinationDetailMeta);
    }
    if (data.containsKey('total_debit_minor')) {
      context.handle(
          _totalDebitMinorMeta,
          totalDebitMinor.isAcceptableOrUnknown(
              data['total_debit_minor']!, _totalDebitMinorMeta));
    } else if (isInserting) {
      context.missing(_totalDebitMinorMeta);
    }
    if (data.containsKey('destination_amount_minor')) {
      context.handle(
          _destinationAmountMinorMeta,
          destinationAmountMinor.isAcceptableOrUnknown(
              data['destination_amount_minor']!, _destinationAmountMinorMeta));
    } else if (isInserting) {
      context.missing(_destinationAmountMinorMeta);
    }
    if (data.containsKey('destination_currency')) {
      context.handle(
          _destinationCurrencyMeta,
          destinationCurrency.isAcceptableOrUnknown(
              data['destination_currency']!, _destinationCurrencyMeta));
    } else if (isInserting) {
      context.missing(_destinationCurrencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxTransfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transferId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transfer_id'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      attention: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attention']),
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      serverErrors: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_errors'])!,
      queuedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}queued_at'])!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_attempt_at']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      sourceAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_account_id'])!,
      destinationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_type'])!,
      destinationAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}destination_account_id']),
      destinationBeneficiaryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}destination_beneficiary_id']),
      destinationIban: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_iban']),
      destinationHolderName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}destination_holder_name']),
      amountMinor: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      scheduledFor: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_for']),
      destinationLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_label'])!,
      destinationDetail: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_detail'])!,
      totalDebitMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.bigInt, data['${effectivePrefix}total_debit_minor'])!,
      destinationAmountMinor: attachedDatabase.typeMapping.read(
          DriftSqlType.bigInt,
          data['${effectivePrefix}destination_amount_minor'])!,
      destinationCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}destination_currency'])!,
    );
  }

  @override
  $OutboxTransfersTable createAlias(String alias) {
    return $OutboxTransfersTable(attachedDatabase, alias);
  }
}

class OutboxTransfer extends DataClass implements Insertable<OutboxTransfer> {
  /// Local id — not the transfer id. An entry exists before the server
  /// has agreed to anything and outlives being re-priced.
  final String id;
  final String transferId;
  final String idempotencyKey;

  /// `OutboxStatus.name`. Stored as text rather than an index so a
  /// reordered enum cannot silently re-label existing rows.
  final String status;

  /// `OutboxAttention.name`, null unless the status needs a person.
  final String? attention;
  final int attempts;
  final int serverErrors;
  final DateTime queuedAt;
  final DateTime? nextAttemptAt;

  /// Set once delivered, for the "this went through" notice.
  final String? reference;
  final String sourceAccountId;

  /// `own` | `beneficiary` | `iban`, mirroring the wire's destination
  /// discriminator. The sealed union is reassembled in the data source.
  final String destinationType;
  final String? destinationAccountId;
  final String? destinationBeneficiaryId;
  final String? destinationIban;
  final String? destinationHolderName;
  final BigInt amountMinor;
  final String currency;
  final String? note;
  final DateTime? scheduledFor;
  final String destinationLabel;
  final String destinationDetail;
  final BigInt totalDebitMinor;
  final BigInt destinationAmountMinor;
  final String destinationCurrency;
  const OutboxTransfer(
      {required this.id,
      required this.transferId,
      required this.idempotencyKey,
      required this.status,
      this.attention,
      required this.attempts,
      required this.serverErrors,
      required this.queuedAt,
      this.nextAttemptAt,
      this.reference,
      required this.sourceAccountId,
      required this.destinationType,
      this.destinationAccountId,
      this.destinationBeneficiaryId,
      this.destinationIban,
      this.destinationHolderName,
      required this.amountMinor,
      required this.currency,
      this.note,
      this.scheduledFor,
      required this.destinationLabel,
      required this.destinationDetail,
      required this.totalDebitMinor,
      required this.destinationAmountMinor,
      required this.destinationCurrency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transfer_id'] = Variable<String>(transferId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || attention != null) {
      map['attention'] = Variable<String>(attention);
    }
    map['attempts'] = Variable<int>(attempts);
    map['server_errors'] = Variable<int>(serverErrors);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['source_account_id'] = Variable<String>(sourceAccountId);
    map['destination_type'] = Variable<String>(destinationType);
    if (!nullToAbsent || destinationAccountId != null) {
      map['destination_account_id'] = Variable<String>(destinationAccountId);
    }
    if (!nullToAbsent || destinationBeneficiaryId != null) {
      map['destination_beneficiary_id'] =
          Variable<String>(destinationBeneficiaryId);
    }
    if (!nullToAbsent || destinationIban != null) {
      map['destination_iban'] = Variable<String>(destinationIban);
    }
    if (!nullToAbsent || destinationHolderName != null) {
      map['destination_holder_name'] = Variable<String>(destinationHolderName);
    }
    map['amount_minor'] = Variable<BigInt>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || scheduledFor != null) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    }
    map['destination_label'] = Variable<String>(destinationLabel);
    map['destination_detail'] = Variable<String>(destinationDetail);
    map['total_debit_minor'] = Variable<BigInt>(totalDebitMinor);
    map['destination_amount_minor'] = Variable<BigInt>(destinationAmountMinor);
    map['destination_currency'] = Variable<String>(destinationCurrency);
    return map;
  }

  OutboxTransfersCompanion toCompanion(bool nullToAbsent) {
    return OutboxTransfersCompanion(
      id: Value(id),
      transferId: Value(transferId),
      idempotencyKey: Value(idempotencyKey),
      status: Value(status),
      attention: attention == null && nullToAbsent
          ? const Value.absent()
          : Value(attention),
      attempts: Value(attempts),
      serverErrors: Value(serverErrors),
      queuedAt: Value(queuedAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      sourceAccountId: Value(sourceAccountId),
      destinationType: Value(destinationType),
      destinationAccountId: destinationAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAccountId),
      destinationBeneficiaryId: destinationBeneficiaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationBeneficiaryId),
      destinationIban: destinationIban == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationIban),
      destinationHolderName: destinationHolderName == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationHolderName),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      scheduledFor: scheduledFor == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledFor),
      destinationLabel: Value(destinationLabel),
      destinationDetail: Value(destinationDetail),
      totalDebitMinor: Value(totalDebitMinor),
      destinationAmountMinor: Value(destinationAmountMinor),
      destinationCurrency: Value(destinationCurrency),
    );
  }

  factory OutboxTransfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxTransfer(
      id: serializer.fromJson<String>(json['id']),
      transferId: serializer.fromJson<String>(json['transferId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      status: serializer.fromJson<String>(json['status']),
      attention: serializer.fromJson<String?>(json['attention']),
      attempts: serializer.fromJson<int>(json['attempts']),
      serverErrors: serializer.fromJson<int>(json['serverErrors']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      reference: serializer.fromJson<String?>(json['reference']),
      sourceAccountId: serializer.fromJson<String>(json['sourceAccountId']),
      destinationType: serializer.fromJson<String>(json['destinationType']),
      destinationAccountId:
          serializer.fromJson<String?>(json['destinationAccountId']),
      destinationBeneficiaryId:
          serializer.fromJson<String?>(json['destinationBeneficiaryId']),
      destinationIban: serializer.fromJson<String?>(json['destinationIban']),
      destinationHolderName:
          serializer.fromJson<String?>(json['destinationHolderName']),
      amountMinor: serializer.fromJson<BigInt>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      note: serializer.fromJson<String?>(json['note']),
      scheduledFor: serializer.fromJson<DateTime?>(json['scheduledFor']),
      destinationLabel: serializer.fromJson<String>(json['destinationLabel']),
      destinationDetail: serializer.fromJson<String>(json['destinationDetail']),
      totalDebitMinor: serializer.fromJson<BigInt>(json['totalDebitMinor']),
      destinationAmountMinor:
          serializer.fromJson<BigInt>(json['destinationAmountMinor']),
      destinationCurrency:
          serializer.fromJson<String>(json['destinationCurrency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transferId': serializer.toJson<String>(transferId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'status': serializer.toJson<String>(status),
      'attention': serializer.toJson<String?>(attention),
      'attempts': serializer.toJson<int>(attempts),
      'serverErrors': serializer.toJson<int>(serverErrors),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'reference': serializer.toJson<String?>(reference),
      'sourceAccountId': serializer.toJson<String>(sourceAccountId),
      'destinationType': serializer.toJson<String>(destinationType),
      'destinationAccountId': serializer.toJson<String?>(destinationAccountId),
      'destinationBeneficiaryId':
          serializer.toJson<String?>(destinationBeneficiaryId),
      'destinationIban': serializer.toJson<String?>(destinationIban),
      'destinationHolderName':
          serializer.toJson<String?>(destinationHolderName),
      'amountMinor': serializer.toJson<BigInt>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'note': serializer.toJson<String?>(note),
      'scheduledFor': serializer.toJson<DateTime?>(scheduledFor),
      'destinationLabel': serializer.toJson<String>(destinationLabel),
      'destinationDetail': serializer.toJson<String>(destinationDetail),
      'totalDebitMinor': serializer.toJson<BigInt>(totalDebitMinor),
      'destinationAmountMinor':
          serializer.toJson<BigInt>(destinationAmountMinor),
      'destinationCurrency': serializer.toJson<String>(destinationCurrency),
    };
  }

  OutboxTransfer copyWith(
          {String? id,
          String? transferId,
          String? idempotencyKey,
          String? status,
          Value<String?> attention = const Value.absent(),
          int? attempts,
          int? serverErrors,
          DateTime? queuedAt,
          Value<DateTime?> nextAttemptAt = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          String? sourceAccountId,
          String? destinationType,
          Value<String?> destinationAccountId = const Value.absent(),
          Value<String?> destinationBeneficiaryId = const Value.absent(),
          Value<String?> destinationIban = const Value.absent(),
          Value<String?> destinationHolderName = const Value.absent(),
          BigInt? amountMinor,
          String? currency,
          Value<String?> note = const Value.absent(),
          Value<DateTime?> scheduledFor = const Value.absent(),
          String? destinationLabel,
          String? destinationDetail,
          BigInt? totalDebitMinor,
          BigInt? destinationAmountMinor,
          String? destinationCurrency}) =>
      OutboxTransfer(
        id: id ?? this.id,
        transferId: transferId ?? this.transferId,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        status: status ?? this.status,
        attention: attention.present ? attention.value : this.attention,
        attempts: attempts ?? this.attempts,
        serverErrors: serverErrors ?? this.serverErrors,
        queuedAt: queuedAt ?? this.queuedAt,
        nextAttemptAt:
            nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
        reference: reference.present ? reference.value : this.reference,
        sourceAccountId: sourceAccountId ?? this.sourceAccountId,
        destinationType: destinationType ?? this.destinationType,
        destinationAccountId: destinationAccountId.present
            ? destinationAccountId.value
            : this.destinationAccountId,
        destinationBeneficiaryId: destinationBeneficiaryId.present
            ? destinationBeneficiaryId.value
            : this.destinationBeneficiaryId,
        destinationIban: destinationIban.present
            ? destinationIban.value
            : this.destinationIban,
        destinationHolderName: destinationHolderName.present
            ? destinationHolderName.value
            : this.destinationHolderName,
        amountMinor: amountMinor ?? this.amountMinor,
        currency: currency ?? this.currency,
        note: note.present ? note.value : this.note,
        scheduledFor:
            scheduledFor.present ? scheduledFor.value : this.scheduledFor,
        destinationLabel: destinationLabel ?? this.destinationLabel,
        destinationDetail: destinationDetail ?? this.destinationDetail,
        totalDebitMinor: totalDebitMinor ?? this.totalDebitMinor,
        destinationAmountMinor:
            destinationAmountMinor ?? this.destinationAmountMinor,
        destinationCurrency: destinationCurrency ?? this.destinationCurrency,
      );
  OutboxTransfer copyWithCompanion(OutboxTransfersCompanion data) {
    return OutboxTransfer(
      id: data.id.present ? data.id.value : this.id,
      transferId:
          data.transferId.present ? data.transferId.value : this.transferId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      status: data.status.present ? data.status.value : this.status,
      attention: data.attention.present ? data.attention.value : this.attention,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      serverErrors: data.serverErrors.present
          ? data.serverErrors.value
          : this.serverErrors,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      reference: data.reference.present ? data.reference.value : this.reference,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      destinationType: data.destinationType.present
          ? data.destinationType.value
          : this.destinationType,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      destinationBeneficiaryId: data.destinationBeneficiaryId.present
          ? data.destinationBeneficiaryId.value
          : this.destinationBeneficiaryId,
      destinationIban: data.destinationIban.present
          ? data.destinationIban.value
          : this.destinationIban,
      destinationHolderName: data.destinationHolderName.present
          ? data.destinationHolderName.value
          : this.destinationHolderName,
      amountMinor:
          data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      note: data.note.present ? data.note.value : this.note,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      destinationLabel: data.destinationLabel.present
          ? data.destinationLabel.value
          : this.destinationLabel,
      destinationDetail: data.destinationDetail.present
          ? data.destinationDetail.value
          : this.destinationDetail,
      totalDebitMinor: data.totalDebitMinor.present
          ? data.totalDebitMinor.value
          : this.totalDebitMinor,
      destinationAmountMinor: data.destinationAmountMinor.present
          ? data.destinationAmountMinor.value
          : this.destinationAmountMinor,
      destinationCurrency: data.destinationCurrency.present
          ? data.destinationCurrency.value
          : this.destinationCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxTransfer(')
          ..write('id: $id, ')
          ..write('transferId: $transferId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('attention: $attention, ')
          ..write('attempts: $attempts, ')
          ..write('serverErrors: $serverErrors, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('reference: $reference, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationType: $destinationType, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('destinationBeneficiaryId: $destinationBeneficiaryId, ')
          ..write('destinationIban: $destinationIban, ')
          ..write('destinationHolderName: $destinationHolderName, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('destinationLabel: $destinationLabel, ')
          ..write('destinationDetail: $destinationDetail, ')
          ..write('totalDebitMinor: $totalDebitMinor, ')
          ..write('destinationAmountMinor: $destinationAmountMinor, ')
          ..write('destinationCurrency: $destinationCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        transferId,
        idempotencyKey,
        status,
        attention,
        attempts,
        serverErrors,
        queuedAt,
        nextAttemptAt,
        reference,
        sourceAccountId,
        destinationType,
        destinationAccountId,
        destinationBeneficiaryId,
        destinationIban,
        destinationHolderName,
        amountMinor,
        currency,
        note,
        scheduledFor,
        destinationLabel,
        destinationDetail,
        totalDebitMinor,
        destinationAmountMinor,
        destinationCurrency
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxTransfer &&
          other.id == this.id &&
          other.transferId == this.transferId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.status == this.status &&
          other.attention == this.attention &&
          other.attempts == this.attempts &&
          other.serverErrors == this.serverErrors &&
          other.queuedAt == this.queuedAt &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.reference == this.reference &&
          other.sourceAccountId == this.sourceAccountId &&
          other.destinationType == this.destinationType &&
          other.destinationAccountId == this.destinationAccountId &&
          other.destinationBeneficiaryId == this.destinationBeneficiaryId &&
          other.destinationIban == this.destinationIban &&
          other.destinationHolderName == this.destinationHolderName &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.note == this.note &&
          other.scheduledFor == this.scheduledFor &&
          other.destinationLabel == this.destinationLabel &&
          other.destinationDetail == this.destinationDetail &&
          other.totalDebitMinor == this.totalDebitMinor &&
          other.destinationAmountMinor == this.destinationAmountMinor &&
          other.destinationCurrency == this.destinationCurrency);
}

class OutboxTransfersCompanion extends UpdateCompanion<OutboxTransfer> {
  final Value<String> id;
  final Value<String> transferId;
  final Value<String> idempotencyKey;
  final Value<String> status;
  final Value<String?> attention;
  final Value<int> attempts;
  final Value<int> serverErrors;
  final Value<DateTime> queuedAt;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> reference;
  final Value<String> sourceAccountId;
  final Value<String> destinationType;
  final Value<String?> destinationAccountId;
  final Value<String?> destinationBeneficiaryId;
  final Value<String?> destinationIban;
  final Value<String?> destinationHolderName;
  final Value<BigInt> amountMinor;
  final Value<String> currency;
  final Value<String?> note;
  final Value<DateTime?> scheduledFor;
  final Value<String> destinationLabel;
  final Value<String> destinationDetail;
  final Value<BigInt> totalDebitMinor;
  final Value<BigInt> destinationAmountMinor;
  final Value<String> destinationCurrency;
  final Value<int> rowid;
  const OutboxTransfersCompanion({
    this.id = const Value.absent(),
    this.transferId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.status = const Value.absent(),
    this.attention = const Value.absent(),
    this.attempts = const Value.absent(),
    this.serverErrors = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.reference = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.destinationType = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.destinationBeneficiaryId = const Value.absent(),
    this.destinationIban = const Value.absent(),
    this.destinationHolderName = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.destinationLabel = const Value.absent(),
    this.destinationDetail = const Value.absent(),
    this.totalDebitMinor = const Value.absent(),
    this.destinationAmountMinor = const Value.absent(),
    this.destinationCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxTransfersCompanion.insert({
    required String id,
    required String transferId,
    required String idempotencyKey,
    required String status,
    this.attention = const Value.absent(),
    this.attempts = const Value.absent(),
    this.serverErrors = const Value.absent(),
    required DateTime queuedAt,
    this.nextAttemptAt = const Value.absent(),
    this.reference = const Value.absent(),
    required String sourceAccountId,
    required String destinationType,
    this.destinationAccountId = const Value.absent(),
    this.destinationBeneficiaryId = const Value.absent(),
    this.destinationIban = const Value.absent(),
    this.destinationHolderName = const Value.absent(),
    required BigInt amountMinor,
    required String currency,
    this.note = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    required String destinationLabel,
    required String destinationDetail,
    required BigInt totalDebitMinor,
    required BigInt destinationAmountMinor,
    required String destinationCurrency,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        transferId = Value(transferId),
        idempotencyKey = Value(idempotencyKey),
        status = Value(status),
        queuedAt = Value(queuedAt),
        sourceAccountId = Value(sourceAccountId),
        destinationType = Value(destinationType),
        amountMinor = Value(amountMinor),
        currency = Value(currency),
        destinationLabel = Value(destinationLabel),
        destinationDetail = Value(destinationDetail),
        totalDebitMinor = Value(totalDebitMinor),
        destinationAmountMinor = Value(destinationAmountMinor),
        destinationCurrency = Value(destinationCurrency);
  static Insertable<OutboxTransfer> custom({
    Expression<String>? id,
    Expression<String>? transferId,
    Expression<String>? idempotencyKey,
    Expression<String>? status,
    Expression<String>? attention,
    Expression<int>? attempts,
    Expression<int>? serverErrors,
    Expression<DateTime>? queuedAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? reference,
    Expression<String>? sourceAccountId,
    Expression<String>? destinationType,
    Expression<String>? destinationAccountId,
    Expression<String>? destinationBeneficiaryId,
    Expression<String>? destinationIban,
    Expression<String>? destinationHolderName,
    Expression<BigInt>? amountMinor,
    Expression<String>? currency,
    Expression<String>? note,
    Expression<DateTime>? scheduledFor,
    Expression<String>? destinationLabel,
    Expression<String>? destinationDetail,
    Expression<BigInt>? totalDebitMinor,
    Expression<BigInt>? destinationAmountMinor,
    Expression<String>? destinationCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transferId != null) 'transfer_id': transferId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (status != null) 'status': status,
      if (attention != null) 'attention': attention,
      if (attempts != null) 'attempts': attempts,
      if (serverErrors != null) 'server_errors': serverErrors,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (reference != null) 'reference': reference,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (destinationType != null) 'destination_type': destinationType,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (destinationBeneficiaryId != null)
        'destination_beneficiary_id': destinationBeneficiaryId,
      if (destinationIban != null) 'destination_iban': destinationIban,
      if (destinationHolderName != null)
        'destination_holder_name': destinationHolderName,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (note != null) 'note': note,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (destinationLabel != null) 'destination_label': destinationLabel,
      if (destinationDetail != null) 'destination_detail': destinationDetail,
      if (totalDebitMinor != null) 'total_debit_minor': totalDebitMinor,
      if (destinationAmountMinor != null)
        'destination_amount_minor': destinationAmountMinor,
      if (destinationCurrency != null)
        'destination_currency': destinationCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxTransfersCompanion copyWith(
      {Value<String>? id,
      Value<String>? transferId,
      Value<String>? idempotencyKey,
      Value<String>? status,
      Value<String?>? attention,
      Value<int>? attempts,
      Value<int>? serverErrors,
      Value<DateTime>? queuedAt,
      Value<DateTime?>? nextAttemptAt,
      Value<String?>? reference,
      Value<String>? sourceAccountId,
      Value<String>? destinationType,
      Value<String?>? destinationAccountId,
      Value<String?>? destinationBeneficiaryId,
      Value<String?>? destinationIban,
      Value<String?>? destinationHolderName,
      Value<BigInt>? amountMinor,
      Value<String>? currency,
      Value<String?>? note,
      Value<DateTime?>? scheduledFor,
      Value<String>? destinationLabel,
      Value<String>? destinationDetail,
      Value<BigInt>? totalDebitMinor,
      Value<BigInt>? destinationAmountMinor,
      Value<String>? destinationCurrency,
      Value<int>? rowid}) {
    return OutboxTransfersCompanion(
      id: id ?? this.id,
      transferId: transferId ?? this.transferId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      status: status ?? this.status,
      attention: attention ?? this.attention,
      attempts: attempts ?? this.attempts,
      serverErrors: serverErrors ?? this.serverErrors,
      queuedAt: queuedAt ?? this.queuedAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      reference: reference ?? this.reference,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destinationType: destinationType ?? this.destinationType,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      destinationBeneficiaryId:
          destinationBeneficiaryId ?? this.destinationBeneficiaryId,
      destinationIban: destinationIban ?? this.destinationIban,
      destinationHolderName:
          destinationHolderName ?? this.destinationHolderName,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      note: note ?? this.note,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      destinationLabel: destinationLabel ?? this.destinationLabel,
      destinationDetail: destinationDetail ?? this.destinationDetail,
      totalDebitMinor: totalDebitMinor ?? this.totalDebitMinor,
      destinationAmountMinor:
          destinationAmountMinor ?? this.destinationAmountMinor,
      destinationCurrency: destinationCurrency ?? this.destinationCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<String>(transferId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attention.present) {
      map['attention'] = Variable<String>(attention.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (serverErrors.present) {
      map['server_errors'] = Variable<int>(serverErrors.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<String>(sourceAccountId.value);
    }
    if (destinationType.present) {
      map['destination_type'] = Variable<String>(destinationType.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] =
          Variable<String>(destinationAccountId.value);
    }
    if (destinationBeneficiaryId.present) {
      map['destination_beneficiary_id'] =
          Variable<String>(destinationBeneficiaryId.value);
    }
    if (destinationIban.present) {
      map['destination_iban'] = Variable<String>(destinationIban.value);
    }
    if (destinationHolderName.present) {
      map['destination_holder_name'] =
          Variable<String>(destinationHolderName.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<BigInt>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (destinationLabel.present) {
      map['destination_label'] = Variable<String>(destinationLabel.value);
    }
    if (destinationDetail.present) {
      map['destination_detail'] = Variable<String>(destinationDetail.value);
    }
    if (totalDebitMinor.present) {
      map['total_debit_minor'] = Variable<BigInt>(totalDebitMinor.value);
    }
    if (destinationAmountMinor.present) {
      map['destination_amount_minor'] =
          Variable<BigInt>(destinationAmountMinor.value);
    }
    if (destinationCurrency.present) {
      map['destination_currency'] = Variable<String>(destinationCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxTransfersCompanion(')
          ..write('id: $id, ')
          ..write('transferId: $transferId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('attention: $attention, ')
          ..write('attempts: $attempts, ')
          ..write('serverErrors: $serverErrors, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('reference: $reference, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationType: $destinationType, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('destinationBeneficiaryId: $destinationBeneficiaryId, ')
          ..write('destinationIban: $destinationIban, ')
          ..write('destinationHolderName: $destinationHolderName, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('destinationLabel: $destinationLabel, ')
          ..write('destinationDetail: $destinationDetail, ')
          ..write('totalDebitMinor: $totalDebitMinor, ')
          ..write('destinationAmountMinor: $destinationAmountMinor, ')
          ..write('destinationCurrency: $destinationCurrency, ')
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
  late final $OutboxTransfersTable outboxTransfers =
      $OutboxTransfersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cachedAccounts, cachedBalancePoints, outboxTransfers];
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
typedef $$OutboxTransfersTableCreateCompanionBuilder = OutboxTransfersCompanion
    Function({
  required String id,
  required String transferId,
  required String idempotencyKey,
  required String status,
  Value<String?> attention,
  Value<int> attempts,
  Value<int> serverErrors,
  required DateTime queuedAt,
  Value<DateTime?> nextAttemptAt,
  Value<String?> reference,
  required String sourceAccountId,
  required String destinationType,
  Value<String?> destinationAccountId,
  Value<String?> destinationBeneficiaryId,
  Value<String?> destinationIban,
  Value<String?> destinationHolderName,
  required BigInt amountMinor,
  required String currency,
  Value<String?> note,
  Value<DateTime?> scheduledFor,
  required String destinationLabel,
  required String destinationDetail,
  required BigInt totalDebitMinor,
  required BigInt destinationAmountMinor,
  required String destinationCurrency,
  Value<int> rowid,
});
typedef $$OutboxTransfersTableUpdateCompanionBuilder = OutboxTransfersCompanion
    Function({
  Value<String> id,
  Value<String> transferId,
  Value<String> idempotencyKey,
  Value<String> status,
  Value<String?> attention,
  Value<int> attempts,
  Value<int> serverErrors,
  Value<DateTime> queuedAt,
  Value<DateTime?> nextAttemptAt,
  Value<String?> reference,
  Value<String> sourceAccountId,
  Value<String> destinationType,
  Value<String?> destinationAccountId,
  Value<String?> destinationBeneficiaryId,
  Value<String?> destinationIban,
  Value<String?> destinationHolderName,
  Value<BigInt> amountMinor,
  Value<String> currency,
  Value<String?> note,
  Value<DateTime?> scheduledFor,
  Value<String> destinationLabel,
  Value<String> destinationDetail,
  Value<BigInt> totalDebitMinor,
  Value<BigInt> destinationAmountMinor,
  Value<String> destinationCurrency,
  Value<int> rowid,
});

class $$OutboxTransfersTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTransfersTable> {
  $$OutboxTransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferId => $composableBuilder(
      column: $table.transferId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attention => $composableBuilder(
      column: $table.attention, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverErrors => $composableBuilder(
      column: $table.serverErrors, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
      column: $table.queuedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceAccountId => $composableBuilder(
      column: $table.sourceAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationType => $composableBuilder(
      column: $table.destinationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationAccountId => $composableBuilder(
      column: $table.destinationAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationBeneficiaryId => $composableBuilder(
      column: $table.destinationBeneficiaryId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationIban => $composableBuilder(
      column: $table.destinationIban,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationHolderName => $composableBuilder(
      column: $table.destinationHolderName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationLabel => $composableBuilder(
      column: $table.destinationLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationDetail => $composableBuilder(
      column: $table.destinationDetail,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get totalDebitMinor => $composableBuilder(
      column: $table.totalDebitMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get destinationAmountMinor => $composableBuilder(
      column: $table.destinationAmountMinor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destinationCurrency => $composableBuilder(
      column: $table.destinationCurrency,
      builder: (column) => ColumnFilters(column));
}

class $$OutboxTransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTransfersTable> {
  $$OutboxTransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferId => $composableBuilder(
      column: $table.transferId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attention => $composableBuilder(
      column: $table.attention, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverErrors => $composableBuilder(
      column: $table.serverErrors,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
      column: $table.queuedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceAccountId => $composableBuilder(
      column: $table.sourceAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationType => $composableBuilder(
      column: $table.destinationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationAccountId => $composableBuilder(
      column: $table.destinationAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationBeneficiaryId => $composableBuilder(
      column: $table.destinationBeneficiaryId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationIban => $composableBuilder(
      column: $table.destinationIban,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationHolderName => $composableBuilder(
      column: $table.destinationHolderName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationLabel => $composableBuilder(
      column: $table.destinationLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationDetail => $composableBuilder(
      column: $table.destinationDetail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get totalDebitMinor => $composableBuilder(
      column: $table.totalDebitMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get destinationAmountMinor => $composableBuilder(
      column: $table.destinationAmountMinor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destinationCurrency => $composableBuilder(
      column: $table.destinationCurrency,
      builder: (column) => ColumnOrderings(column));
}

class $$OutboxTransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTransfersTable> {
  $$OutboxTransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transferId => $composableBuilder(
      column: $table.transferId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get attention =>
      $composableBuilder(column: $table.attention, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get serverErrors => $composableBuilder(
      column: $table.serverErrors, builder: (column) => column);

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get sourceAccountId => $composableBuilder(
      column: $table.sourceAccountId, builder: (column) => column);

  GeneratedColumn<String> get destinationType => $composableBuilder(
      column: $table.destinationType, builder: (column) => column);

  GeneratedColumn<String> get destinationAccountId => $composableBuilder(
      column: $table.destinationAccountId, builder: (column) => column);

  GeneratedColumn<String> get destinationBeneficiaryId => $composableBuilder(
      column: $table.destinationBeneficiaryId, builder: (column) => column);

  GeneratedColumn<String> get destinationIban => $composableBuilder(
      column: $table.destinationIban, builder: (column) => column);

  GeneratedColumn<String> get destinationHolderName => $composableBuilder(
      column: $table.destinationHolderName, builder: (column) => column);

  GeneratedColumn<BigInt> get amountMinor => $composableBuilder(
      column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
      column: $table.scheduledFor, builder: (column) => column);

  GeneratedColumn<String> get destinationLabel => $composableBuilder(
      column: $table.destinationLabel, builder: (column) => column);

  GeneratedColumn<String> get destinationDetail => $composableBuilder(
      column: $table.destinationDetail, builder: (column) => column);

  GeneratedColumn<BigInt> get totalDebitMinor => $composableBuilder(
      column: $table.totalDebitMinor, builder: (column) => column);

  GeneratedColumn<BigInt> get destinationAmountMinor => $composableBuilder(
      column: $table.destinationAmountMinor, builder: (column) => column);

  GeneratedColumn<String> get destinationCurrency => $composableBuilder(
      column: $table.destinationCurrency, builder: (column) => column);
}

class $$OutboxTransfersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OutboxTransfersTable,
    OutboxTransfer,
    $$OutboxTransfersTableFilterComposer,
    $$OutboxTransfersTableOrderingComposer,
    $$OutboxTransfersTableAnnotationComposer,
    $$OutboxTransfersTableCreateCompanionBuilder,
    $$OutboxTransfersTableUpdateCompanionBuilder,
    (
      OutboxTransfer,
      BaseReferences<_$AppDatabase, $OutboxTransfersTable, OutboxTransfer>
    ),
    OutboxTransfer,
    PrefetchHooks Function()> {
  $$OutboxTransfersTableTableManager(
      _$AppDatabase db, $OutboxTransfersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transferId = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> attention = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> serverErrors = const Value.absent(),
            Value<DateTime> queuedAt = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<String> sourceAccountId = const Value.absent(),
            Value<String> destinationType = const Value.absent(),
            Value<String?> destinationAccountId = const Value.absent(),
            Value<String?> destinationBeneficiaryId = const Value.absent(),
            Value<String?> destinationIban = const Value.absent(),
            Value<String?> destinationHolderName = const Value.absent(),
            Value<BigInt> amountMinor = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> scheduledFor = const Value.absent(),
            Value<String> destinationLabel = const Value.absent(),
            Value<String> destinationDetail = const Value.absent(),
            Value<BigInt> totalDebitMinor = const Value.absent(),
            Value<BigInt> destinationAmountMinor = const Value.absent(),
            Value<String> destinationCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OutboxTransfersCompanion(
            id: id,
            transferId: transferId,
            idempotencyKey: idempotencyKey,
            status: status,
            attention: attention,
            attempts: attempts,
            serverErrors: serverErrors,
            queuedAt: queuedAt,
            nextAttemptAt: nextAttemptAt,
            reference: reference,
            sourceAccountId: sourceAccountId,
            destinationType: destinationType,
            destinationAccountId: destinationAccountId,
            destinationBeneficiaryId: destinationBeneficiaryId,
            destinationIban: destinationIban,
            destinationHolderName: destinationHolderName,
            amountMinor: amountMinor,
            currency: currency,
            note: note,
            scheduledFor: scheduledFor,
            destinationLabel: destinationLabel,
            destinationDetail: destinationDetail,
            totalDebitMinor: totalDebitMinor,
            destinationAmountMinor: destinationAmountMinor,
            destinationCurrency: destinationCurrency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String transferId,
            required String idempotencyKey,
            required String status,
            Value<String?> attention = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> serverErrors = const Value.absent(),
            required DateTime queuedAt,
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            required String sourceAccountId,
            required String destinationType,
            Value<String?> destinationAccountId = const Value.absent(),
            Value<String?> destinationBeneficiaryId = const Value.absent(),
            Value<String?> destinationIban = const Value.absent(),
            Value<String?> destinationHolderName = const Value.absent(),
            required BigInt amountMinor,
            required String currency,
            Value<String?> note = const Value.absent(),
            Value<DateTime?> scheduledFor = const Value.absent(),
            required String destinationLabel,
            required String destinationDetail,
            required BigInt totalDebitMinor,
            required BigInt destinationAmountMinor,
            required String destinationCurrency,
            Value<int> rowid = const Value.absent(),
          }) =>
              OutboxTransfersCompanion.insert(
            id: id,
            transferId: transferId,
            idempotencyKey: idempotencyKey,
            status: status,
            attention: attention,
            attempts: attempts,
            serverErrors: serverErrors,
            queuedAt: queuedAt,
            nextAttemptAt: nextAttemptAt,
            reference: reference,
            sourceAccountId: sourceAccountId,
            destinationType: destinationType,
            destinationAccountId: destinationAccountId,
            destinationBeneficiaryId: destinationBeneficiaryId,
            destinationIban: destinationIban,
            destinationHolderName: destinationHolderName,
            amountMinor: amountMinor,
            currency: currency,
            note: note,
            scheduledFor: scheduledFor,
            destinationLabel: destinationLabel,
            destinationDetail: destinationDetail,
            totalDebitMinor: totalDebitMinor,
            destinationAmountMinor: destinationAmountMinor,
            destinationCurrency: destinationCurrency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OutboxTransfersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OutboxTransfersTable,
    OutboxTransfer,
    $$OutboxTransfersTableFilterComposer,
    $$OutboxTransfersTableOrderingComposer,
    $$OutboxTransfersTableAnnotationComposer,
    $$OutboxTransfersTableCreateCompanionBuilder,
    $$OutboxTransfersTableUpdateCompanionBuilder,
    (
      OutboxTransfer,
      BaseReferences<_$AppDatabase, $OutboxTransfersTable, OutboxTransfer>
    ),
    OutboxTransfer,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedAccountsTableTableManager get cachedAccounts =>
      $$CachedAccountsTableTableManager(_db, _db.cachedAccounts);
  $$CachedBalancePointsTableTableManager get cachedBalancePoints =>
      $$CachedBalancePointsTableTableManager(_db, _db.cachedBalancePoints);
  $$OutboxTransfersTableTableManager get outboxTransfers =>
      $$OutboxTransfersTableTableManager(_db, _db.outboxTransfers);
}
