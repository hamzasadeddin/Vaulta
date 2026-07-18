import 'package:meta/meta.dart';
import 'package:vaulta/core/money/money.dart';

/// A monthly account statement (metadata only — lines arrive with
/// [StatementDetail] when the user exports).
@immutable
class Statement {
  const Statement({
    required this.id,
    required this.accountId,
    required this.periodStart,
    required this.periodEnd,
    required this.opening,
    required this.closing,
    required this.transactionCount,
  });

  final String id;
  final String accountId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Money opening;
  final Money closing;
  final int transactionCount;

  Money get netChange => closing - opening;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Statement &&
          other.id == id &&
          other.accountId == accountId &&
          other.periodStart == periodStart &&
          other.periodEnd == periodEnd &&
          other.opening == opening &&
          other.closing == closing &&
          other.transactionCount == transactionCount;

  @override
  int get hashCode => Object.hash(
        id,
        accountId,
        periodStart,
        periodEnd,
        opening,
        closing,
        transactionCount,
      );
}

/// One ledger entry on a statement. [amount] is signed: credits positive,
/// debits negative — same convention as the dashboard feed.
@immutable
class StatementLine {
  const StatementLine({
    required this.id,
    required this.title,
    required this.amount,
    required this.occurredAt,
  });

  final String id;
  final String title;
  final Money amount;
  final DateTime occurredAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatementLine &&
          other.id == id &&
          other.title == title &&
          other.amount == amount &&
          other.occurredAt == occurredAt;

  @override
  int get hashCode => Object.hash(id, title, amount, occurredAt);
}

/// A statement together with its lines — everything a PDF export needs.
@immutable
class StatementDetail {
  const StatementDetail({required this.statement, required this.lines});

  final Statement statement;

  /// Chronological, oldest first.
  final List<StatementLine> lines;
}
