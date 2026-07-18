import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/domain/usecases/accounts_usecases.dart';
import 'package:vaulta/features/accounts/presentation/pdf/statement_pdf_builder.dart';

/// Orchestrates one statement export: fetch lines → render PDF → hand to
/// the platform share/print sheet (a browser download on web).
///
/// Returns a [Failure] instead of throwing, matching the boundary rule.
/// The `share` callback is injectable so tests don't open a real share
/// sheet.
class StatementExporter {
  StatementExporter({
    required AccountsRepository repository,
    StatementPdfBuilder builder = const StatementPdfBuilder(),
    Future<void> Function(Uint8List bytes, String filename)? share,
  })  : _repository = repository,
        _builder = builder,
        _share = share ?? _sharePdf;

  final AccountsRepository _repository;
  final StatementPdfBuilder _builder;
  final Future<void> Function(Uint8List bytes, String filename) _share;

  static Future<void> _sharePdf(Uint8List bytes, String filename) =>
      Printing.sharePdf(bytes: bytes, filename: filename);

  Future<Failure?> export({
    required Account account,
    required Statement statement,
  }) async {
    final result = await GetStatement(_repository).call(
      GetStatementParams(accountId: account.id, statementId: statement.id),
    );
    switch (result) {
      case Failed(:final failure):
        return failure;
      case Success(:final value):
        try {
          final bytes = await _builder.build(account: account, detail: value);
          await _share(bytes, _filename(account, value.statement));
          return null;
        } on Object catch (error, stackTrace) {
          return UnexpectedFailure(
            message: 'Could not generate the statement PDF',
            cause: error,
            stackTrace: stackTrace,
          );
        }
    }
  }

  String _filename(Account account, Statement statement) {
    final slug = account.name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final month = DateFormat('yyyy-MM').format(statement.periodStart);
    return 'vaulta-statement-$slug-$month.pdf';
  }
}
