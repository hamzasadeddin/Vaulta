// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeneficiariesDto {
  List<BeneficiaryDto> get beneficiaries;

  /// Create a copy of BeneficiariesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BeneficiariesDtoCopyWith<BeneficiariesDto> get copyWith =>
      _$BeneficiariesDtoCopyWithImpl<BeneficiariesDto>(
          this as BeneficiariesDto, _$identity);

  /// Serializes this BeneficiariesDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BeneficiariesDto &&
            const DeepCollectionEquality()
                .equals(other.beneficiaries, beneficiaries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(beneficiaries));

  @override
  String toString() {
    return 'BeneficiariesDto(beneficiaries: $beneficiaries)';
  }
}

/// @nodoc
abstract mixin class $BeneficiariesDtoCopyWith<$Res> {
  factory $BeneficiariesDtoCopyWith(
          BeneficiariesDto value, $Res Function(BeneficiariesDto) _then) =
      _$BeneficiariesDtoCopyWithImpl;
  @useResult
  $Res call({List<BeneficiaryDto> beneficiaries});
}

/// @nodoc
class _$BeneficiariesDtoCopyWithImpl<$Res>
    implements $BeneficiariesDtoCopyWith<$Res> {
  _$BeneficiariesDtoCopyWithImpl(this._self, this._then);

  final BeneficiariesDto _self;
  final $Res Function(BeneficiariesDto) _then;

  /// Create a copy of BeneficiariesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beneficiaries = null,
  }) {
    return _then(_self.copyWith(
      beneficiaries: null == beneficiaries
          ? _self.beneficiaries
          : beneficiaries // ignore: cast_nullable_to_non_nullable
              as List<BeneficiaryDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [BeneficiariesDto].
extension BeneficiariesDtoPatterns on BeneficiariesDto {
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
    TResult Function(_BeneficiariesDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeneficiariesDto() when $default != null:
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
    TResult Function(_BeneficiariesDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiariesDto():
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
    TResult? Function(_BeneficiariesDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiariesDto() when $default != null:
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
    TResult Function(List<BeneficiaryDto> beneficiaries)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeneficiariesDto() when $default != null:
        return $default(_that.beneficiaries);
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
    TResult Function(List<BeneficiaryDto> beneficiaries) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiariesDto():
        return $default(_that.beneficiaries);
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
    TResult? Function(List<BeneficiaryDto> beneficiaries)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiariesDto() when $default != null:
        return $default(_that.beneficiaries);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BeneficiariesDto extends BeneficiariesDto {
  const _BeneficiariesDto(
      {final List<BeneficiaryDto> beneficiaries = const <BeneficiaryDto>[]})
      : _beneficiaries = beneficiaries,
        super._();
  factory _BeneficiariesDto.fromJson(Map<String, dynamic> json) =>
      _$BeneficiariesDtoFromJson(json);

  final List<BeneficiaryDto> _beneficiaries;
  @override
  @JsonKey()
  List<BeneficiaryDto> get beneficiaries {
    if (_beneficiaries is EqualUnmodifiableListView) return _beneficiaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beneficiaries);
  }

  /// Create a copy of BeneficiariesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BeneficiariesDtoCopyWith<_BeneficiariesDto> get copyWith =>
      __$BeneficiariesDtoCopyWithImpl<_BeneficiariesDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BeneficiariesDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BeneficiariesDto &&
            const DeepCollectionEquality()
                .equals(other._beneficiaries, _beneficiaries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_beneficiaries));

  @override
  String toString() {
    return 'BeneficiariesDto(beneficiaries: $beneficiaries)';
  }
}

/// @nodoc
abstract mixin class _$BeneficiariesDtoCopyWith<$Res>
    implements $BeneficiariesDtoCopyWith<$Res> {
  factory _$BeneficiariesDtoCopyWith(
          _BeneficiariesDto value, $Res Function(_BeneficiariesDto) _then) =
      __$BeneficiariesDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<BeneficiaryDto> beneficiaries});
}

/// @nodoc
class __$BeneficiariesDtoCopyWithImpl<$Res>
    implements _$BeneficiariesDtoCopyWith<$Res> {
  __$BeneficiariesDtoCopyWithImpl(this._self, this._then);

  final _BeneficiariesDto _self;
  final $Res Function(_BeneficiariesDto) _then;

  /// Create a copy of BeneficiariesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? beneficiaries = null,
  }) {
    return _then(_BeneficiariesDto(
      beneficiaries: null == beneficiaries
          ? _self._beneficiaries
          : beneficiaries // ignore: cast_nullable_to_non_nullable
              as List<BeneficiaryDto>,
    ));
  }
}

/// @nodoc
mixin _$BeneficiaryDto {
  String get id;
  String get name;
  String get iban;
  String get bankName;
  String get currency;

  /// Create a copy of BeneficiaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BeneficiaryDtoCopyWith<BeneficiaryDto> get copyWith =>
      _$BeneficiaryDtoCopyWithImpl<BeneficiaryDto>(
          this as BeneficiaryDto, _$identity);

  /// Serializes this BeneficiaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BeneficiaryDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iban, iban) || other.iban == iban) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, iban, bankName, currency);

  @override
  String toString() {
    return 'BeneficiaryDto(id: $id, name: $name, iban: $iban, bankName: $bankName, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class $BeneficiaryDtoCopyWith<$Res> {
  factory $BeneficiaryDtoCopyWith(
          BeneficiaryDto value, $Res Function(BeneficiaryDto) _then) =
      _$BeneficiaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id, String name, String iban, String bankName, String currency});
}

