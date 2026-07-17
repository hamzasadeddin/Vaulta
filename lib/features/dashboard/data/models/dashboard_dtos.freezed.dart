// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardSummaryDto {
  List<AccountSummaryDto> get accounts;
  List<TransactionDto> get recentTransactions;

  /// Create a copy of DashboardSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardSummaryDtoCopyWith<DashboardSummaryDto> get copyWith =>
      _$DashboardSummaryDtoCopyWithImpl<DashboardSummaryDto>(
          this as DashboardSummaryDto, _$identity);

  /// Serializes this DashboardSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardSummaryDto &&
            const DeepCollectionEquality().equals(other.accounts, accounts) &&
            const DeepCollectionEquality()
                .equals(other.recentTransactions, recentTransactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(accounts),
      const DeepCollectionEquality().hash(recentTransactions));

  @override
  String toString() {
    return 'DashboardSummaryDto(accounts: $accounts, recentTransactions: $recentTransactions)';
  }
}

/// @nodoc
abstract mixin class $DashboardSummaryDtoCopyWith<$Res> {
  factory $DashboardSummaryDtoCopyWith(
          DashboardSummaryDto value, $Res Function(DashboardSummaryDto) _then) =
      _$DashboardSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {List<AccountSummaryDto> accounts,
      List<TransactionDto> recentTransactions});
}

/// @nodoc
class _$DashboardSummaryDtoCopyWithImpl<$Res>
    implements $DashboardSummaryDtoCopyWith<$Res> {
  _$DashboardSummaryDtoCopyWithImpl(this._self, this._then);

  final DashboardSummaryDto _self;
  final $Res Function(DashboardSummaryDto) _then;

  /// Create a copy of DashboardSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accounts = null,
    Object? recentTransactions = null,
  }) {
    return _then(_self.copyWith(
      accounts: null == accounts
          ? _self.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AccountSummaryDto>,
      recentTransactions: null == recentTransactions
          ? _self.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DashboardSummaryDto].
extension DashboardSummaryDtoPatterns on DashboardSummaryDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DashboardSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardSummaryDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DashboardSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardSummaryDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DashboardSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardSummaryDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<AccountSummaryDto> accounts,
            List<TransactionDto> recentTransactions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardSummaryDto() when $default != null:
        return $default(_that.accounts, _that.recentTransactions);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<AccountSummaryDto> accounts,
            List<TransactionDto> recentTransactions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardSummaryDto():
        return $default(_that.accounts, _that.recentTransactions);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<AccountSummaryDto> accounts,
            List<TransactionDto> recentTransactions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardSummaryDto() when $default != null:
        return $default(_that.accounts, _that.recentTransactions);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DashboardSummaryDto extends DashboardSummaryDto {
  const _DashboardSummaryDto(
      {required final List<AccountSummaryDto> accounts,
      final List<TransactionDto> recentTransactions = const <TransactionDto>[]})
      : _accounts = accounts,
        _recentTransactions = recentTransactions,
        super._();
  factory _DashboardSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryDtoFromJson(json);

  final List<AccountSummaryDto> _accounts;
  @override
  List<AccountSummaryDto> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  final List<TransactionDto> _recentTransactions;
  @override
  @JsonKey()
  List<TransactionDto> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  /// Create a copy of DashboardSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardSummaryDtoCopyWith<_DashboardSummaryDto> get copyWith =>
      __$DashboardSummaryDtoCopyWithImpl<_DashboardSummaryDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DashboardSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardSummaryDto &&
            const DeepCollectionEquality().equals(other._accounts, _accounts) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_accounts),
      const DeepCollectionEquality().hash(_recentTransactions));

  @override
  String toString() {
    return 'DashboardSummaryDto(accounts: $accounts, recentTransactions: $recentTransactions)';
  }
}

/// @nodoc
abstract mixin class _$DashboardSummaryDtoCopyWith<$Res>
    implements $DashboardSummaryDtoCopyWith<$Res> {
  factory _$DashboardSummaryDtoCopyWith(_DashboardSummaryDto value,
          $Res Function(_DashboardSummaryDto) _then) =
      __$DashboardSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<AccountSummaryDto> accounts,
      List<TransactionDto> recentTransactions});
}

