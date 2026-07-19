// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionsPageDto {
  List<TransactionDto> get transactions;
  String? get nextCursor;

  /// Create a copy of TransactionsPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionsPageDtoCopyWith<TransactionsPageDto> get copyWith =>
      _$TransactionsPageDtoCopyWithImpl<TransactionsPageDto>(
          this as TransactionsPageDto, _$identity);

  /// Serializes this TransactionsPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionsPageDto &&
            const DeepCollectionEquality()
                .equals(other.transactions, transactions) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(transactions), nextCursor);

  @override
  String toString() {
    return 'TransactionsPageDto(transactions: $transactions, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $TransactionsPageDtoCopyWith<$Res> {
  factory $TransactionsPageDtoCopyWith(
          TransactionsPageDto value, $Res Function(TransactionsPageDto) _then) =
      _$TransactionsPageDtoCopyWithImpl;
  @useResult
  $Res call({List<TransactionDto> transactions, String? nextCursor});
}

/// @nodoc
class _$TransactionsPageDtoCopyWithImpl<$Res>
    implements $TransactionsPageDtoCopyWith<$Res> {
  _$TransactionsPageDtoCopyWithImpl(this._self, this._then);

  final TransactionsPageDto _self;
  final $Res Function(TransactionsPageDto) _then;

  /// Create a copy of TransactionsPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      transactions: null == transactions
          ? _self.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TransactionsPageDto].
