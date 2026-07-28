// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pot_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PotsDto {
  List<PotDto> get pots;

  /// Create a copy of PotsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PotsDtoCopyWith<PotsDto> get copyWith =>
      _$PotsDtoCopyWithImpl<PotsDto>(this as PotsDto, _$identity);

  /// Serializes this PotsDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PotsDto &&
            const DeepCollectionEquality().equals(other.pots, pots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(pots));

  @override
  String toString() {
    return 'PotsDto(pots: $pots)';
  }
}

/// @nodoc
abstract mixin class $PotsDtoCopyWith<$Res> {
  factory $PotsDtoCopyWith(PotsDto value, $Res Function(PotsDto) _then) =
      _$PotsDtoCopyWithImpl;
  @useResult
  $Res call({List<PotDto> pots});
}

/// @nodoc
class _$PotsDtoCopyWithImpl<$Res> implements $PotsDtoCopyWith<$Res> {
  _$PotsDtoCopyWithImpl(this._self, this._then);

  final PotsDto _self;
  final $Res Function(PotsDto) _then;

  /// Create a copy of PotsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pots = null,
  }) {
    return _then(_self.copyWith(
      pots: null == pots
          ? _self.pots
          : pots // ignore: cast_nullable_to_non_nullable
              as List<PotDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PotsDto].
extension PotsDtoPatterns on PotsDto {
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
    TResult Function(_PotsDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PotsDto() when $default != null:
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
    TResult Function(_PotsDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotsDto():
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
    TResult? Function(_PotsDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotsDto() when $default != null:
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
    TResult Function(List<PotDto> pots)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PotsDto() when $default != null:
        return $default(_that.pots);
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
    TResult Function(List<PotDto> pots) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotsDto():
        return $default(_that.pots);
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
    TResult? Function(List<PotDto> pots)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotsDto() when $default != null:
        return $default(_that.pots);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PotsDto extends PotsDto {
  const _PotsDto({final List<PotDto> pots = const <PotDto>[]})
      : _pots = pots,
        super._();
  factory _PotsDto.fromJson(Map<String, dynamic> json) =>
      _$PotsDtoFromJson(json);

  final List<PotDto> _pots;
  @override
  @JsonKey()
  List<PotDto> get pots {
    if (_pots is EqualUnmodifiableListView) return _pots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pots);
  }

  /// Create a copy of PotsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PotsDtoCopyWith<_PotsDto> get copyWith =>
      __$PotsDtoCopyWithImpl<_PotsDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PotsDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PotsDto &&
            const DeepCollectionEquality().equals(other._pots, _pots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_pots));

  @override
  String toString() {
    return 'PotsDto(pots: $pots)';
  }
}

/// @nodoc
abstract mixin class _$PotsDtoCopyWith<$Res> implements $PotsDtoCopyWith<$Res> {
  factory _$PotsDtoCopyWith(_PotsDto value, $Res Function(_PotsDto) _then) =
      __$PotsDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<PotDto> pots});
}

/// @nodoc
class __$PotsDtoCopyWithImpl<$Res> implements _$PotsDtoCopyWith<$Res> {
  __$PotsDtoCopyWithImpl(this._self, this._then);

  final _PotsDto _self;
  final $Res Function(_PotsDto) _then;

  /// Create a copy of PotsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pots = null,
  }) {
    return _then(_PotsDto(
      pots: null == pots
          ? _self._pots
          : pots // ignore: cast_nullable_to_non_nullable
              as List<PotDto>,
    ));
  }
}

/// @nodoc
mixin _$PotDto {
  String get id;
  String get accountId;
  String get name;
  int get balanceMinor;
  String get currency;
  int? get goalMinor;
  bool get roundUpsEnabled;

  /// Create a copy of PotDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PotDtoCopyWith<PotDto> get copyWith =>
      _$PotDtoCopyWithImpl<PotDto>(this as PotDto, _$identity);

  /// Serializes this PotDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PotDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.goalMinor, goalMinor) ||
                other.goalMinor == goalMinor) &&
            (identical(other.roundUpsEnabled, roundUpsEnabled) ||
                other.roundUpsEnabled == roundUpsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, name,
      balanceMinor, currency, goalMinor, roundUpsEnabled);

  @override
  String toString() {
    return 'PotDto(id: $id, accountId: $accountId, name: $name, balanceMinor: $balanceMinor, currency: $currency, goalMinor: $goalMinor, roundUpsEnabled: $roundUpsEnabled)';
  }
}

