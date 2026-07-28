/// Route paths owned by the savings feature (same rationale as
/// `AccountsPaths`/`TransfersPaths`: feature widgets navigate without
/// importing the app layer, which would be an import cycle).
abstract final class SavingsPaths {
  /// The pots list.
  static const root = '/savings';

  /// A single pot's detail, `'/savings/<id>'`.
  static String detail(String potId) => '$root/$potId';
}