/// @nodoc
class __$DashboardSummaryDtoCopyWithImpl<$Res>
    implements _$DashboardSummaryDtoCopyWith<$Res> {
  __$DashboardSummaryDtoCopyWithImpl(this._self, this._then);

  final _DashboardSummaryDto _self;
  final $Res Function(_DashboardSummaryDto) _then;

  /// Create a copy of DashboardSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accounts = null,
    Object? recentTransactions = null,
  }) {
    return _then(_DashboardSummaryDto(
      accounts: null == accounts
          ? _self._accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AccountSummaryDto>,
      recentTransactions: null == recentTransactions
          ? _self._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionDto>,
    ));
  }
}

/// @nodoc
mixin _$AccountSummaryDto {
  String get id;
  String get name;
  String get currency;
  int get balanceMinor;
  List<BalancePointDto> get history;

  /// Create a copy of AccountSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountSummaryDtoCopyWith<AccountSummaryDto> get copyWith =>
      _$AccountSummaryDtoCopyWithImpl<AccountSummaryDto>(
          this as AccountSummaryDto, _$identity);

  /// Serializes this AccountSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountSummaryDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor) &&
            const DeepCollectionEquality().equals(other.history, history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, currency, balanceMinor,
      const DeepCollectionEquality().hash(history));

  @override
  String toString() {
    return 'AccountSummaryDto(id: $id, name: $name, currency: $currency, balanceMinor: $balanceMinor, history: $history)';
  }
}

/// @nodoc
abstract mixin class $AccountSummaryDtoCopyWith<$Res> {
  factory $AccountSummaryDtoCopyWith(
          AccountSummaryDto value, $Res Function(AccountSummaryDto) _then) =
      _$AccountSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String currency,
      int balanceMinor,
      List<BalancePointDto> history});
}

/// @nodoc
class _$AccountSummaryDtoCopyWithImpl<$Res>
    implements $AccountSummaryDtoCopyWith<$Res> {
  _$AccountSummaryDtoCopyWithImpl(this._self, this._then);

  final AccountSummaryDto _self;
  final $Res Function(AccountSummaryDto) _then;

  /// Create a copy of AccountSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? currency = null,
    Object? balanceMinor = null,
    Object? history = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      history: null == history
          ? _self.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<BalancePointDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountSummaryDto].
extension AccountSummaryDtoPatterns on AccountSummaryDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AccountSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountSummaryDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AccountSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountSummaryDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AccountSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountSummaryDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name, String currency, int balanceMinor,
            List<BalancePointDto> history)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountSummaryDto() when $default != null:
        return $default(_that.id, _that.name, _that.currency,
            _that.balanceMinor, _that.history);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name, String currency, int balanceMinor,
            List<BalancePointDto> history)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountSummaryDto():
        return $default(_that.id, _that.name, _that.currency,
            _that.balanceMinor, _that.history);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name, String currency, int balanceMinor,
            List<BalancePointDto> history)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountSummaryDto() when $default != null:
        return $default(_that.id, _that.name, _that.currency,
            _that.balanceMinor, _that.history);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountSummaryDto extends AccountSummaryDto {
  const _AccountSummaryDto(
      {required this.id,
      required this.name,
      required this.currency,
      required this.balanceMinor,
      final List<BalancePointDto> history = const <BalancePointDto>[]})
      : _history = history,
        super._();
  factory _AccountSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$AccountSummaryDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String currency;
  @override
  final int balanceMinor;
  final List<BalancePointDto> _history;
  @override
  @JsonKey()
  List<BalancePointDto> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  /// Create a copy of AccountSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountSummaryDtoCopyWith<_AccountSummaryDto> get copyWith =>
      __$AccountSummaryDtoCopyWithImpl<_AccountSummaryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountSummaryDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, currency, balanceMinor,
      const DeepCollectionEquality().hash(_history));

  @override
  String toString() {
    return 'AccountSummaryDto(id: $id, name: $name, currency: $currency, balanceMinor: $balanceMinor, history: $history)';
  }
}