/// @nodoc
class _$BeneficiaryDtoCopyWithImpl<$Res>
    implements $BeneficiaryDtoCopyWith<$Res> {
  _$BeneficiaryDtoCopyWithImpl(this._self, this._then);

  final BeneficiaryDto _self;
  final $Res Function(BeneficiaryDto) _then;

  /// Create a copy of BeneficiaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iban = null,
    Object? bankName = null,
    Object? currency = null,
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
      iban: null == iban
          ? _self.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [BeneficiaryDto].
extension BeneficiaryDtoPatterns on BeneficiaryDto {
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
    TResult Function(_BeneficiaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeneficiaryDto() when $default != null:
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
    TResult Function(_BeneficiaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiaryDto():
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
    TResult? Function(_BeneficiaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiaryDto() when $default != null:
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
    TResult Function(String id, String name, String iban, String bankName,
            String currency)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BeneficiaryDto() when $default != null:
        return $default(
            _that.id, _that.name, _that.iban, _that.bankName, _that.currency);
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
    TResult Function(String id, String name, String iban, String bankName,
            String currency)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiaryDto():
        return $default(
            _that.id, _that.name, _that.iban, _that.bankName, _that.currency);
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
    TResult? Function(String id, String name, String iban, String bankName,
            String currency)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BeneficiaryDto() when $default != null:
        return $default(
            _that.id, _that.name, _that.iban, _that.bankName, _that.currency);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BeneficiaryDto extends BeneficiaryDto {
  const _BeneficiaryDto(
      {required this.id,
      required this.name,
      required this.iban,
      required this.bankName,
      required this.currency})
      : super._();
  factory _BeneficiaryDto.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String iban;
  @override
  final String bankName;
  @override
  final String currency;

  /// Create a copy of BeneficiaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BeneficiaryDtoCopyWith<_BeneficiaryDto> get copyWith =>
      __$BeneficiaryDtoCopyWithImpl<_BeneficiaryDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BeneficiaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BeneficiaryDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iban, iban) || other.iban == iban) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, iban, bankName, currency);

  @override
  String toString() {
    return 'BeneficiaryDto(id: $id, name: $name, iban: $iban, bankName: $bankName, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class _$BeneficiaryDtoCopyWith<$Res>
    implements $BeneficiaryDtoCopyWith<$Res> {
  factory _$BeneficiaryDtoCopyWith(
          _BeneficiaryDto value, $Res Function(_BeneficiaryDto) _then) =
      __$BeneficiaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String name, String iban, String bankName, String currency});
}

/// @nodoc
class __$BeneficiaryDtoCopyWithImpl<$Res>
    implements _$BeneficiaryDtoCopyWith<$Res> {
  __$BeneficiaryDtoCopyWithImpl(this._self, this._then);

  final _BeneficiaryDto _self;
  final $Res Function(_BeneficiaryDto) _then;

  /// Create a copy of BeneficiaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iban = null,
    Object? bankName = null,
    Object? currency = null,
  }) {
    return _then(_BeneficiaryDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iban: null == iban
          ? _self.iban
          : iban // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$TransferQuoteDto {
  String get id;
  String get idempotencyKey;
  String get sourceAccountId;
  String get destinationLabel;
  String get destinationDetail;
  int get amountMinor;
  String get currency;
  int get feeMinor;
  int get totalDebitMinor;
  int get destinationAmountMinor;
  String get destinationCurrency;
  String? get rate;
  String? get scheduledFor;

  /// Create a copy of TransferQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferQuoteDtoCopyWith<TransferQuoteDto> get copyWith =>
      _$TransferQuoteDtoCopyWithImpl<TransferQuoteDto>(
          this as TransferQuoteDto, _$identity);

  /// Serializes this TransferQuoteDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferQuoteDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey) &&
            (identical(other.sourceAccountId, sourceAccountId) ||
                other.sourceAccountId == sourceAccountId) &&
            (identical(other.destinationLabel, destinationLabel) ||
                other.destinationLabel == destinationLabel) &&
            (identical(other.destinationDetail, destinationDetail) ||
                other.destinationDetail == destinationDetail) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.feeMinor, feeMinor) ||
                other.feeMinor == feeMinor) &&
            (identical(other.totalDebitMinor, totalDebitMinor) ||
                other.totalDebitMinor == totalDebitMinor) &&
            (identical(other.destinationAmountMinor, destinationAmountMinor) ||
                other.destinationAmountMinor == destinationAmountMinor) &&
            (identical(other.destinationCurrency, destinationCurrency) ||
                other.destinationCurrency == destinationCurrency) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      idempotencyKey,
      sourceAccountId,
      destinationLabel,
      destinationDetail,
      amountMinor,
      currency,
      feeMinor,
      totalDebitMinor,
      destinationAmountMinor,
      destinationCurrency,
      rate,
      scheduledFor);

  @override
  String toString() {
    return 'TransferQuoteDto(id: $id, idempotencyKey: $idempotencyKey, sourceAccountId: $sourceAccountId, destinationLabel: $destinationLabel, destinationDetail: $destinationDetail, amountMinor: $amountMinor, currency: $currency, feeMinor: $feeMinor, totalDebitMinor: $totalDebitMinor, destinationAmountMinor: $destinationAmountMinor, destinationCurrency: $destinationCurrency, rate: $rate, scheduledFor: $scheduledFor)';
  }
}

