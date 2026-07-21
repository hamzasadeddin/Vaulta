/// Route paths owned by the cards feature (the `AccountsPaths` rationale:
/// feature widgets navigate without importing the app layer, which would
/// be an import cycle).
abstract final class CardsPaths {
  static const root = '/cards';

  static String detail(String cardId) => '/cards/$cardId';
}