/// @nodoc
abstract mixin class _$AccountSummaryDtoCopyWith<$Res>
    implements $AccountSummaryDtoCopyWith<$Res> {
  factory _$AccountSummaryDtoCopyWith(
          _AccountSummaryDto value, $Res Function(_AccountSummaryDto) _then) =
      __$AccountSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String currency,
      int balanceMinor,
      List<BalancePointDto> history});
}

/// @nodoc
class __$AccountSummaryDtoCopyWithImpl<$Res>
    implements _$AccountSummaryDtoCopyWith<$Res> {
  __$AccountSummaryDtoCopyWithImpl(this._self, this._then);

  final _AccountSummaryDto _self;
  final $Res Function(_AccountSummaryDto) _then;

  /// Create a copy of AccountSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? currency = null,
    Object? balanceMinor = null,
    Object? history = null,
  }) {
    return _then(_AccountSummaryDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      history: null == history
          ? _self._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<BalancePointDto>,
    ));
  }
}

/// @nodoc
mixin _$BalancePointDto {
  String get date;
  int get balanceMinor;

  /// Create a copy of BalancePointDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BalancePointDtoCopyWith<BalancePointDto> get copyWith =>
      _$BalancePointDtoCopyWithImpl<BalancePointDto>(
          this as BalancePointDto, _$identity);

  /// Serializes this BalancePointDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BalancePointDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, balanceMinor);

  @override
  String toString() {
    return 'BalancePointDto(date: $date, balanceMinor: $balanceMinor)';
  }
}

/// @nodoc
abstract mixin class $BalancePointDtoCopyWith<$Res> {
  factory $BalancePointDtoCopyWith(
          BalancePointDto value, $Res Function(BalancePointDto) _then) =
      _$BalancePointDtoCopyWithImpl;
  @useResult
  $Res call({String date, int balanceMinor});
}

/// @nodoc
class _$BalancePointDtoCopyWithImpl<$Res>
    implements $BalancePointDtoCopyWith<$Res> {
  _$BalancePointDtoCopyWithImpl(this._self, this._then);

  final BalancePointDto _self;
  final $Res Function(BalancePointDto) _then;

  /// Create a copy of BalancePointDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? balanceMinor = null,
  }) {
    return _then(_self.copyWith(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [BalancePointDto].
extension BalancePointDtoPatterns on BalancePointDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BalancePointDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BalancePointDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BalancePointDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BalancePointDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BalancePointDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BalancePointDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String date, int balanceMinor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BalancePointDto() when $default != null:
        return $default(_that.date, _that.balanceMinor);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String date, int balanceMinor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BalancePointDto():
        return $default(_that.date, _that.balanceMinor);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String date, int balanceMinor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BalancePointDto() when $default != null:
        return $default(_that.date, _that.balanceMinor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BalancePointDto extends BalancePointDto {
  const _BalancePointDto({required this.date, required this.balanceMinor})
      : super._();
  factory _BalancePointDto.fromJson(Map<String, dynamic> json) =>
      _$BalancePointDtoFromJson(json);

  @override
  final String date;
  @override
  final int balanceMinor;

  /// Create a copy of BalancePointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BalancePointDtoCopyWith<_BalancePointDto> get copyWith =>
      __$BalancePointDtoCopyWithImpl<_BalancePointDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BalancePointDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BalancePointDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, balanceMinor);

  @override
  String toString() {
    return 'BalancePointDto(date: $date, balanceMinor: $balanceMinor)';
  }
}

/// @nodoc
abstract mixin class _$BalancePointDtoCopyWith<$Res>
    implements $BalancePointDtoCopyWith<$Res> {
  factory _$BalancePointDtoCopyWith(
          _BalancePointDto value, $Res Function(_BalancePointDto) _then) =
      __$BalancePointDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String date, int balanceMinor});
}

/// @nodoc
class __$BalancePointDtoCopyWithImpl<$Res>
    implements _$BalancePointDtoCopyWith<$Res> {
  __$BalancePointDtoCopyWithImpl(this._self, this._then);

  final _BalancePointDto _self;
  final $Res Function(_BalancePointDto) _then;

  /// Create a copy of BalancePointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? balanceMinor = null,
  }) {
    return _then(_BalancePointDto(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$TransactionDto {
  String get id;
  String get accountId;
  String get title;
  int get amountMinor;
  String get currency;
  String get occurredAt;
  String get category;
  String get status;

  /// Create a copy of TransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionDtoCopyWith<TransactionDto> get copyWith =>
      _$TransactionDtoCopyWithImpl<TransactionDto>(
          this as TransactionDto, _$identity);

  /// Serializes this TransactionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, title,
      amountMinor, currency, occurredAt, category, status);

  @override
  String toString() {
    return 'TransactionDto(id: $id, accountId: $accountId, title: $title, amountMinor: $amountMinor, currency: $currency, occurredAt: $occurredAt, category: $category, status: $status)';
  }
}

/// @nodoc
abstract mixin class $TransactionDtoCopyWith<$Res> {
  factory $TransactionDtoCopyWith(
          TransactionDto value, $Res Function(TransactionDto) _then) =
      _$TransactionDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String accountId,
      String title,
      int amountMinor,
      String currency,
      String occurredAt,
      String category,
      String status});
}

