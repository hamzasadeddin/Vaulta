// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountsResponseDto {
  List<AccountDto> get accounts;

  /// Create a copy of AccountsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountsResponseDtoCopyWith<AccountsResponseDto> get copyWith =>
      _$AccountsResponseDtoCopyWithImpl<AccountsResponseDto>(
          this as AccountsResponseDto, _$identity);

  /// Serializes this AccountsResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountsResponseDto &&
            const DeepCollectionEquality().equals(other.accounts, accounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(accounts));

  @override
  String toString() {
    return 'AccountsResponseDto(accounts: $accounts)';
  }
}

/// @nodoc
abstract mixin class $AccountsResponseDtoCopyWith<$Res> {
  factory $AccountsResponseDtoCopyWith(
          AccountsResponseDto value, $Res Function(AccountsResponseDto) _then) =
      _$AccountsResponseDtoCopyWithImpl;
  @useResult
  $Res call({List<AccountDto> accounts});
}

/// @nodoc
class _$AccountsResponseDtoCopyWithImpl<$Res>
    implements $AccountsResponseDtoCopyWith<$Res> {
  _$AccountsResponseDtoCopyWithImpl(this._self, this._then);

  final AccountsResponseDto _self;
  final $Res Function(AccountsResponseDto) _then;

  /// Create a copy of AccountsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accounts = null,
  }) {
    return _then(_self.copyWith(
      accounts: null == accounts
          ? _self.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AccountDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountsResponseDto].
extension AccountsResponseDtoPatterns on AccountsResponseDto {
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
    TResult Function(_AccountsResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountsResponseDto() when $default != null:
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
    TResult Function(_AccountsResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountsResponseDto():
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
    TResult? Function(_AccountsResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountsResponseDto() when $default != null:
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
    TResult Function(List<AccountDto> accounts)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountsResponseDto() when $default != null:
        return $default(_that.accounts);
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
    TResult Function(List<AccountDto> accounts) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountsResponseDto():
        return $default(_that.accounts);
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
    TResult? Function(List<AccountDto> accounts)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountsResponseDto() when $default != null:
        return $default(_that.accounts);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountsResponseDto extends AccountsResponseDto {
  const _AccountsResponseDto(
      {final List<AccountDto> accounts = const <AccountDto>[]})
      : _accounts = accounts,
        super._();
  factory _AccountsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AccountsResponseDtoFromJson(json);

  final List<AccountDto> _accounts;
  @override
  @JsonKey()
  List<AccountDto> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  /// Create a copy of AccountsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountsResponseDtoCopyWith<_AccountsResponseDto> get copyWith =>
      __$AccountsResponseDtoCopyWithImpl<_AccountsResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountsResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountsResponseDto &&
            const DeepCollectionEquality().equals(other._accounts, _accounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_accounts));

  @override
  String toString() {
    return 'AccountsResponseDto(accounts: $accounts)';
  }
}

/// @nodoc
abstract mixin class _$AccountsResponseDtoCopyWith<$Res>
    implements $AccountsResponseDtoCopyWith<$Res> {
  factory _$AccountsResponseDtoCopyWith(_AccountsResponseDto value,
          $Res Function(_AccountsResponseDto) _then) =
      __$AccountsResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<AccountDto> accounts});
}

/// @nodoc
class __$AccountsResponseDtoCopyWithImpl<$Res>
    implements _$AccountsResponseDtoCopyWith<$Res> {
  __$AccountsResponseDtoCopyWithImpl(this._self, this._then);

  final _AccountsResponseDto _self;
  final $Res Function(_AccountsResponseDto) _then;

  /// Create a copy of AccountsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accounts = null,
  }) {
    return _then(_AccountsResponseDto(
      accounts: null == accounts
          ? _self._accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AccountDto>,
    ));
  }
}

/// @nodoc
mixin _$AccountDto {
  String get id;
  String get name;
  String get type;
  String get iban;
  String get currency;
  int get balanceMinor;
  String get openedAt;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountDtoCopyWith<AccountDto> get copyWith =>
      _$AccountDtoCopyWithImpl<AccountDto>(this as AccountDto, _$identity);

  /// Serializes this AccountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.iban, iban) || other.iban == iban) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, type, iban, currency, balanceMinor, openedAt);

  @override
  String toString() {
    return 'AccountDto(id: $id, name: $name, type: $type, iban: $iban, currency: $currency, balanceMinor: $balanceMinor, openedAt: $openedAt)';
  }
}

/// @nodoc
abstract mixin class $AccountDtoCopyWith<$Res> {
  factory $AccountDtoCopyWith(
          AccountDto value, $Res Function(AccountDto) _then) =
      _$AccountDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String iban,
      String currency,
      int balanceMinor,
      String openedAt});
}

