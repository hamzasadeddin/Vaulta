import 'package:meta/meta.dart';

enum KycStatus { pending, verified, rejected }

/// Authenticated account holder. Pure domain — no JSON, no framework.
@immutable
class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.kycStatus,
  });

  final String id;
  final String fullName;
  final String email;
  final KycStatus kycStatus;

  String get firstName => fullName.split(' ').first;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.fullName == fullName &&
          other.email == email &&
          other.kycStatus == kycStatus;

  @override
  int get hashCode => Object.hash(id, fullName, email, kycStatus);
}