/// @nodoc
abstract mixin class $TransferQuoteDtoCopyWith<$Res> {
  factory $TransferQuoteDtoCopyWith(
          TransferQuoteDto value, $Res Function(TransferQuoteDto) _then) =
      _$TransferQuoteDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String idempotencyKey,
      String sourceAccountId,
      String destinationLabel,
      String destinationDetail,
      int amountMinor,
      String currency,
      int feeMinor,
      int totalDebitMinor,
      int destinationAmountMinor,
      String destinationCurrency,
      String? rate,
      String? scheduledFor});
}

/// @nodoc
class _$TransferQuoteDtoCopyWithImpl<$Res>
    implements $TransferQuoteDtoCopyWith<$Res> {
  _$TransferQuoteDtoCopyWithImpl(this._self, this._then);

  final TransferQuoteDto _self;
  final $Res Function(TransferQuoteDto) _then;

  /// Create a copy of TransferQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idempotencyKey = null,
    Object? sourceAccountId = null,
    Object? destinationLabel = null,
    Object? destinationDetail = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? feeMinor = null,
    Object? totalDebitMinor = null,
    Object? destinationAmountMinor = null,
    Object? destinationCurrency = null,
    Object? rate = freezed,
    Object? scheduledFor = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      idempotencyKey: null == idempotencyKey
          ? _self.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String,
      sourceAccountId: null == sourceAccountId
          ? _self.sourceAccountId
          : sourceAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationLabel: null == destinationLabel
          ? _self.destinationLabel
          : destinationLabel // ignore: cast_nullable_to_non_nullable
              as String,
      destinationDetail: null == destinationDetail
          ? _self.destinationDetail
          : destinationDetail // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      feeMinor: null == feeMinor
          ? _self.feeMinor
          : feeMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalDebitMinor: null == totalDebitMinor
          ? _self.totalDebitMinor
          : totalDebitMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationAmountMinor: null == destinationAmountMinor
          ? _self.destinationAmountMinor
          : destinationAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationCurrency: null == destinationCurrency
          ? _self.destinationCurrency
          : destinationCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      rate: freezed == rate
          ? _self.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledFor: freezed == scheduledFor
          ? _self.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TransferQuoteDto].