/// @nodoc
class _$AccountDtoCopyWithImpl<$Res> implements $AccountDtoCopyWith<$Res> {
  _$AccountDtoCopyWithImpl(this._self, this._then);

  final AccountDto _self;
  final $Res Function(AccountDto) _then;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? iban = null,
    Object? currency = null,
    Object? balanceMinor = null,
    Object? openedAt = null,
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
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      iban: null == iban
          ? _self.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      openedAt: null == openedAt
          ? _self.openedAt
          : openedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountDto].
extension AccountDtoPatterns on AccountDto {
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
    TResult Function(_AccountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
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
    TResult Function(_AccountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto():
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
    TResult? Function(_AccountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
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
    TResult Function(String id, String name, String type, String iban,
            String currency, int balanceMinor, String openedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
        return $default(_that.id, _that.name, _that.type, _that.iban,
            _that.currency, _that.balanceMinor, _that.openedAt);
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
    TResult Function(String id, String name, String type, String iban,
            String currency, int balanceMinor, String openedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto():
        return $default(_that.id, _that.name, _that.type, _that.iban,
            _that.currency, _that.balanceMinor, _that.openedAt);
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
    TResult? Function(String id, String name, String type, String iban,
            String currency, int balanceMinor, String openedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
        return $default(_that.id, _that.name, _that.type, _that.iban,
            _that.currency, _that.balanceMinor, _that.openedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountDto extends AccountDto {
  const _AccountDto(
      {required this.id,
      required this.name,
      required this.type,
      required this.iban,
      required this.currency,
      required this.balanceMinor,
      required this.openedAt})
      : super._();
  factory _AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String iban;
  @override
  final String currency;
  @override
  final int balanceMinor;
  @override
  final String openedAt;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountDtoCopyWith<_AccountDto> get copyWith =>
      __$AccountDtoCopyWithImpl<_AccountDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.iban, iban) || other.iban == iban) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, type, iban, currency, balanceMinor, openedAt);

  @override
  String toString() {
    return 'AccountDto(id: $id, name: $name, type: $type, iban: $iban, currency: $currency, balanceMinor: $balanceMinor, openedAt: $openedAt)';
  }
}

/// @nodoc
abstract mixin class _$AccountDtoCopyWith<$Res>
    implements $AccountDtoCopyWith<$Res> {
  factory _$AccountDtoCopyWith(
          _AccountDto value, $Res Function(_AccountDto) _then) =
      __$AccountDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String iban,
      String currency,
      int balanceMinor,
      String openedAt});
}

/// @nodoc
class __$AccountDtoCopyWithImpl<$Res> implements _$AccountDtoCopyWith<$Res> {
  __$AccountDtoCopyWithImpl(this._self, this._then);

  final _AccountDto _self;
  final $Res Function(_AccountDto) _then;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? iban = null,
    Object? currency = null,
    Object? balanceMinor = null,
    Object? openedAt = null,
  }) {
    return _then(_AccountDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      iban: null == iban
          ? _self.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      openedAt: null == openedAt
          ? _self.openedAt
          : openedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AccountHistoryDto {
  String get accountId;
  String get currency;
  List<HistoryPointDto> get points;

  /// Create a copy of AccountHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountHistoryDtoCopyWith<AccountHistoryDto> get copyWith =>
      _$AccountHistoryDtoCopyWithImpl<AccountHistoryDto>(
          this as AccountHistoryDto, _$identity);

  /// Serializes this AccountHistoryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountHistoryDto &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other.points, points));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, currency,
      const DeepCollectionEquality().hash(points));

  @override
  String toString() {
    return 'AccountHistoryDto(accountId: $accountId, currency: $currency, points: $points)';
  }
}

/// @nodoc
abstract mixin class $AccountHistoryDtoCopyWith<$Res> {
  factory $AccountHistoryDtoCopyWith(
          AccountHistoryDto value, $Res Function(AccountHistoryDto) _then) =
      _$AccountHistoryDtoCopyWithImpl;
  @useResult
  $Res call({String accountId, String currency, List<HistoryPointDto> points});
}

/// @nodoc
class _$AccountHistoryDtoCopyWithImpl<$Res>
    implements $AccountHistoryDtoCopyWith<$Res> {
  _$AccountHistoryDtoCopyWithImpl(this._self, this._then);

  final AccountHistoryDto _self;
  final $Res Function(AccountHistoryDto) _then;

  /// Create a copy of AccountHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? currency = null,
    Object? points = null,
  }) {
    return _then(_self.copyWith(
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<HistoryPointDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountHistoryDto].
extension AccountHistoryDtoPatterns on AccountHistoryDto {
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
    TResult Function(_AccountHistoryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountHistoryDto() when $default != null:
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
    TResult Function(_AccountHistoryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountHistoryDto():
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
    TResult? Function(_AccountHistoryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountHistoryDto() when $default != null:
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
    TResult Function(
            String accountId, String currency, List<HistoryPointDto> points)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountHistoryDto() when $default != null:
        return $default(_that.accountId, _that.currency, _that.points);
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
    TResult Function(
            String accountId, String currency, List<HistoryPointDto> points)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountHistoryDto():
        return $default(_that.accountId, _that.currency, _that.points);
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
            String accountId, String currency, List<HistoryPointDto> points)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountHistoryDto() when $default != null:
        return $default(_that.accountId, _that.currency, _that.points);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountHistoryDto extends AccountHistoryDto {
  const _AccountHistoryDto(
      {required this.accountId,
      required this.currency,
      final List<HistoryPointDto> points = const <HistoryPointDto>[]})
      : _points = points,
        super._();
  factory _AccountHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryDtoFromJson(json);

  @override
  final String accountId;
  @override
  final String currency;
  final List<HistoryPointDto> _points;
  @override
  @JsonKey()
  List<HistoryPointDto> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  /// Create a copy of AccountHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountHistoryDtoCopyWith<_AccountHistoryDto> get copyWith =>
      __$AccountHistoryDtoCopyWithImpl<_AccountHistoryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountHistoryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountHistoryDto &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, currency,
      const DeepCollectionEquality().hash(_points));

  @override
  String toString() {
    return 'AccountHistoryDto(accountId: $accountId, currency: $currency, points: $points)';
  }
}

/// @nodoc
abstract mixin class _$AccountHistoryDtoCopyWith<$Res>
    implements $AccountHistoryDtoCopyWith<$Res> {
  factory _$AccountHistoryDtoCopyWith(
          _AccountHistoryDto value, $Res Function(_AccountHistoryDto) _then) =
      __$AccountHistoryDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String accountId, String currency, List<HistoryPointDto> points});
}

/// @nodoc
class __$AccountHistoryDtoCopyWithImpl<$Res>
    implements _$AccountHistoryDtoCopyWith<$Res> {
  __$AccountHistoryDtoCopyWithImpl(this._self, this._then);

  final _AccountHistoryDto _self;
  final $Res Function(_AccountHistoryDto) _then;

  /// Create a copy of AccountHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountId = null,
    Object? currency = null,
    Object? points = null,
  }) {
    return _then(_AccountHistoryDto(
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<HistoryPointDto>,
    ));
  }
}

/// @nodoc
mixin _$HistoryPointDto {
  String get date;
  int get balanceMinor;

  /// Create a copy of HistoryPointDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HistoryPointDtoCopyWith<HistoryPointDto> get copyWith =>
      _$HistoryPointDtoCopyWithImpl<HistoryPointDto>(
          this as HistoryPointDto, _$identity);

  /// Serializes this HistoryPointDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HistoryPointDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, balanceMinor);

  @override
  String toString() {
    return 'HistoryPointDto(date: $date, balanceMinor: $balanceMinor)';
  }
}

/// @nodoc
abstract mixin class $HistoryPointDtoCopyWith<$Res> {
  factory $HistoryPointDtoCopyWith(
          HistoryPointDto value, $Res Function(HistoryPointDto) _then) =
      _$HistoryPointDtoCopyWithImpl;
  @useResult
  $Res call({String date, int balanceMinor});
}

/// @nodoc
class _$HistoryPointDtoCopyWithImpl<$Res>
    implements $HistoryPointDtoCopyWith<$Res> {
  _$HistoryPointDtoCopyWithImpl(this._self, this._then);

  final HistoryPointDto _self;
  final $Res Function(HistoryPointDto) _then;

  /// Create a copy of HistoryPointDto
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

/// Adds pattern-matching-related methods to [HistoryPointDto].
extension HistoryPointDtoPatterns on HistoryPointDto {
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
    TResult Function(_HistoryPointDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryPointDto() when $default != null:
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
    TResult Function(_HistoryPointDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryPointDto():
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
    TResult? Function(_HistoryPointDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryPointDto() when $default != null:
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
      case _HistoryPointDto() when $default != null:
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
      case _HistoryPointDto():
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
      case _HistoryPointDto() when $default != null:
        return $default(_that.date, _that.balanceMinor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HistoryPointDto extends HistoryPointDto {
  const _HistoryPointDto({required this.date, required this.balanceMinor})
      : super._();
  factory _HistoryPointDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryPointDtoFromJson(json);

  @override
  final String date;
  @override
  final int balanceMinor;

  /// Create a copy of HistoryPointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HistoryPointDtoCopyWith<_HistoryPointDto> get copyWith =>
      __$HistoryPointDtoCopyWithImpl<_HistoryPointDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HistoryPointDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HistoryPointDto &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, balanceMinor);

  @override
  String toString() {
    return 'HistoryPointDto(date: $date, balanceMinor: $balanceMinor)';
  }
}

/// @nodoc
abstract mixin class _$HistoryPointDtoCopyWith<$Res>
    implements $HistoryPointDtoCopyWith<$Res> {
  factory _$HistoryPointDtoCopyWith(
          _HistoryPointDto value, $Res Function(_HistoryPointDto) _then) =
      __$HistoryPointDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String date, int balanceMinor});
}

/// @nodoc
class __$HistoryPointDtoCopyWithImpl<$Res>
    implements _$HistoryPointDtoCopyWith<$Res> {
  __$HistoryPointDtoCopyWithImpl(this._self, this._then);

  final _HistoryPointDto _self;
  final $Res Function(_HistoryPointDto) _then;

  /// Create a copy of HistoryPointDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = null,
    Object? balanceMinor = null,
  }) {
    return _then(_HistoryPointDto(
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
mixin _$StatementsResponseDto {
  List<StatementDto> get statements;

  /// Create a copy of StatementsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatementsResponseDtoCopyWith<StatementsResponseDto> get copyWith =>
      _$StatementsResponseDtoCopyWithImpl<StatementsResponseDto>(
          this as StatementsResponseDto, _$identity);

  /// Serializes this StatementsResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatementsResponseDto &&
            const DeepCollectionEquality()
                .equals(other.statements, statements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(statements));

  @override
  String toString() {
    return 'StatementsResponseDto(statements: $statements)';
  }
}

/// @nodoc
abstract mixin class $StatementsResponseDtoCopyWith<$Res> {
  factory $StatementsResponseDtoCopyWith(StatementsResponseDto value,
          $Res Function(StatementsResponseDto) _then) =
      _$StatementsResponseDtoCopyWithImpl;
  @useResult
  $Res call({List<StatementDto> statements});
}

/// @nodoc
class _$StatementsResponseDtoCopyWithImpl<$Res>
    implements $StatementsResponseDtoCopyWith<$Res> {
  _$StatementsResponseDtoCopyWithImpl(this._self, this._then);

  final StatementsResponseDto _self;
  final $Res Function(StatementsResponseDto) _then;

  /// Create a copy of StatementsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statements = null,
  }) {
    return _then(_self.copyWith(
      statements: null == statements
          ? _self.statements
          : statements // ignore: cast_nullable_to_non_nullable
              as List<StatementDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [StatementsResponseDto].
extension StatementsResponseDtoPatterns on StatementsResponseDto {
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
    TResult Function(_StatementsResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementsResponseDto() when $default != null:
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
    TResult Function(_StatementsResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementsResponseDto():
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
    TResult? Function(_StatementsResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementsResponseDto() when $default != null:
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
    TResult Function(List<StatementDto> statements)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementsResponseDto() when $default != null:
        return $default(_that.statements);
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
    TResult Function(List<StatementDto> statements) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementsResponseDto():
        return $default(_that.statements);
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
    TResult? Function(List<StatementDto> statements)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementsResponseDto() when $default != null:
        return $default(_that.statements);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StatementsResponseDto extends StatementsResponseDto {
  const _StatementsResponseDto(
      {final List<StatementDto> statements = const <StatementDto>[]})
      : _statements = statements,
        super._();
  factory _StatementsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StatementsResponseDtoFromJson(json);

  final List<StatementDto> _statements;
  @override
  @JsonKey()
  List<StatementDto> get statements {
    if (_statements is EqualUnmodifiableListView) return _statements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statements);
  }

  /// Create a copy of StatementsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatementsResponseDtoCopyWith<_StatementsResponseDto> get copyWith =>
      __$StatementsResponseDtoCopyWithImpl<_StatementsResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StatementsResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatementsResponseDto &&
            const DeepCollectionEquality()
                .equals(other._statements, _statements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_statements));

  @override
  String toString() {
    return 'StatementsResponseDto(statements: $statements)';
  }
}

/// @nodoc
abstract mixin class _$StatementsResponseDtoCopyWith<$Res>
    implements $StatementsResponseDtoCopyWith<$Res> {
  factory _$StatementsResponseDtoCopyWith(_StatementsResponseDto value,
          $Res Function(_StatementsResponseDto) _then) =
      __$StatementsResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<StatementDto> statements});
}

/// @nodoc
class __$StatementsResponseDtoCopyWithImpl<$Res>
    implements _$StatementsResponseDtoCopyWith<$Res> {
  __$StatementsResponseDtoCopyWithImpl(this._self, this._then);

  final _StatementsResponseDto _self;
  final $Res Function(_StatementsResponseDto) _then;

  /// Create a copy of StatementsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? statements = null,
  }) {
    return _then(_StatementsResponseDto(
      statements: null == statements
          ? _self._statements
          : statements // ignore: cast_nullable_to_non_nullable
              as List<StatementDto>,
    ));
  }
}

/// @nodoc
mixin _$StatementDto {
  String get id;
  String get accountId;
  String get periodStart;
  String get periodEnd;
  String get currency;
  int get openingBalanceMinor;
  int get closingBalanceMinor;
  int get transactionCount;

  /// Create a copy of StatementDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatementDtoCopyWith<StatementDto> get copyWith =>
      _$StatementDtoCopyWithImpl<StatementDto>(
          this as StatementDto, _$identity);

  /// Serializes this StatementDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatementDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.openingBalanceMinor, openingBalanceMinor) ||
                other.openingBalanceMinor == openingBalanceMinor) &&
            (identical(other.closingBalanceMinor, closingBalanceMinor) ||
                other.closingBalanceMinor == closingBalanceMinor) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      periodStart,
      periodEnd,
      currency,
      openingBalanceMinor,
      closingBalanceMinor,
      transactionCount);

  @override
  String toString() {
    return 'StatementDto(id: $id, accountId: $accountId, periodStart: $periodStart, periodEnd: $periodEnd, currency: $currency, openingBalanceMinor: $openingBalanceMinor, closingBalanceMinor: $closingBalanceMinor, transactionCount: $transactionCount)';
  }
}

/// @nodoc
abstract mixin class $StatementDtoCopyWith<$Res> {
  factory $StatementDtoCopyWith(
          StatementDto value, $Res Function(StatementDto) _then) =
      _$StatementDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String accountId,
      String periodStart,
      String periodEnd,
      String currency,
      int openingBalanceMinor,
      int closingBalanceMinor,
      int transactionCount});
}

/// @nodoc
class _$StatementDtoCopyWithImpl<$Res> implements $StatementDtoCopyWith<$Res> {
  _$StatementDtoCopyWithImpl(this._self, this._then);

  final StatementDto _self;
  final $Res Function(StatementDto) _then;

  /// Create a copy of StatementDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? currency = null,
    Object? openingBalanceMinor = null,
    Object? closingBalanceMinor = null,
    Object? transactionCount = null,
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
      periodStart: null == periodStart
          ? _self.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as String,
      periodEnd: null == periodEnd
          ? _self.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      openingBalanceMinor: null == openingBalanceMinor
          ? _self.openingBalanceMinor
          : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      closingBalanceMinor: null == closingBalanceMinor
          ? _self.closingBalanceMinor
          : closingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _self.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [StatementDto].
extension StatementDtoPatterns on StatementDto {
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
    TResult Function(_StatementDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementDto() when $default != null:
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
    TResult Function(_StatementDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDto():
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
    TResult? Function(_StatementDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDto() when $default != null:
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
    TResult Function(
            String id,
            String accountId,
            String periodStart,
            String periodEnd,
            String currency,
            int openingBalanceMinor,
            int closingBalanceMinor,
            int transactionCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.periodStart,
            _that.periodEnd,
            _that.currency,
            _that.openingBalanceMinor,
            _that.closingBalanceMinor,
            _that.transactionCount);
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
    TResult Function(
            String id,
            String accountId,
            String periodStart,
            String periodEnd,
            String currency,
            int openingBalanceMinor,
            int closingBalanceMinor,
            int transactionCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDto():
        return $default(
            _that.id,
            _that.accountId,
            _that.periodStart,
            _that.periodEnd,
            _that.currency,
            _that.openingBalanceMinor,
            _that.closingBalanceMinor,
            _that.transactionCount);
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
            String periodStart,
            String periodEnd,
            String currency,
            int openingBalanceMinor,
            int closingBalanceMinor,
            int transactionCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.periodStart,
            _that.periodEnd,
            _that.currency,
            _that.openingBalanceMinor,
            _that.closingBalanceMinor,
            _that.transactionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StatementDto extends StatementDto {
  const _StatementDto(
      {required this.id,
      required this.accountId,
      required this.periodStart,
      required this.periodEnd,
      required this.currency,
      required this.openingBalanceMinor,
      required this.closingBalanceMinor,
      required this.transactionCount})
      : super._();
  factory _StatementDto.fromJson(Map<String, dynamic> json) =>
      _$StatementDtoFromJson(json);

  @override
  final String id;
  @override
  final String accountId;
  @override
  final String periodStart;
  @override
  final String periodEnd;
  @override
  final String currency;
  @override
  final int openingBalanceMinor;
  @override
  final int closingBalanceMinor;
  @override
  final int transactionCount;

  /// Create a copy of StatementDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatementDtoCopyWith<_StatementDto> get copyWith =>
      __$StatementDtoCopyWithImpl<_StatementDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StatementDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatementDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.openingBalanceMinor, openingBalanceMinor) ||
                other.openingBalanceMinor == openingBalanceMinor) &&
            (identical(other.closingBalanceMinor, closingBalanceMinor) ||
                other.closingBalanceMinor == closingBalanceMinor) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      periodStart,
      periodEnd,
      currency,
      openingBalanceMinor,
      closingBalanceMinor,
      transactionCount);

  @override
  String toString() {
    return 'StatementDto(id: $id, accountId: $accountId, periodStart: $periodStart, periodEnd: $periodEnd, currency: $currency, openingBalanceMinor: $openingBalanceMinor, closingBalanceMinor: $closingBalanceMinor, transactionCount: $transactionCount)';
  }
}

/// @nodoc
abstract mixin class _$StatementDtoCopyWith<$Res>
    implements $StatementDtoCopyWith<$Res> {
  factory _$StatementDtoCopyWith(
          _StatementDto value, $Res Function(_StatementDto) _then) =
      __$StatementDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String accountId,
      String periodStart,
      String periodEnd,
      String currency,
      int openingBalanceMinor,
      int closingBalanceMinor,
      int transactionCount});
}

/// @nodoc
class __$StatementDtoCopyWithImpl<$Res>
    implements _$StatementDtoCopyWith<$Res> {
  __$StatementDtoCopyWithImpl(this._self, this._then);

  final _StatementDto _self;
  final $Res Function(_StatementDto) _then;

  /// Create a copy of StatementDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? currency = null,
    Object? openingBalanceMinor = null,
    Object? closingBalanceMinor = null,
    Object? transactionCount = null,
  }) {
    return _then(_StatementDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      periodStart: null == periodStart
          ? _self.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as String,
      periodEnd: null == periodEnd
          ? _self.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      openingBalanceMinor: null == openingBalanceMinor
          ? _self.openingBalanceMinor
          : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      closingBalanceMinor: null == closingBalanceMinor
          ? _self.closingBalanceMinor
          : closingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _self.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$StatementDetailDto {
  String get id;
  String get accountId;
  String get periodStart;
  String get periodEnd;
  String get currency;
  int get openingBalanceMinor;
  int get closingBalanceMinor;
  int get transactionCount;
  List<StatementLineDto> get lines;

  /// Create a copy of StatementDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatementDetailDtoCopyWith<StatementDetailDto> get copyWith =>
      _$StatementDetailDtoCopyWithImpl<StatementDetailDto>(
          this as StatementDetailDto, _$identity);

  /// Serializes this StatementDetailDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatementDetailDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.openingBalanceMinor, openingBalanceMinor) ||
                other.openingBalanceMinor == openingBalanceMinor) &&
            (identical(other.closingBalanceMinor, closingBalanceMinor) ||
                other.closingBalanceMinor == closingBalanceMinor) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality().equals(other.lines, lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      periodStart,
      periodEnd,
      currency,
      openingBalanceMinor,
      closingBalanceMinor,
      transactionCount,
      const DeepCollectionEquality().hash(lines));

  @override
  String toString() {
    return 'StatementDetailDto(id: $id, accountId: $accountId, periodStart: $periodStart, periodEnd: $periodEnd, currency: $currency, openingBalanceMinor: $openingBalanceMinor, closingBalanceMinor: $closingBalanceMinor, transactionCount: $transactionCount, lines: $lines)';
  }
}

/// @nodoc
abstract mixin class $StatementDetailDtoCopyWith<$Res> {
  factory $StatementDetailDtoCopyWith(
          StatementDetailDto value, $Res Function(StatementDetailDto) _then) =
      _$StatementDetailDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String accountId,
      String periodStart,
      String periodEnd,
      String currency,
      int openingBalanceMinor,
      int closingBalanceMinor,
      int transactionCount,
      List<StatementLineDto> lines});
}

/// @nodoc
class _$StatementDetailDtoCopyWithImpl<$Res>
    implements $StatementDetailDtoCopyWith<$Res> {
  _$StatementDetailDtoCopyWithImpl(this._self, this._then);

  final StatementDetailDto _self;
  final $Res Function(StatementDetailDto) _then;

  /// Create a copy of StatementDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? currency = null,
    Object? openingBalanceMinor = null,
    Object? closingBalanceMinor = null,
    Object? transactionCount = null,
    Object? lines = null,
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
      periodStart: null == periodStart
          ? _self.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as String,
      periodEnd: null == periodEnd
          ? _self.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      openingBalanceMinor: null == openingBalanceMinor
          ? _self.openingBalanceMinor
          : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      closingBalanceMinor: null == closingBalanceMinor
          ? _self.closingBalanceMinor
          : closingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _self.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lines: null == lines
          ? _self.lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<StatementLineDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [StatementDetailDto].
extension StatementDetailDtoPatterns on StatementDetailDto {
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
    TResult Function(_StatementDetailDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementDetailDto() when $default != null:
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
    TResult Function(_StatementDetailDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDetailDto():
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
    TResult? Function(_StatementDetailDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDetailDto() when $default != null:
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
    TResult Function(
            String id,
            String accountId,
            String periodStart,
            String periodEnd,
            String currency,
            int openingBalanceMinor,
            int closingBalanceMinor,
            int transactionCount,
            List<StatementLineDto> lines)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementDetailDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.periodStart,
            _that.periodEnd,
            _that.currency,
            _that.openingBalanceMinor,
            _that.closingBalanceMinor,
            _that.transactionCount,
            _that.lines);
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
    TResult Function(
            String id,
            String accountId,
            String periodStart,
            String periodEnd,
            String currency,
            int openingBalanceMinor,
            int closingBalanceMinor,
            int transactionCount,
            List<StatementLineDto> lines)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDetailDto():
        return $default(
            _that.id,
            _that.accountId,
            _that.periodStart,
            _that.periodEnd,
            _that.currency,
            _that.openingBalanceMinor,
            _that.closingBalanceMinor,
            _that.transactionCount,
            _that.lines);
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
            String periodStart,
            String periodEnd,
            String currency,
            int openingBalanceMinor,
            int closingBalanceMinor,
            int transactionCount,
            List<StatementLineDto> lines)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementDetailDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.periodStart,
            _that.periodEnd,
            _that.currency,
            _that.openingBalanceMinor,
            _that.closingBalanceMinor,
            _that.transactionCount,
            _that.lines);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StatementDetailDto extends StatementDetailDto {
  const _StatementDetailDto(
      {required this.id,
      required this.accountId,
      required this.periodStart,
      required this.periodEnd,
      required this.currency,
      required this.openingBalanceMinor,
      required this.closingBalanceMinor,
      required this.transactionCount,
      final List<StatementLineDto> lines = const <StatementLineDto>[]})
      : _lines = lines,
        super._();
  factory _StatementDetailDto.fromJson(Map<String, dynamic> json) =>
      _$StatementDetailDtoFromJson(json);

  @override
  final String id;
  @override
  final String accountId;
  @override
  final String periodStart;
  @override
  final String periodEnd;
  @override
  final String currency;
  @override
  final int openingBalanceMinor;
  @override
  final int closingBalanceMinor;
  @override
  final int transactionCount;
  final List<StatementLineDto> _lines;
  @override
  @JsonKey()
  List<StatementLineDto> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// Create a copy of StatementDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatementDetailDtoCopyWith<_StatementDetailDto> get copyWith =>
      __$StatementDetailDtoCopyWithImpl<_StatementDetailDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StatementDetailDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatementDetailDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.openingBalanceMinor, openingBalanceMinor) ||
                other.openingBalanceMinor == openingBalanceMinor) &&
            (identical(other.closingBalanceMinor, closingBalanceMinor) ||
                other.closingBalanceMinor == closingBalanceMinor) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      periodStart,
      periodEnd,
      currency,
      openingBalanceMinor,
      closingBalanceMinor,
      transactionCount,
      const DeepCollectionEquality().hash(_lines));

  @override
  String toString() {
    return 'StatementDetailDto(id: $id, accountId: $accountId, periodStart: $periodStart, periodEnd: $periodEnd, currency: $currency, openingBalanceMinor: $openingBalanceMinor, closingBalanceMinor: $closingBalanceMinor, transactionCount: $transactionCount, lines: $lines)';
  }
}

/// @nodoc
abstract mixin class _$StatementDetailDtoCopyWith<$Res>
    implements $StatementDetailDtoCopyWith<$Res> {
  factory _$StatementDetailDtoCopyWith(
          _StatementDetailDto value, $Res Function(_StatementDetailDto) _then) =
      __$StatementDetailDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String accountId,
      String periodStart,
      String periodEnd,
      String currency,
      int openingBalanceMinor,
      int closingBalanceMinor,
      int transactionCount,
      List<StatementLineDto> lines});
}