extension TransactionsPageDtoPatterns on TransactionsPageDto {
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
    TResult Function(_TransactionsPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionsPageDto() when $default != null:
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
    TResult Function(_TransactionsPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionsPageDto():
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
    TResult? Function(_TransactionsPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionsPageDto() when $default != null:
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
    TResult Function(List<TransactionDto> transactions, String? nextCursor)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionsPageDto() when $default != null:
        return $default(_that.transactions, _that.nextCursor);
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
    TResult Function(List<TransactionDto> transactions, String? nextCursor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionsPageDto():
        return $default(_that.transactions, _that.nextCursor);
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
    TResult? Function(List<TransactionDto> transactions, String? nextCursor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionsPageDto() when $default != null:
        return $default(_that.transactions, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionsPageDto extends TransactionsPageDto {
  const _TransactionsPageDto(
      {final List<TransactionDto> transactions = const <TransactionDto>[],
      this.nextCursor})
      : _transactions = transactions,
        super._();
  factory _TransactionsPageDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionsPageDtoFromJson(json);

  final List<TransactionDto> _transactions;
  @override
  @JsonKey()
  List<TransactionDto> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final String? nextCursor;

  /// Create a copy of TransactionsPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionsPageDtoCopyWith<_TransactionsPageDto> get copyWith =>
      __$TransactionsPageDtoCopyWithImpl<_TransactionsPageDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionsPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionsPageDto &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_transactions), nextCursor);

  @override
  String toString() {
    return 'TransactionsPageDto(transactions: $transactions, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$TransactionsPageDtoCopyWith<$Res>
    implements $TransactionsPageDtoCopyWith<$Res> {
  factory _$TransactionsPageDtoCopyWith(_TransactionsPageDto value,
          $Res Function(_TransactionsPageDto) _then) =
      __$TransactionsPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<TransactionDto> transactions, String? nextCursor});
}

/// @nodoc
class __$TransactionsPageDtoCopyWithImpl<$Res>
    implements _$TransactionsPageDtoCopyWith<$Res> {
  __$TransactionsPageDtoCopyWithImpl(this._self, this._then);

  final _TransactionsPageDto _self;
  final $Res Function(_TransactionsPageDto) _then;

  /// Create a copy of TransactionsPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? transactions = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_TransactionsPageDto(
      transactions: null == transactions
          ? _self._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TransactionDto {
  String get id;
  String get accountId;
  String get title;
  String get category;
  int get amountMinor;
  String get currency;
  String get occurredAt;
  String get reference;
  String get status;
  int? get balanceAfterMinor;

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
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.balanceAfterMinor, balanceAfterMinor) ||
                other.balanceAfterMinor == balanceAfterMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, title, category,
      amountMinor, currency, occurredAt, reference, status, balanceAfterMinor);

  @override
  String toString() {
    return 'TransactionDto(id: $id, accountId: $accountId, title: $title, category: $category, amountMinor: $amountMinor, currency: $currency, occurredAt: $occurredAt, reference: $reference, status: $status, balanceAfterMinor: $balanceAfterMinor)';
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
      String category,
      int amountMinor,
      String currency,
      String occurredAt,
      String reference,
      String status,
      int? balanceAfterMinor});
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
    Object? category = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? occurredAt = null,
    Object? reference = null,
    Object? status = null,
    Object? balanceAfterMinor = freezed,
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
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
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
      reference: null == reference
          ? _self.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      balanceAfterMinor: freezed == balanceAfterMinor
          ? _self.balanceAfterMinor
          : balanceAfterMinor // ignore: cast_nullable_to_non_nullable
              as int?,
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
    TResult Function(
            String id,
            String accountId,
            String title,
            String category,
            int amountMinor,
            String currency,
            String occurredAt,
            String reference,
            String status,
            int? balanceAfterMinor)?
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
            _that.category,
            _that.amountMinor,
            _that.currency,
            _that.occurredAt,
            _that.reference,
            _that.status,
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
            String accountId,
            String title,
            String category,
            int amountMinor,
            String currency,
            String occurredAt,
            String reference,
            String status,
            int? balanceAfterMinor)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto():
        return $default(
            _that.id,
            _that.accountId,
            _that.title,
            _that.category,
            _that.amountMinor,
            _that.currency,
            _that.occurredAt,
            _that.reference,
            _that.status,
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
            String accountId,
            String title,
            String category,
            int amountMinor,
            String currency,
            String occurredAt,
            String reference,
            String status,
            int? balanceAfterMinor)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
        return $default(
            _that.id,
            _that.accountId,
            _that.title,
            _that.category,
            _that.amountMinor,
            _that.currency,
            _that.occurredAt,
            _that.reference,
            _that.status,
            _that.balanceAfterMinor);
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
      required this.category,
      required this.amountMinor,
      required this.currency,
      required this.occurredAt,
      required this.reference,
      this.status = 'completed',
      this.balanceAfterMinor})
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
  final String category;
  @override
  final int amountMinor;
  @override
  final String currency;
  @override
  final String occurredAt;
  @override
  final String reference;
  @override
  @JsonKey()
  final String status;
  @override
  final int? balanceAfterMinor;

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
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.balanceAfterMinor, balanceAfterMinor) ||
                other.balanceAfterMinor == balanceAfterMinor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accountId, title, category,
      amountMinor, currency, occurredAt, reference, status, balanceAfterMinor);

  @override
  String toString() {
    return 'TransactionDto(id: $id, accountId: $accountId, title: $title, category: $category, amountMinor: $amountMinor, currency: $currency, occurredAt: $occurredAt, reference: $reference, status: $status, balanceAfterMinor: $balanceAfterMinor)';
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
      String category,
      int amountMinor,
      String currency,
      String occurredAt,
      String reference,
      String status,
      int? balanceAfterMinor});
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
    Object? category = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? occurredAt = null,
    Object? reference = null,
    Object? status = null,
    Object? balanceAfterMinor = freezed,
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
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
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
      reference: null == reference
          ? _self.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      balanceAfterMinor: freezed == balanceAfterMinor
          ? _self.balanceAfterMinor
          : balanceAfterMinor // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$DisputeReceiptDto {
  String get disputeId;
  String get transactionId;

  /// Create a copy of DisputeReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DisputeReceiptDtoCopyWith<DisputeReceiptDto> get copyWith =>
      _$DisputeReceiptDtoCopyWithImpl<DisputeReceiptDto>(
          this as DisputeReceiptDto, _$identity);

  /// Serializes this DisputeReceiptDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DisputeReceiptDto &&
            (identical(other.disputeId, disputeId) ||
                other.disputeId == disputeId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disputeId, transactionId);

  @override
  String toString() {
    return 'DisputeReceiptDto(disputeId: $disputeId, transactionId: $transactionId)';
  }
}