extension TransferQuoteDtoPatterns on TransferQuoteDto {
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
    TResult Function(_TransferQuoteDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransferQuoteDto() when $default != null:
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
    TResult Function(_TransferQuoteDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferQuoteDto():
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
    TResult? Function(_TransferQuoteDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferQuoteDto() when $default != null:
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
            String idempotencyKey,
            String sourceAccountId,
            String destinationLabel,
            String destinationDetail,
            int amountMinor,
            String currency,
            int feeMinor,
            int totalDebitMinor,
            int destinationAmountMinor,
            String destinationCurrency,
            String? rate,
            String? scheduledFor)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransferQuoteDto() when $default != null:
        return $default(
            _that.id,
            _that.idempotencyKey,
            _that.sourceAccountId,
            _that.destinationLabel,
            _that.destinationDetail,
            _that.amountMinor,
            _that.currency,
            _that.feeMinor,
            _that.totalDebitMinor,
            _that.destinationAmountMinor,
            _that.destinationCurrency,
            _that.rate,
            _that.scheduledFor);
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
            String idempotencyKey,
            String sourceAccountId,
            String destinationLabel,
            String destinationDetail,
            int amountMinor,
            String currency,
            int feeMinor,
            int totalDebitMinor,
            int destinationAmountMinor,
            String destinationCurrency,
            String? rate,
            String? scheduledFor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferQuoteDto():
        return $default(
            _that.id,
            _that.idempotencyKey,
            _that.sourceAccountId,
            _that.destinationLabel,
            _that.destinationDetail,
            _that.amountMinor,
            _that.currency,
            _that.feeMinor,
            _that.totalDebitMinor,
            _that.destinationAmountMinor,
            _that.destinationCurrency,
            _that.rate,
            _that.scheduledFor);
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
            String idempotencyKey,
            String sourceAccountId,
            String destinationLabel,
            String destinationDetail,
            int amountMinor,
            String currency,
            int feeMinor,
            int totalDebitMinor,
            int destinationAmountMinor,
            String destinationCurrency,
            String? rate,
            String? scheduledFor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferQuoteDto() when $default != null:
        return $default(
            _that.id,
            _that.idempotencyKey,
            _that.sourceAccountId,
            _that.destinationLabel,
            _that.destinationDetail,
            _that.amountMinor,
            _that.currency,
            _that.feeMinor,
            _that.totalDebitMinor,
            _that.destinationAmountMinor,
            _that.destinationCurrency,
            _that.rate,
            _that.scheduledFor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransferQuoteDto extends TransferQuoteDto {
  const _TransferQuoteDto(
      {required this.id,
      required this.idempotencyKey,
      required this.sourceAccountId,
      required this.destinationLabel,
      required this.destinationDetail,
      required this.amountMinor,
      required this.currency,
      required this.feeMinor,
      required this.totalDebitMinor,
      required this.destinationAmountMinor,
      required this.destinationCurrency,
      this.rate,
      this.scheduledFor})
      : super._();
  factory _TransferQuoteDto.fromJson(Map<String, dynamic> json) =>
      _$TransferQuoteDtoFromJson(json);

  @override
  final String id;
  @override
  final String idempotencyKey;
  @override
  final String sourceAccountId;
  @override
  final String destinationLabel;
  @override
  final String destinationDetail;
  @override
  final int amountMinor;
  @override
  final String currency;
  @override
  final int feeMinor;
  @override
  final int totalDebitMinor;
  @override
  final int destinationAmountMinor;
  @override
  final String destinationCurrency;
  @override
  final String? rate;
  @override
  final String? scheduledFor;

  /// Create a copy of TransferQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferQuoteDtoCopyWith<_TransferQuoteDto> get copyWith =>
      __$TransferQuoteDtoCopyWithImpl<_TransferQuoteDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferQuoteDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferQuoteDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey) &&
            (identical(other.sourceAccountId, sourceAccountId) ||
                other.sourceAccountId == sourceAccountId) &&
            (identical(other.destinationLabel, destinationLabel) ||
                other.destinationLabel == destinationLabel) &&
            (identical(other.destinationDetail, destinationDetail) ||
                other.destinationDetail == destinationDetail) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.feeMinor, feeMinor) ||
                other.feeMinor == feeMinor) &&
            (identical(other.totalDebitMinor, totalDebitMinor) ||
                other.totalDebitMinor == totalDebitMinor) &&
            (identical(other.destinationAmountMinor, destinationAmountMinor) ||
                other.destinationAmountMinor == destinationAmountMinor) &&
            (identical(other.destinationCurrency, destinationCurrency) ||
                other.destinationCurrency == destinationCurrency) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      idempotencyKey,
      sourceAccountId,
      destinationLabel,
      destinationDetail,
      amountMinor,
      currency,
      feeMinor,
      totalDebitMinor,
      destinationAmountMinor,
      destinationCurrency,
      rate,
      scheduledFor);

