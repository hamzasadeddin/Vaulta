/// Route paths owned by the transfers feature (same rationale as
/// `AccountsPaths`: feature widgets navigate without importing the app
/// layer, which would be an import cycle).
abstract final class TransfersPaths {
  /// The send-money flow.
  ///
  /// Declared as a sub-route of the home branch, so this resolves inside
  /// `StatefulShellRoute` rather than above it. A top-level route was the
  /// first shape tried and it duplicated the navigation shell's
  /// `GlobalKey` on web: pushing one rewrites the URL to a location whose
  /// match list no longer contains the shell, so the shell page is torn
  /// down and rebuilt on the way back. Nesting keeps the shell in the
  /// match list — the same reason every detail route here nests.
  ///
  /// Trade-off: the nav chrome stays visible during the flow. Worth it
  /// for a shell that survives the round trip.
  static const flow = '/transfer';
}
