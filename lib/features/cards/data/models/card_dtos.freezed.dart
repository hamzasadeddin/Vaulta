// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardsDto {
  List<CardDto> get cards;

  /// Create a copy of CardsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardsDtoCopyWith<CardsDto> get copyWith =>
      _$CardsDtoCopyWithImpl<CardsDto>(this as CardsDto, _$identity);

  /// Serializes this CardsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardsDto &&
            const DeepCollectionEquality().equals(other.cards, cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(cards));

  @override
  String toString() {
    return 'CardsDto(cards: $cards)';
  }
}

/// @nodoc
abstract mixin class $CardsDtoCopyWith<$Res> {
  factory $CardsDtoCopyWith(CardsDto value, $Res Function(CardsDto) _then) =
      _$CardsDtoCopyWithImpl;
  @useResult
  $Res call({List<CardDto> cards});
}

/// @nodoc
class _$CardsDtoCopyWithImpl<$Res> implements $CardsDtoCopyWith<$Res> {
  _$CardsDtoCopyWithImpl(this._self, this._then);

  final CardsDto _self;
  final $Res Function(CardsDto) _then;

  /// Create a copy of CardsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cards = null,
  }) {
    return _then(_self.copyWith(
      cards: null == cards
          ? _self.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<CardDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CardsDto].
extension CardsDtoPatterns on CardsDto {
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
    TResult Function(_CardsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CardsDto() when $default != null:
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
    TResult Function(_CardsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardsDto():
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
    TResult? Function(_CardsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardsDto() when $default != null:
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
    TResult Function(List<CardDto> cards)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CardsDto() when $default != null:
        return $default(_that.cards);
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
    TResult Function(List<CardDto> cards) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardsDto():
        return $default(_that.cards);
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
    TResult? Function(List<CardDto> cards)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardsDto() when $default != null:
        return $default(_that.cards);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CardsDto extends CardsDto {
  const _CardsDto({final List<CardDto> cards = const <CardDto>[]})
      : _cards = cards,
        super._();
  factory _CardsDto.fromJson(Map<String, dynamic> json) =>
      _$CardsDtoFromJson(json);

  final List<CardDto> _cards;
  @override
  @JsonKey()
  List<CardDto> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  /// Create a copy of CardsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardsDtoCopyWith<_CardsDto> get copyWith =>
      __$CardsDtoCopyWithImpl<_CardsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardsDto &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cards));

  @override
  String toString() {
    return 'CardsDto(cards: $cards)';
  }
}

/// @nodoc
abstract mixin class _$CardsDtoCopyWith<$Res>
    implements $CardsDtoCopyWith<$Res> {
  factory _$CardsDtoCopyWith(_CardsDto value, $Res Function(_CardsDto) _then) =
      __$CardsDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<CardDto> cards});
}

/// @nodoc
class __$CardsDtoCopyWithImpl<$Res> implements _$CardsDtoCopyWith<$Res> {
  __$CardsDtoCopyWithImpl(this._self, this._then);

  final _CardsDto _self;
  final $Res Function(_CardsDto) _then;

  /// Create a copy of CardsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cards = null,
  }) {
    return _then(_CardsDto(
      cards: null == cards
          ? _self._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<CardDto>,
    ));
  }
}

/// @nodoc
mixin _$CardDto {
  String get id;
  String get accountId;
  String get label;
  String get type;
  String get network;
  String get status;
  String get panLast4;
  int get expiryMonth;
  int get expiryYear;
  String get currency;
  CardLimitsDto get limits;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardDtoCopyWith<CardDto> get copyWith =>
      _$CardDtoCopyWithImpl<CardDto>(this as CardDto, _$identity);

  /// Serializes this CardDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.panLast4, panLast4) ||
                other.panLast4 == panLast4) &&
            (identical(other.expiryMonth, expiryMonth) ||
                other.expiryMonth == expiryMonth) &&
            (identical(other.expiryYear, expiryYear) ||
                other.expiryYear == expiryYear) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.limits, limits) || other.limits == limits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, label, type,
      network, status, panLast4, expiryMonth, expiryYear, currency, limits);

  @override
  String toString() {
    return 'CardDto(id: $id, accountId: $accountId, label: $label, type: $type, network: $network, status: $status, panLast4: $panLast4, expiryMonth: $expiryMonth, expiryYear: $expiryYear, currency: $currency, limits: $limits)';
  }
}

