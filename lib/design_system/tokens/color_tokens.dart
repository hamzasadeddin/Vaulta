import 'dart:ui';

/// Raw palette. Nothing outside `design_system/theme` should import this —
/// widgets consume semantic roles via `AppColors`, never raw hex.
abstract final class ColorTokens {
  // Navy scale (dark-first, spec §5).
  static const navy950 = Color(0xFF0B0E14);
  static const navy900 = Color(0xFF11151E);
  static const navy850 = Color(0xFF151A23);
  static const navy800 = Color(0xFF1B2230);
  static const navy700 = Color(0xFF232B3B);

  // Accent — electric violet. The one confident accent; mint is semantic.
  static const violet500 = Color(0xFF6C5CE7);
  static const violet400 = Color(0xFF8A7DF0);
  static const violet900 = Color(0xFF2A2653);

  // Semantic hues.
  static const mint500 = Color(0xFF00D4AA); // credit / success
  static const red500 = Color(0xFFFF5C7A); // debit / danger
  static const amber500 = Color(0xFFFFB020); // pending / warning
  static const blue500 = Color(0xFF4DA3FF); // info

  // Ink (dark surfaces).
  static const ink100 = Color(0xFFF2F5FA);
  static const ink300 = Color(0xFFA9B4C8);
  static const ink500 = Color(0xFF6C7689);

  // Light-mode counterparts.
  static const paper50 = Color(0xFFF6F7FB);
  static const paper0 = Color(0xFFFFFFFF);
  static const paperBorder = Color(0xFFE3E7F0);
  static const inkDark900 = Color(0xFF10141C);
  static const inkDark600 = Color(0xFF4A5468);
  static const inkDark400 = Color(0xFF8892A6);
}