  @override
  String toString() {
    return 'TransferQuoteDto(id: $id, idempotencyKey: $idempotencyKey, sourceAccountId: $sourceAccountId, destinationLabel: $destinationLabel, destinationDetail: $destinationDetail, amountMinor: $amountMinor, currency: $currency, feeMinor: $feeMinor, totalDebitMinor: $totalDebitMinor, destinationAmountMinor: $destinationAmountMinor, destinationCurrency: $destinationCurrency, rate: $rate, scheduledFor: $scheduledFor)';
  }
}

/// @nodoc
abstract mixin class _$TransferQuoteDtoCopyWith<$Res>
    implements $TransferQuoteDtoCopyWith<$Res> {
  factory _$TransferQuoteDtoCopyWith(
          _TransferQuoteDto value, $Res Function(_TransferQuoteDto) _then) =
      __$TransferQuoteDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String idempotencyKey,
      String sourceAccountId,
      String destinationLabel,
      String destinationDetail,
      int amountMinor,
      String currency,
      int feeMinor,
      int totalDebitMinor,
      int destinationAmountMinor,
      String destinationCurrency,
      String? rate,
      String? scheduledFor});
}

/// @nodoc
class __$TransferQuoteDtoCopyWithImpl<$Res>
    implements _$TransferQuoteDtoCopyWith<$Res> {
  __$TransferQuoteDtoCopyWithImpl(this._self, this._then);

  final _TransferQuoteDto _self;
  final $Res Function(_TransferQuoteDto) _then;

  /// Create a copy of TransferQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? idempotencyKey = null,
    Object? sourceAccountId = null,
    Object? destinationLabel = null,
    Object? destinationDetail = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? feeMinor = null,
    Object? totalDebitMinor = null,
    Object? destinationAmountMinor = null,
    Object? destinationCurrency = null,
    Object? rate = freezed,
    Object? scheduledFor = freezed,
  }) {
    return _then(_TransferQuoteDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      idempotencyKey: null == idempotencyKey
          ? _self.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String,
      sourceAccountId: null == sourceAccountId
          ? _self.sourceAccountId
          : sourceAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationLabel: null == destinationLabel
          ? _self.destinationLabel
          : destinationLabel // ignore: cast_nullable_to_non_nullable
              as String,
      destinationDetail: null == destinationDetail
          ? _self.destinationDetail
          : destinationDetail // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      feeMinor: null == feeMinor
          ? _self.feeMinor
          : feeMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalDebitMinor: null == totalDebitMinor
          ? _self.totalDebitMinor
          : totalDebitMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationAmountMinor: null == destinationAmountMinor
          ? _self.destinationAmountMinor
          : destinationAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationCurrency: null == destinationCurrency
          ? _self.destinationCurrency
          : destinationCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      rate: freezed == rate
          ? _self.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledFor: freezed == scheduledFor
          ? _self.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TransferDto {
  String get id;
  String get reference;
  String get status;
  String get sourceAccountId;
  String get destinationLabel;
  String get destinationDetail;
  int get amountMinor;
  String get currency;
  int get feeMinor;
  int get totalDebitMinor;
  int get destinationAmountMinor;
  String get destinationCurrency;
  String get createdAt;
  String? get rate;
  String? get scheduledFor;
  int? get balanceAfterMinor;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferDtoCopyWith<TransferDto> get copyWith =>
      _$TransferDtoCopyWithImpl<TransferDto>(this as TransferDto, _$identity);

  /// Serializes this TransferDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourceAccountId, sourceAccountId) ||
                other.sourceAccountId == sourceAccountId) &&
            (identical(other.destinationLabel, destinationLabel) ||
                other.destinationLabel == destinationLabel) &&
            (identical(other.destinationDetail, destinationDetail) ||
                other.destinationDetail == destinationDetail) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.feeMinor, feeMinor) ||
                other.feeMinor == feeMinor) &&
            (identical(other.totalDebitMinor, totalDebitMinor) ||
                other.totalDebitMinor == totalDebitMinor) &&
            (identical(other.destinationAmountMinor, destinationAmountMinor) ||
                other.destinationAmountMinor == destinationAmountMinor) &&
            (identical(other.destinationCurrency, destinationCurrency) ||
                other.destinationCurrency == destinationCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.balanceAfterMinor, balanceAfterMinor) ||
                other.balanceAfterMinor == balanceAfterMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      reference,
      status,
      sourceAccountId,
      destinationLabel,
      destinationDetail,
      amountMinor,
      currency,
      feeMinor,
      totalDebitMinor,
      destinationAmountMinor,
      destinationCurrency,
      createdAt,
      rate,
      scheduledFor,
      balanceAfterMinor);

  @override
  String toString() {
    return 'TransferDto(id: $id, reference: $reference, status: $status, sourceAccountId: $sourceAccountId, destinationLabel: $destinationLabel, destinationDetail: $destinationDetail, amountMinor: $amountMinor, currency: $currency, feeMinor: $feeMinor, totalDebitMinor: $totalDebitMinor, destinationAmountMinor: $destinationAmountMinor, destinationCurrency: $destinationCurrency, createdAt: $createdAt, rate: $rate, scheduledFor: $scheduledFor, balanceAfterMinor: $balanceAfterMinor)';
  }
}