/// @nodoc
abstract mixin class $CardDtoCopyWith<$Res> {
  factory $CardDtoCopyWith(CardDto value, $Res Function(CardDto) _then) =
      _$CardDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String accountId,
      String label,
      String type,
      String network,
      String status,
      String panLast4,
      int expiryMonth,
      int expiryYear,
      String currency,
      CardLimitsDto limits});

  $CardLimitsDtoCopyWith<$Res> get limits;
}

/// @nodoc
class _$CardDtoCopyWithImpl<$Res> implements $CardDtoCopyWith<$Res> {
  _$CardDtoCopyWithImpl(this._self, this._then);

  final CardDto _self;
  final $Res Function(CardDto) _then;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? label = null,
    Object? type = null,
    Object? network = null,
    Object? status = null,
    Object? panLast4 = null,
    Object? expiryMonth = null,
    Object? expiryYear = null,
    Object? currency = null,
    Object? limits = null,
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
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _self.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      panLast4: null == panLast4
          ? _self.panLast4
          : panLast4 // ignore: cast_nullable_to_non_nullable
              as String,
      expiryMonth: null == expiryMonth
          ? _self.expiryMonth
          : expiryMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expiryYear: null == expiryYear
          ? _self.expiryYear
          : expiryYear // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      limits: null == limits
          ? _self.limits
          : limits // ignore: cast_nullable_to_non_nullable
              as CardLimitsDto,
    ));
  }

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardLimitsDtoCopyWith<$Res> get limits {
    return $CardLimitsDtoCopyWith<$Res>(_self.limits, (value) {
      return _then(_self.copyWith(limits: value));
    });
  }
}

/// Adds pattern-matching-related methods to [CardDto].
extension CardDtoPatterns on CardDto {
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
    TResult Function(_CardDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CardDto() when $default != null:
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
    TResult Function(_CardDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardDto():
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
    TResult? Function(_CardDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardDto() when $default != null:
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
            String label,
            String type,
            String network,
            String status,
            String panLast4,
            int expiryMonth,
            int expiryYear,
            String currency,
            CardLimitsDto limits)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CardDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.label,
            _that.type,
            _that.network,
            _that.status,
            _that.panLast4,
            _that.expiryMonth,
            _that.expiryYear,
            _that.currency,
            _that.limits);
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
            String label,
            String type,
            String network,
            String status,
            String panLast4,
            int expiryMonth,
            int expiryYear,
            String currency,
            CardLimitsDto limits)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardDto():
        return $default(
            _that.id,
            _that.accountId,
            _that.label,
            _that.type,
            _that.network,
            _that.status,
            _that.panLast4,
            _that.expiryMonth,
            _that.expiryYear,
            _that.currency,
            _that.limits);
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
            String label,
            String type,
            String network,
            String status,
            String panLast4,
            int expiryMonth,
            int expiryYear,
            String currency,
            CardLimitsDto limits)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.label,
            _that.type,
            _that.network,
            _that.status,
            _that.panLast4,
            _that.expiryMonth,
            _that.expiryYear,
            _that.currency,
            _that.limits);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CardDto extends CardDto {
  const _CardDto(
      {required this.id,
      required this.accountId,
      required this.label,
      required this.type,
      required this.network,
      required this.status,
      required this.panLast4,
      required this.expiryMonth,
      required this.expiryYear,
      required this.currency,
      required this.limits})
      : super._();
  factory _CardDto.fromJson(Map<String, dynamic> json) =>
      _$CardDtoFromJson(json);

  @override
  final String id;
  @override
  final String accountId;
  @override
  final String label;
  @override
  final String type;
  @override
  final String network;
  @override
  final String status;
  @override
  final String panLast4;
  @override
  final int expiryMonth;
  @override
  final int expiryYear;
  @override
  final String currency;
  @override
  final CardLimitsDto limits;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardDtoCopyWith<_CardDto> get copyWith =>
      __$CardDtoCopyWithImpl<_CardDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.network, network) || other.network == network) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.panLast4, panLast4) ||
                other.panLast4 == panLast4) &&
            (identical(other.expiryMonth, expiryMonth) ||
                other.expiryMonth == expiryMonth) &&
            (identical(other.expiryYear, expiryYear) ||
                other.expiryYear == expiryYear) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.limits, limits) || other.limits == limits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, label, type,
      network, status, panLast4, expiryMonth, expiryYear, currency, limits);

  @override
  String toString() {
    return 'CardDto(id: $id, accountId: $accountId, label: $label, type: $type, network: $network, status: $status, panLast4: $panLast4, expiryMonth: $expiryMonth, expiryYear: $expiryYear, currency: $currency, limits: $limits)';
  }
}