/// @nodoc
class __$StatementDetailDtoCopyWithImpl<$Res>
    implements _$StatementDetailDtoCopyWith<$Res> {
  __$StatementDetailDtoCopyWithImpl(this._self, this._then);

  final _StatementDetailDto _self;
  final $Res Function(_StatementDetailDto) _then;

  /// Create a copy of StatementDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? currency = null,
    Object? openingBalanceMinor = null,
    Object? closingBalanceMinor = null,
    Object? transactionCount = null,
    Object? lines = null,
  }) {
    return _then(_StatementDetailDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      periodStart: null == periodStart
          ? _self.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as String,
      periodEnd: null == periodEnd
          ? _self.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      openingBalanceMinor: null == openingBalanceMinor
          ? _self.openingBalanceMinor
          : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      closingBalanceMinor: null == closingBalanceMinor
          ? _self.closingBalanceMinor
          : closingBalanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _self.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      lines: null == lines
          ? _self._lines
          : lines // ignore: cast_nullable_to_non_nullable
              as List<StatementLineDto>,
    ));
  }
}

/// @nodoc
mixin _$StatementLineDto {
  String get id;
  String get title;
  int get amountMinor;
  String get occurredAt;

  /// Create a copy of StatementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StatementLineDtoCopyWith<StatementLineDto> get copyWith =>
      _$StatementLineDtoCopyWithImpl<StatementLineDto>(
          this as StatementLineDto, _$identity);

  /// Serializes this StatementLineDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StatementLineDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, amountMinor, occurredAt);

  @override
  String toString() {
    return 'StatementLineDto(id: $id, title: $title, amountMinor: $amountMinor, occurredAt: $occurredAt)';
  }
}

