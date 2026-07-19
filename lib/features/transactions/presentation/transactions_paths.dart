/// Route paths owned by the transactions feature (same rationale as
/// `AccountsPaths`: feature widgets navigate without importing the app
/// layer, which would be an import cycle).
abstract final class TransactionsPaths {
  static const root = '/transactions';

  static String detail(String transactionId) => '/transactions/$transactionId';

  /// The feed pre-filtered to one account — the "view transactions" entry
  /// point on an account's detail surface.
  static String forAccount(String accountId) =>
      Uri(path: root, queryParameters: {'account': accountId}).toString();
}