/// @nodoc
abstract mixin class $PotDtoCopyWith<$Res> {
  factory $PotDtoCopyWith(PotDto value, $Res Function(PotDto) _then) =
      _$PotDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String accountId,
      String name,
      int balanceMinor,
      String currency,
      int? goalMinor,
      bool roundUpsEnabled});
}

/// @nodoc
class _$PotDtoCopyWithImpl<$Res> implements $PotDtoCopyWith<$Res> {
  _$PotDtoCopyWithImpl(this._self, this._then);

  final PotDto _self;
  final $Res Function(PotDto) _then;

  /// Create a copy of PotDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? name = null,
    Object? balanceMinor = null,
    Object? currency = null,
    Object? goalMinor = freezed,
    Object? roundUpsEnabled = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      goalMinor: freezed == goalMinor
          ? _self.goalMinor
          : goalMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      roundUpsEnabled: null == roundUpsEnabled
          ? _self.roundUpsEnabled
          : roundUpsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [PotDto].
extension PotDtoPatterns on PotDto {
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
    TResult Function(_PotDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PotDto() when $default != null:
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
    TResult Function(_PotDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotDto():
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
    TResult? Function(_PotDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotDto() when $default != null:
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
    TResult Function(String id, String accountId, String name, int balanceMinor,
            String currency, int? goalMinor, bool roundUpsEnabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PotDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.name,
            _that.balanceMinor,
            _that.currency,
            _that.goalMinor,
            _that.roundUpsEnabled);
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
    TResult Function(String id, String accountId, String name, int balanceMinor,
            String currency, int? goalMinor, bool roundUpsEnabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotDto():
        return $default(
            _that.id,
            _that.accountId,
            _that.name,
            _that.balanceMinor,
            _that.currency,
            _that.goalMinor,
            _that.roundUpsEnabled);
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
            String name,
            int balanceMinor,
            String currency,
            int? goalMinor,
            bool roundUpsEnabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PotDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.name,
            _that.balanceMinor,
            _that.currency,
            _that.goalMinor,
            _that.roundUpsEnabled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PotDto extends PotDto {
  const _PotDto(
      {required this.id,
      required this.accountId,
      required this.name,
      required this.balanceMinor,
      required this.currency,
      this.goalMinor,
      this.roundUpsEnabled = false})
      : super._();
  factory _PotDto.fromJson(Map<String, dynamic> json) => _$PotDtoFromJson(json);

  @override
  final String id;
  @override
  final String accountId;
  @override
  final String name;
  @override
  final int balanceMinor;
  @override
  final String currency;
  @override
  final int? goalMinor;
  @override
  @JsonKey()
  final bool roundUpsEnabled;

  /// Create a copy of PotDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PotDtoCopyWith<_PotDto> get copyWith =>
      __$PotDtoCopyWithImpl<_PotDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PotDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PotDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balanceMinor, balanceMinor) ||
                other.balanceMinor == balanceMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.goalMinor, goalMinor) ||
                other.goalMinor == goalMinor) &&
            (identical(other.roundUpsEnabled, roundUpsEnabled) ||
                other.roundUpsEnabled == roundUpsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, name,
      balanceMinor, currency, goalMinor, roundUpsEnabled);

  @override
  String toString() {
    return 'PotDto(id: $id, accountId: $accountId, name: $name, balanceMinor: $balanceMinor, currency: $currency, goalMinor: $goalMinor, roundUpsEnabled: $roundUpsEnabled)';
  }
}

/// @nodoc
abstract mixin class _$PotDtoCopyWith<$Res> implements $PotDtoCopyWith<$Res> {
  factory _$PotDtoCopyWith(_PotDto value, $Res Function(_PotDto) _then) =
      __$PotDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String accountId,
      String name,
      int balanceMinor,
      String currency,
      int? goalMinor,
      bool roundUpsEnabled});
}

/// @nodoc
class __$PotDtoCopyWithImpl<$Res> implements _$PotDtoCopyWith<$Res> {
  __$PotDtoCopyWithImpl(this._self, this._then);

  final _PotDto _self;
  final $Res Function(_PotDto) _then;

  /// Create a copy of PotDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? accountId = null,
    Object? name = null,
    Object? balanceMinor = null,
    Object? currency = null,
    Object? goalMinor = freezed,
    Object? roundUpsEnabled = null,
  }) {
    return _then(_PotDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balanceMinor: null == balanceMinor
          ? _self.balanceMinor
          : balanceMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      goalMinor: freezed == goalMinor
          ? _self.goalMinor
          : goalMinor // ignore: cast_nullable_to_non_nullable
              as int?,
      roundUpsEnabled: null == roundUpsEnabled
          ? _self.roundUpsEnabled
          : roundUpsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