/// @nodoc
abstract mixin class $DisputeReceiptDtoCopyWith<$Res> {
  factory $DisputeReceiptDtoCopyWith(
          DisputeReceiptDto value, $Res Function(DisputeReceiptDto) _then) =
      _$DisputeReceiptDtoCopyWithImpl;
  @useResult
  $Res call({String disputeId, String transactionId});
}

/// @nodoc
class _$DisputeReceiptDtoCopyWithImpl<$Res>
    implements $DisputeReceiptDtoCopyWith<$Res> {
  _$DisputeReceiptDtoCopyWithImpl(this._self, this._then);

  final DisputeReceiptDto _self;
  final $Res Function(DisputeReceiptDto) _then;

  /// Create a copy of DisputeReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disputeId = null,
    Object? transactionId = null,
  }) {
    return _then(_self.copyWith(
      disputeId: null == disputeId
          ? _self.disputeId
          : disputeId // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _self.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [DisputeReceiptDto].
extension DisputeReceiptDtoPatterns on DisputeReceiptDto {
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
    TResult Function(_DisputeReceiptDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DisputeReceiptDto() when $default != null:
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
    TResult Function(_DisputeReceiptDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DisputeReceiptDto():
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
    TResult? Function(_DisputeReceiptDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DisputeReceiptDto() when $default != null:
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
    TResult Function(String disputeId, String transactionId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DisputeReceiptDto() when $default != null:
        return $default(_that.disputeId, _that.transactionId);
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
    TResult Function(String disputeId, String transactionId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DisputeReceiptDto():
        return $default(_that.disputeId, _that.transactionId);
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
    TResult? Function(String disputeId, String transactionId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DisputeReceiptDto() when $default != null:
        return $default(_that.disputeId, _that.transactionId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DisputeReceiptDto extends DisputeReceiptDto {
  const _DisputeReceiptDto(
      {required this.disputeId, required this.transactionId})
      : super._();
  factory _DisputeReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$DisputeReceiptDtoFromJson(json);

  @override
  final String disputeId;
  @override
  final String transactionId;

  /// Create a copy of DisputeReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DisputeReceiptDtoCopyWith<_DisputeReceiptDto> get copyWith =>
      __$DisputeReceiptDtoCopyWithImpl<_DisputeReceiptDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DisputeReceiptDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DisputeReceiptDto &&
            (identical(other.disputeId, disputeId) ||
                other.disputeId == disputeId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disputeId, transactionId);

  @override
  String toString() {
    return 'DisputeReceiptDto(disputeId: $disputeId, transactionId: $transactionId)';
  }
}

/// @nodoc
abstract mixin class _$DisputeReceiptDtoCopyWith<$Res>
    implements $DisputeReceiptDtoCopyWith<$Res> {
  factory _$DisputeReceiptDtoCopyWith(
          _DisputeReceiptDto value, $Res Function(_DisputeReceiptDto) _then) =
      __$DisputeReceiptDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String disputeId, String transactionId});
}

/// @nodoc
class __$DisputeReceiptDtoCopyWithImpl<$Res>
    implements _$DisputeReceiptDtoCopyWith<$Res> {
  __$DisputeReceiptDtoCopyWithImpl(this._self, this._then);

  final _DisputeReceiptDto _self;
  final $Res Function(_DisputeReceiptDto) _then;

  /// Create a copy of DisputeReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? disputeId = null,
    Object? transactionId = null,
  }) {
    return _then(_DisputeReceiptDto(
      disputeId: null == disputeId
          ? _self.disputeId
          : disputeId // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _self.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
