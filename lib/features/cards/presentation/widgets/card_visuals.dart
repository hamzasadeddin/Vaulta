import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';

/// Presentation-only mapping from card enums to copy (the
/// `TransactionCategoryVisuals` pattern). English-only until Phase 10.
extension CardTypeVisuals on CardType {
  String get label => switch (this) {
        CardType.physical => 'Physical',
        CardType.virtual => 'Virtual',
      };
}

extension CardNetworkVisuals on CardNetwork {
  String get label => switch (this) {
        CardNetwork.visa => 'Visa',
        CardNetwork.mastercard => 'Mastercard',
        CardNetwork.unknown => 'Card',
      };

  /// The stylized mark on the card face.
  String get wordmark => switch (this) {
        CardNetwork.visa => 'VISA',
        CardNetwork.mastercard => 'mastercard',
        CardNetwork.unknown => '',
      };
}

extension CardStatusVisuals on CardStatus {
  String get label => switch (this) {
        CardStatus.active => 'Active',
        CardStatus.frozen => 'Frozen',
      };

  StatusKind get badgeKind => switch (this) {
        CardStatus.active => StatusKind.success,
        // Frost blue, not red — frozen is a chosen state, not a failure.
        CardStatus.frozen => StatusKind.info,
      };
}
