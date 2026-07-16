import 'package:meta/meta.dart';

/// A pending second-factor challenge issued after password login.
@immutable
class OtpChallenge {
  const OtpChallenge({
    required this.id,
    required this.maskedDestination,
    required this.expiresIn,
  });

  final String id;

  /// Where the code was sent, masked for display (`d***@vaulta.app`).
  final String maskedDestination;

  final Duration expiresIn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtpChallenge &&
          other.id == id &&
          other.maskedDestination == maskedDestination &&
          other.expiresIn == expiresIn;

  @override
  int get hashCode => Object.hash(id, maskedDestination, expiresIn);
}