/// @nodoc
abstract mixin class $TransferDtoCopyWith<$Res> {
  factory $TransferDtoCopyWith(
          TransferDto value, $Res Function(TransferDto) _then) =
      _$TransferDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String reference,
      String status,
      String sourceAccountId,
      String destinationLabel,
      String destinationDetail,
      int amountMinor,
      String currency,
      int feeMinor,
      int totalDebitMinor,
      int destinationAmountMinor,
      String destinationCurrency,
      String createdAt,
      String? rate,
      String? scheduledFor,
      int? balanceAfterMinor});
}

/// @nodoc
class _$TransferDtoCopyWithImpl<$Res> implements $TransferDtoCopyWith<$Res> {
  _$TransferDtoCopyWithImpl(this._self, this._then);

  final TransferDto _self;
  final $Res Function(TransferDto) _then;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? sourceAccountId = null,
    Object? destinationLabel = null,
    Object? destinationDetail = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? feeMinor = null,
    Object? totalDebitMinor = null,
    Object? destinationAmountMinor = null,
    Object? destinationCurrency = null,
    Object? createdAt = null,
    Object? rate = freezed,
    Object? scheduledFor = freezed,
    Object? balanceAfterMinor = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _self.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceAccountId: null == sourceAccountId
          ? _self.sourceAccountId
          : sourceAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationLabel: null == destinationLabel
          ? _self.destinationLabel
          : destinationLabel // ignore: cast_nullable_to_non_nullable
              as String,
      destinationDetail: null == destinationDetail
          ? _self.destinationDetail
          : destinationDetail // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      feeMinor: null == feeMinor
          ? _self.feeMinor
          : feeMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalDebitMinor: null == totalDebitMinor
          ? _self.totalDebitMinor
          : totalDebitMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationAmountMinor: null == destinationAmountMinor
          ? _self.destinationAmountMinor
          : destinationAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationCurrency: null == destinationCurrency
          ? _self.destinationCurrency
          : destinationCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      rate: freezed == rate
          ? _self.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledFor: freezed == scheduledFor
          ? _self.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceAfterMinor: freezed == balanceAfterMinor
          ? _self.balanceAfterMinor
          : balanceAfterMinor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TransferDto].