/// @nodoc
abstract mixin class $StatementLineDtoCopyWith<$Res> {
  factory $StatementLineDtoCopyWith(
          StatementLineDto value, $Res Function(StatementLineDto) _then) =
      _$StatementLineDtoCopyWithImpl;
  @useResult
  $Res call({String id, String title, int amountMinor, String occurredAt});
}

/// @nodoc
class _$StatementLineDtoCopyWithImpl<$Res>
    implements $StatementLineDtoCopyWith<$Res> {
  _$StatementLineDtoCopyWithImpl(this._self, this._then);

  final StatementLineDto _self;
  final $Res Function(StatementLineDto) _then;

  /// Create a copy of StatementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amountMinor = null,
    Object? occurredAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [StatementLineDto].
extension StatementLineDtoPatterns on StatementLineDto {
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
    TResult Function(_StatementLineDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementLineDto() when $default != null:
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
    TResult Function(_StatementLineDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementLineDto():
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
    TResult? Function(_StatementLineDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementLineDto() when $default != null:
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
    TResult Function(
            String id, String title, int amountMinor, String occurredAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StatementLineDto() when $default != null:
        return $default(
            _that.id, _that.title, _that.amountMinor, _that.occurredAt);
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
    TResult Function(
            String id, String title, int amountMinor, String occurredAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementLineDto():
        return $default(
            _that.id, _that.title, _that.amountMinor, _that.occurredAt);
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
            String id, String title, int amountMinor, String occurredAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StatementLineDto() when $default != null:
        return $default(
            _that.id, _that.title, _that.amountMinor, _that.occurredAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StatementLineDto extends StatementLineDto {
  const _StatementLineDto(
      {required this.id,
      required this.title,
      required this.amountMinor,
      required this.occurredAt})
      : super._();
  factory _StatementLineDto.fromJson(Map<String, dynamic> json) =>
      _$StatementLineDtoFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int amountMinor;
  @override
  final String occurredAt;

  /// Create a copy of StatementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatementLineDtoCopyWith<_StatementLineDto> get copyWith =>
      __$StatementLineDtoCopyWithImpl<_StatementLineDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StatementLineDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatementLineDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, amountMinor, occurredAt);

  @override
  String toString() {
    return 'StatementLineDto(id: $id, title: $title, amountMinor: $amountMinor, occurredAt: $occurredAt)';
  }
}

/// @nodoc
abstract mixin class _$StatementLineDtoCopyWith<$Res>
    implements $StatementLineDtoCopyWith<$Res> {
  factory _$StatementLineDtoCopyWith(
          _StatementLineDto value, $Res Function(_StatementLineDto) _then) =
      __$StatementLineDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, int amountMinor, String occurredAt});
}

/// @nodoc
class __$StatementLineDtoCopyWithImpl<$Res>
    implements _$StatementLineDtoCopyWith<$Res> {
  __$StatementLineDtoCopyWithImpl(this._self, this._then);

  final _StatementLineDto _self;
  final $Res Function(_StatementLineDto) _then;

  /// Create a copy of StatementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amountMinor = null,
    Object? occurredAt = null,
  }) {
    return _then(_StatementLineDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