/// @nodoc
abstract mixin class _$CardDtoCopyWith<$Res> implements $CardDtoCopyWith<$Res> {
  factory _$CardDtoCopyWith(_CardDto value, $Res Function(_CardDto) _then) =
      __$CardDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String accountId,
      String label,
      String type,
      String network,
      String status,
      String panLast4,
      int expiryMonth,
      int expiryYear,
      String currency,
      CardLimitsDto limits});

  @override
  $CardLimitsDtoCopyWith<$Res> get limits;
}

/// @nodoc
class __$CardDtoCopyWithImpl<$Res> implements _$CardDtoCopyWith<$Res> {
  __$CardDtoCopyWithImpl(this._self, this._then);

  final _CardDto _self;
  final $Res Function(_CardDto) _then;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? label = null,
    Object? type = null,
    Object? network = null,
    Object? status = null,
    Object? panLast4 = null,
    Object? expiryMonth = null,
    Object? expiryYear = null,
    Object? currency = null,
    Object? limits = null,
  }) {
    return _then(_CardDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _self.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      panLast4: null == panLast4
          ? _self.panLast4
          : panLast4 // ignore: cast_nullable_to_non_nullable
              as String,
      expiryMonth: null == expiryMonth
          ? _self.expiryMonth
          : expiryMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expiryYear: null == expiryYear
          ? _self.expiryYear
          : expiryYear // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      limits: null == limits
          ? _self.limits
          : limits // ignore: cast_nullable_to_non_nullable
              as CardLimitsDto,
    ));
  }

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardLimitsDtoCopyWith<$Res> get limits {
    return $CardLimitsDtoCopyWith<$Res>(_self.limits, (value) {
      return _then(_self.copyWith(limits: value));
    });
  }
}

/// @nodoc
mixin _$CardLimitsDto {
  int get dailyMinor;
  int get monthlyMinor;
  int get spentTodayMinor;
  int get spentThisMonthMinor;

  /// Create a copy of CardLimitsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardLimitsDtoCopyWith<CardLimitsDto> get copyWith =>
      _$CardLimitsDtoCopyWithImpl<CardLimitsDto>(
          this as CardLimitsDto, _$identity);

  /// Serializes this CardLimitsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardLimitsDto &&
            (identical(other.dailyMinor, dailyMinor) ||
                other.dailyMinor == dailyMinor) &&
            (identical(other.monthlyMinor, monthlyMinor) ||
                other.monthlyMinor == monthlyMinor) &&
            (identical(other.spentTodayMinor, spentTodayMinor) ||
                other.spentTodayMinor == spentTodayMinor) &&
            (identical(other.spentThisMonthMinor, spentThisMonthMinor) ||
                other.spentThisMonthMinor == spentThisMonthMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dailyMinor, monthlyMinor,
      spentTodayMinor, spentThisMonthMinor);

  @override
  String toString() {
    return 'CardLimitsDto(dailyMinor: $dailyMinor, monthlyMinor: $monthlyMinor, spentTodayMinor: $spentTodayMinor, spentThisMonthMinor: $spentThisMonthMinor)';
  }
}

/// @nodoc
abstract mixin class $CardLimitsDtoCopyWith<$Res> {
  factory $CardLimitsDtoCopyWith(
          CardLimitsDto value, $Res Function(CardLimitsDto) _then) =
      _$CardLimitsDtoCopyWithImpl;
  @useResult
  $Res call(
      {int dailyMinor,
      int monthlyMinor,
      int spentTodayMinor,
      int spentThisMonthMinor});
}