extension TransferDtoPatterns on TransferDto {
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
    TResult Function(_TransferDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransferDto() when $default != null:
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
    TResult Function(_TransferDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferDto():
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
    TResult? Function(_TransferDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferDto() when $default != null:
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
            String reference,
            String status,
            String sourceAccountId,
            String destinationLabel,
            String destinationDetail,
            int amountMinor,
            String currency,
            int feeMinor,
            int totalDebitMinor,
            int destinationAmountMinor,
            String destinationCurrency,
            String createdAt,
            String? rate,
            String? scheduledFor,
            int? balanceAfterMinor)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransferDto() when $default != null:
        return $default(
            _that.id,
            _that.reference,
            _that.status,
            _that.sourceAccountId,
            _that.destinationLabel,
            _that.destinationDetail,
            _that.amountMinor,
            _that.currency,
            _that.feeMinor,
            _that.totalDebitMinor,
            _that.destinationAmountMinor,
            _that.destinationCurrency,
            _that.createdAt,
            _that.rate,
            _that.scheduledFor,
            _that.balanceAfterMinor);
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
            String reference,
            String status,
            String sourceAccountId,
            String destinationLabel,
            String destinationDetail,
            int amountMinor,
            String currency,
            int feeMinor,
            int totalDebitMinor,
            int destinationAmountMinor,
            String destinationCurrency,
            String createdAt,
            String? rate,
            String? scheduledFor,
            int? balanceAfterMinor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferDto():
        return $default(
            _that.id,
            _that.reference,
            _that.status,
            _that.sourceAccountId,
            _that.destinationLabel,
            _that.destinationDetail,
            _that.amountMinor,
            _that.currency,
            _that.feeMinor,
            _that.totalDebitMinor,
            _that.destinationAmountMinor,
            _that.destinationCurrency,
            _that.createdAt,
            _that.rate,
            _that.scheduledFor,
            _that.balanceAfterMinor);
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
            String reference,
            String status,
            String sourceAccountId,
            String destinationLabel,
            String destinationDetail,
            int amountMinor,
            String currency,
            int feeMinor,
            int totalDebitMinor,
            int destinationAmountMinor,
            String destinationCurrency,
            String createdAt,
            String? rate,
            String? scheduledFor,
            int? balanceAfterMinor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransferDto() when $default != null:
        return $default(
            _that.id,
            _that.reference,
            _that.status,
            _that.sourceAccountId,
            _that.destinationLabel,
            _that.destinationDetail,
            _that.amountMinor,
            _that.currency,
            _that.feeMinor,
            _that.totalDebitMinor,
            _that.destinationAmountMinor,
            _that.destinationCurrency,
            _that.createdAt,
            _that.rate,
            _that.scheduledFor,
            _that.balanceAfterMinor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransferDto extends TransferDto {
  const _TransferDto(
      {required this.id,
      required this.reference,
      required this.status,
      required this.sourceAccountId,
      required this.destinationLabel,
      required this.destinationDetail,
      required this.amountMinor,
      required this.currency,
      required this.feeMinor,
      required this.totalDebitMinor,
      required this.destinationAmountMinor,
      required this.destinationCurrency,
      required this.createdAt,
      this.rate,
      this.scheduledFor,
      this.balanceAfterMinor})
      : super._();
  factory _TransferDto.fromJson(Map<String, dynamic> json) =>
      _$TransferDtoFromJson(json);

  @override
  final String id;
  @override
  final String reference;
  @override
  final String status;
  @override
  final String sourceAccountId;
  @override
  final String destinationLabel;
  @override
  final String destinationDetail;
  @override
  final int amountMinor;
  @override
  final String currency;
  @override
  final int feeMinor;
  @override
  final int totalDebitMinor;
  @override
  final int destinationAmountMinor;
  @override
  final String destinationCurrency;
  @override
  final String createdAt;
  @override
  final String? rate;
  @override
  final String? scheduledFor;
  @override
  final int? balanceAfterMinor;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferDtoCopyWith<_TransferDto> get copyWith =>
      __$TransferDtoCopyWithImpl<_TransferDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourceAccountId, sourceAccountId) ||
                other.sourceAccountId == sourceAccountId) &&
            (identical(other.destinationLabel, destinationLabel) ||
                other.destinationLabel == destinationLabel) &&
            (identical(other.destinationDetail, destinationDetail) ||
                other.destinationDetail == destinationDetail) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.feeMinor, feeMinor) ||
                other.feeMinor == feeMinor) &&
            (identical(other.totalDebitMinor, totalDebitMinor) ||
                other.totalDebitMinor == totalDebitMinor) &&
            (identical(other.destinationAmountMinor, destinationAmountMinor) ||
                other.destinationAmountMinor == destinationAmountMinor) &&
            (identical(other.destinationCurrency, destinationCurrency) ||
                other.destinationCurrency == destinationCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.balanceAfterMinor, balanceAfterMinor) ||
                other.balanceAfterMinor == balanceAfterMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      reference,
      status,
      sourceAccountId,
      destinationLabel,
      destinationDetail,
      amountMinor,
      currency,
      feeMinor,
      totalDebitMinor,
      destinationAmountMinor,
      destinationCurrency,
      createdAt,
      rate,
      scheduledFor,
      balanceAfterMinor);

  @override
  String toString() {
    return 'TransferDto(id: $id, reference: $reference, status: $status, sourceAccountId: $sourceAccountId, destinationLabel: $destinationLabel, destinationDetail: $destinationDetail, amountMinor: $amountMinor, currency: $currency, feeMinor: $feeMinor, totalDebitMinor: $totalDebitMinor, destinationAmountMinor: $destinationAmountMinor, destinationCurrency: $destinationCurrency, createdAt: $createdAt, rate: $rate, scheduledFor: $scheduledFor, balanceAfterMinor: $balanceAfterMinor)';
  }
}

