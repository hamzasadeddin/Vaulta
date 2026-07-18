/// Route paths owned by the accounts feature. The app router composes
/// these into its table; keeping them here lets feature widgets navigate
/// without importing the app layer (which would be an import cycle, since
/// the router imports these screens).
abstract final class AccountsPaths {
  static const root = '/accounts';

  static String detail(String accountId) => '/accounts/$accountId';
}
