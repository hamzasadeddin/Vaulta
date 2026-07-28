import 'package:meta/meta.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';

/// A savings pot: a named bucket of money the user sets aside, funded and
/// drained through the *transfer rails* (a [Pot] is a destination, not a
/// second money-movement mechanism — see `PotDestination`).
///
/// A pot always shares its parent account's [currency]: a deposit into it
/// is same-currency and so carries no FX lock (handoff 8 §35). The pot
/// never prices or moves money itself; it only holds a balance and,
/// optionally, a [goal] to measure it against.
@immutable
class Pot {
  const Pot({
    required this.id,
    required this.accountId,
    required this.name,
    required this.balance,
    this.goal,
    this.roundUpsEnabled = false,
  });

  final String id;

  /// The funding account this pot belongs to. FK into the account list,
  /// never a parallel id (handoff 8 §7): a withdrawal returns here.
  final String accountId;

  final String name;

  /// Current balance, in the pot's [currency].
  final Money balance;

  /// Optional target. `null` means an open-ended pot with no finish line —
  /// the progress affordances simply don't render.
  final Money? goal;

  /// Whether spare-change round-ups sweep into this pot. At most one pot
  /// should have this on; enforcing that is the controller's job, not the
  /// entity's.
  final bool roundUpsEnabled;

  Currency get currency => balance.currency;

  bool get hasGoal => goal != null;

  /// The pot has reached (or passed) its target. Always `false` for an
  /// open-ended pot — there is nothing to reach.
  bool get goalReached {
    final target = goal;
    return target != null && balance >= target;
  }

  /// What is still needed to hit the goal, floored at zero. `null` when
  /// there is no goal. Exact `Money` arithmetic — never a `double`.
  Money? get remaining {
    final target = goal;
    if (target == null) return null;
    final gap = target - balance;
    return gap.isNegative ? Money.zero(currency) : gap;
  }

  /// Progress toward the goal in `[0, 1]`, or `null` when there is no goal
  /// (or a degenerate non-positive one).
  ///
  /// A **display ratio**, deliberately a `double`: it multiplies no money
  /// and settles no ledger, so the "money is always `Decimal`" rule does
  /// not apply. It is still computed from exact integer minor units so the
  /// same inputs always yield the same bar, then clamped so an
  /// over-funded pot reads as full rather than overflowing.
  double? get progress {
    final target = goal;
    if (target == null) return null;
    final goalMinor = target.minorUnits;
    if (goalMinor <= BigInt.zero) return null;
    final ratio = balance.minorUnits.toDouble() / goalMinor.toDouble();
    return ratio.clamp(0.0, 1.0);
  }

  Pot copyWith({
    String? name,
    Money? balance,
    Money? goal,
    bool clearGoal = false,
    bool? roundUpsEnabled,
  }) {
    return Pot(
      id: id,
      accountId: accountId,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      goal: clearGoal ? null : (goal ?? this.goal),
      roundUpsEnabled: roundUpsEnabled ?? this.roundUpsEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pot &&
          other.id == id &&
          other.accountId == accountId &&
          other.name == name &&
          other.balance == balance &&
          other.goal == goal &&
          other.roundUpsEnabled == roundUpsEnabled;

  @override
  int get hashCode =>
      Object.hash(id, accountId, name, balance, goal, roundUpsEnabled);
}