/// @nodoc
abstract mixin class _$TransferDtoCopyWith<$Res>
    implements $TransferDtoCopyWith<$Res> {
  factory _$TransferDtoCopyWith(
          _TransferDto value, $Res Function(_TransferDto) _then) =
      __$TransferDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String reference,
      String status,
      String sourceAccountId,
      String destinationLabel,
      String destinationDetail,
      int amountMinor,
      String currency,
      int feeMinor,
      int totalDebitMinor,
      int destinationAmountMinor,
      String destinationCurrency,
      String createdAt,
      String? rate,
      String? scheduledFor,
      int? balanceAfterMinor});
}

/// @nodoc
class __$TransferDtoCopyWithImpl<$Res> implements _$TransferDtoCopyWith<$Res> {
  __$TransferDtoCopyWithImpl(this._self, this._then);

  final _TransferDto _self;
  final $Res Function(_TransferDto) _then;

  /// Create a copy of TransferDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? sourceAccountId = null,
    Object? destinationLabel = null,
    Object? destinationDetail = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? feeMinor = null,
    Object? totalDebitMinor = null,
    Object? destinationAmountMinor = null,
    Object? destinationCurrency = null,
    Object? createdAt = null,
    Object? rate = freezed,
    Object? scheduledFor = freezed,
    Object? balanceAfterMinor = freezed,
  }) {
    return _then(_TransferDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reference: null == reference
          ? _self.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceAccountId: null == sourceAccountId
          ? _self.sourceAccountId
          : sourceAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationLabel: null == destinationLabel
          ? _self.destinationLabel
          : destinationLabel // ignore: cast_nullable_to_non_nullable
              as String,
      destinationDetail: null == destinationDetail
          ? _self.destinationDetail
          : destinationDetail // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      feeMinor: null == feeMinor
          ? _self.feeMinor
          : feeMinor // ignore: cast_nullable_to_non_nullable
              as int,
      totalDebitMinor: null == totalDebitMinor
          ? _self.totalDebitMinor
          : totalDebitMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationAmountMinor: null == destinationAmountMinor
          ? _self.destinationAmountMinor
          : destinationAmountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      destinationCurrency: null == destinationCurrency
          ? _self.destinationCurrency
          : destinationCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      rate: freezed == rate
          ? _self.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledFor: freezed == scheduledFor
          ? _self.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceAfterMinor: freezed == balanceAfterMinor
          ? _self.balanceAfterMinor
          : balanceAfterMinor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
