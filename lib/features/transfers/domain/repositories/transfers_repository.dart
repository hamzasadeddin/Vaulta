import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

/// Domain contract for the transfers feature.
///
/// Remote-only, like cards and transactions: money movement is server
/// truth by definition, and a cached quote is a stale price. There is no
/// honest cache-first story here, so there is no Drift cache.
///
/// The two-step create → confirm shape is deliberate. [createTransfer]
/// prices the transfer and reserves nothing; [confirmTransfer] is the
/// only call that moves money, and it is **pessimistic** — callers wait
/// for the server rather than showing a transfer as done before it is.
abstract interface class TransfersRepository {
  Future<Result<List<Beneficiary>, Failure>> getBeneficiaries();

  /// Prices [request] and returns a reviewable draft. Safe to call
  /// repeatedly — each call is a fresh quote, and no draft moves money.
  Future<Result<TransferQuote, Failure>> createTransfer(
    TransferRequest request,
  );

  /// Executes a previously created draft.
  ///
  /// [idempotencyKey] comes from the quote and is sent as the
  /// `Idempotency-Key` header. Repeating this call with the same key
  /// returns the *same* transfer instead of creating a second one — the
  /// guarantee that makes a retried confirm safe.
  Future<Result<Transfer, Failure>> confirmTransfer({
    required String transferId,
    required String idempotencyKey,
  });
}