/// @nodoc
class _$CardLimitsDtoCopyWithImpl<$Res>
    implements $CardLimitsDtoCopyWith<$Res> {
  _$CardLimitsDtoCopyWithImpl(this._self, this._then);

  final CardLimitsDto _self;
  final $Res Function(CardLimitsDto) _then;

  /// Create a copy of CardLimitsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyMinor = null,
    Object? monthlyMinor = null,
    Object? spentTodayMinor = null,
    Object? spentThisMonthMinor = null,
  }) {
    return _then(_self.copyWith(
      dailyMinor: null == dailyMinor
          ? _self.dailyMinor
          : dailyMinor // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyMinor: null == monthlyMinor
          ? _self.monthlyMinor
          : monthlyMinor // ignore: cast_nullable_to_non_nullable
              as int,
      spentTodayMinor: null == spentTodayMinor
          ? _self.spentTodayMinor
          : spentTodayMinor // ignore: cast_nullable_to_non_nullable
              as int,
      spentThisMonthMinor: null == spentThisMonthMinor
          ? _self.spentThisMonthMinor
          : spentThisMonthMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [CardLimitsDto].
extension CardLimitsDtoPatterns on CardLimitsDto {
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
    TResult Function(_CardLimitsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CardLimitsDto() when $default != null:
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
    TResult Function(_CardLimitsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardLimitsDto():
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
    TResult? Function(_CardLimitsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardLimitsDto() when $default != null:
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
    TResult Function(int dailyMinor, int monthlyMinor, int spentTodayMinor,
            int spentThisMonthMinor)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CardLimitsDto() when $default != null:
        return $default(_that.dailyMinor, _that.monthlyMinor,
            _that.spentTodayMinor, _that.spentThisMonthMinor);
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
    TResult Function(int dailyMinor, int monthlyMinor, int spentTodayMinor,
            int spentThisMonthMinor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardLimitsDto():
        return $default(_that.dailyMinor, _that.monthlyMinor,
            _that.spentTodayMinor, _that.spentThisMonthMinor);
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
    TResult? Function(int dailyMinor, int monthlyMinor, int spentTodayMinor,
            int spentThisMonthMinor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CardLimitsDto() when $default != null:
        return $default(_that.dailyMinor, _that.monthlyMinor,
            _that.spentTodayMinor, _that.spentThisMonthMinor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CardLimitsDto extends CardLimitsDto {
  const _CardLimitsDto(
      {required this.dailyMinor,
      required this.monthlyMinor,
      this.spentTodayMinor = 0,
      this.spentThisMonthMinor = 0})
      : super._();
  factory _CardLimitsDto.fromJson(Map<String, dynamic> json) =>
      _$CardLimitsDtoFromJson(json);

  @override
  final int dailyMinor;
  @override
  final int monthlyMinor;
  @override
  @JsonKey()
  final int spentTodayMinor;
  @override
  @JsonKey()
  final int spentThisMonthMinor;

  /// Create a copy of CardLimitsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardLimitsDtoCopyWith<_CardLimitsDto> get copyWith =>
      __$CardLimitsDtoCopyWithImpl<_CardLimitsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardLimitsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardLimitsDto &&
            (identical(other.dailyMinor, dailyMinor) ||
                other.dailyMinor == dailyMinor) &&
            (identical(other.monthlyMinor, monthlyMinor) ||
                other.monthlyMinor == monthlyMinor) &&
            (identical(other.spentTodayMinor, spentTodayMinor) ||
                other.spentTodayMinor == spentTodayMinor) &&
            (identical(other.spentThisMonthMinor, spentThisMonthMinor) ||
                other.spentThisMonthMinor == spentThisMonthMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dailyMinor, monthlyMinor,
      spentTodayMinor, spentThisMonthMinor);

  @override
  String toString() {
    return 'CardLimitsDto(dailyMinor: $dailyMinor, monthlyMinor: $monthlyMinor, spentTodayMinor: $spentTodayMinor, spentThisMonthMinor: $spentThisMonthMinor)';
  }
}

/// @nodoc
abstract mixin class _$CardLimitsDtoCopyWith<$Res>
    implements $CardLimitsDtoCopyWith<$Res> {
  factory _$CardLimitsDtoCopyWith(
          _CardLimitsDto value, $Res Function(_CardLimitsDto) _then) =
      __$CardLimitsDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int dailyMinor,
      int monthlyMinor,
      int spentTodayMinor,
      int spentThisMonthMinor});
}

/// @nodoc
class __$CardLimitsDtoCopyWithImpl<$Res>
    implements _$CardLimitsDtoCopyWith<$Res> {
  __$CardLimitsDtoCopyWithImpl(this._self, this._then);

  final _CardLimitsDto _self;
  final $Res Function(_CardLimitsDto) _then;

  /// Create a copy of CardLimitsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dailyMinor = null,
    Object? monthlyMinor = null,
    Object? spentTodayMinor = null,
    Object? spentThisMonthMinor = null,
  }) {
    return _then(_CardLimitsDto(
      dailyMinor: null == dailyMinor
          ? _self.dailyMinor
          : dailyMinor // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyMinor: null == monthlyMinor
          ? _self.monthlyMinor
          : monthlyMinor // ignore: cast_nullable_to_non_nullable
              as int,
      spentTodayMinor: null == spentTodayMinor
          ? _self.spentTodayMinor
          : spentTodayMinor // ignore: cast_nullable_to_non_nullable
              as int,
      spentThisMonthMinor: null == spentThisMonthMinor
          ? _self.spentThisMonthMinor
          : spentThisMonthMinor // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