/// @nodoc
class _$TransactionDtoCopyWithImpl<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  _$TransactionDtoCopyWithImpl(this._self, this._then);

  final TransactionDto _self;
  final $Res Function(TransactionDto) _then;

  /// Create a copy of TransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? title = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? occurredAt = null,
    Object? category = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TransactionDto].
extension TransactionDtoPatterns on TransactionDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TransactionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TransactionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TransactionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String accountId, String title, int amountMinor,
            String currency, String occurredAt, String category, String status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.title,
            _that.amountMinor,
            _that.currency,
            _that.occurredAt,
            _that.category,
            _that.status);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String accountId, String title, int amountMinor,
            String currency, String occurredAt, String category, String status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto():
        return $default(
            _that.id,
            _that.accountId,
            _that.title,
            _that.amountMinor,
            _that.currency,
            _that.occurredAt,
            _that.category,
            _that.status);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String accountId,
            String title,
            int amountMinor,
            String currency,
            String occurredAt,
            String category,
            String status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.title,
            _that.amountMinor,
            _that.currency,
            _that.occurredAt,
            _that.category,
            _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionDto extends TransactionDto {
  const _TransactionDto(
      {required this.id,
      required this.accountId,
      required this.title,
      required this.amountMinor,
      required this.currency,
      required this.occurredAt,
      this.category = 'other',
      this.status = 'completed'})
      : super._();
  factory _TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  @override
  final String id;
  @override
  final String accountId;
  @override
  final String title;
  @override
  final int amountMinor;
  @override
  final String currency;
  @override
  final String occurredAt;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String status;

  /// Create a copy of TransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionDtoCopyWith<_TransactionDto> get copyWith =>
      __$TransactionDtoCopyWithImpl<_TransactionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, title,
      amountMinor, currency, occurredAt, category, status);

  @override
  String toString() {
    return 'TransactionDto(id: $id, accountId: $accountId, title: $title, amountMinor: $amountMinor, currency: $currency, occurredAt: $occurredAt, category: $category, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$TransactionDtoCopyWith<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  factory _$TransactionDtoCopyWith(
          _TransactionDto value, $Res Function(_TransactionDto) _then) =
      __$TransactionDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String accountId,
      String title,
      int amountMinor,
      String currency,
      String occurredAt,
      String category,
      String status});
}

/// @nodoc
class __$TransactionDtoCopyWithImpl<$Res>
    implements _$TransactionDtoCopyWith<$Res> {
  __$TransactionDtoCopyWithImpl(this._self, this._then);

  final _TransactionDto _self;
  final $Res Function(_TransactionDto) _then;

  /// Create a copy of TransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? title = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? occurredAt = null,
    Object? category = null,
    Object? status = null,
  }) {
    return _then(_TransactionDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
