import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transfers/data/datasources/transfers_remote_data_source.dart';
import 'package:vaulta/features/transfers/data/models/transfer_dtos.dart';
import 'package:vaulta/features/transfers/data/repositories/transfers_repository_impl.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

class _MockRemote extends Mock implements TransfersRemoteDataSource {}

TransferQuoteDto _quoteDto() => TransferQuoteDto.fromJson(const {
      'id': 'trf_1',
      'idempotencyKey': 'idem_trf_1',
      'sourceAccountId': 'acc_chk',
      'destinationLabel': 'Sara Malik',
      'destinationDetail': '\u2022\u2022\u2022\u2022 9903',
      'amountMinor': 25000,
      'currency': 'USD',
      'feeMinor': 0,
      'totalDebitMinor': 25000,
      'destinationAmountMinor': 25000,
      'destinationCurrency': 'USD',
    });

TransferDto _transferDto() => TransferDto.fromJson(const {
      'id': 'trf_1',
      'reference': 'VLT-2026-123456',
      'status': 'completed',
      'sourceAccountId': 'acc_chk',
      'destinationLabel': 'Sara Malik',
      'destinationDetail': '\u2022\u2022\u2022\u2022 9903',
      'amountMinor': 25000,
      'currency': 'USD',
      'feeMinor': 0,
      'totalDebitMinor': 25000,
      'destinationAmountMinor': 25000,
      'destinationCurrency': 'USD',
      'createdAt': '2026-07-22T10:00:00.000',
      'balanceAfterMinor': 1223050,
    });

void main() {
  late _MockRemote remote;
  late TransfersRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = TransfersRepositoryImpl(remote: remote);
  });

  group('createTransfer', () {
    test('sends an own-account destination as minor units', () async {
      when(
        () => remote.create(
          sourceAccountId: any(named: 'sourceAccountId'),
          destinationType: any(named: 'destinationType'),
          amountMinor: any(named: 'amountMinor'),
          destinationAccountId: any(named: 'destinationAccountId'),
          note: any(named: 'note'),
          scheduledFor: any(named: 'scheduledFor'),
        ),
      ).thenAnswer((_) async => _quoteDto());

      final result = await repository.createTransfer(
        TransferRequest(
          sourceAccountId: 'acc_chk',
          destination: const OwnAccountDestination('acc_sav'),
          amount: Money.parse('250.00', Currency.usd),
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(
        () => remote.create(
          sourceAccountId: 'acc_chk',
          destinationType: 'own',
          amountMinor: 25000,
          destinationAccountId: 'acc_sav',
        ),
      ).called(1);
    });

    test('sends a raw IBAN destination in compact form', () async {
      when(
        () => remote.create(
          sourceAccountId: any(named: 'sourceAccountId'),
          destinationType: any(named: 'destinationType'),
          amountMinor: any(named: 'amountMinor'),
          destinationIban: any(named: 'destinationIban'),
          destinationHolderName: any(named: 'destinationHolderName'),
          note: any(named: 'note'),
          scheduledFor: any(named: 'scheduledFor'),
        ),
      ).thenAnswer((_) async => _quoteDto());

      await repository.createTransfer(
        TransferRequest(
          sourceAccountId: 'acc_chk',
          destination: IbanDestination(
            iban: Iban.tryParse('jo71 hbho 0020 0000 0000 0012 0099 02')!,
            holderName: 'Omar Nasser',
          ),
          amount: Money.parse('250.00', Currency.usd),
          note: 'Rent',
        ),
      );

      verify(
        () => remote.create(
          sourceAccountId: 'acc_chk',
          destinationType: 'iban',
          amountMinor: 25000,
          destinationIban: 'JO71HBHO0020000000000012009902',
          destinationHolderName: 'Omar Nasser',
          note: 'Rent',
        ),
      ).called(1);
    });

    test('a JOD amount converts at three minor digits', () async {
      when(
        () => remote.create(
          sourceAccountId: any(named: 'sourceAccountId'),
          destinationType: any(named: 'destinationType'),
          amountMinor: any(named: 'amountMinor'),
          destinationBeneficiaryId: any(named: 'destinationBeneficiaryId'),
          note: any(named: 'note'),
          scheduledFor: any(named: 'scheduledFor'),
        ),
      ).thenAnswer((_) async => _quoteDto());

      await repository.createTransfer(
        TransferRequest(
          sourceAccountId: 'acc_jod',
          destination: const BeneficiaryDestination('ben_layla'),
          amount: Money.parse('177.250', Currency.jod),
        ),
      );

      verify(
        () => remote.create(
          sourceAccountId: 'acc_jod',
          destinationType: 'beneficiary',
          amountMinor: 177250,
          destinationBeneficiaryId: 'ben_layla',
        ),
      ).called(1);
    });

    test('a DioException becomes a Failure, never an exception', () async {
      when(
        () => remote.create(
          sourceAccountId: any(named: 'sourceAccountId'),
          destinationType: any(named: 'destinationType'),
          amountMinor: any(named: 'amountMinor'),
          destinationBeneficiaryId: any(named: 'destinationBeneficiaryId'),
          note: any(named: 'note'),
          scheduledFor: any(named: 'scheduledFor'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/transfers'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.createTransfer(
        TransferRequest(
          sourceAccountId: 'acc_chk',
          destination: const BeneficiaryDestination('ben_sara'),
          amount: Money.parse('250.00', Currency.usd),
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('confirmTransfer', () {
    test('forwards the quote-issued idempotency key verbatim', () async {
      when(
        () => remote.confirm(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => _transferDto());

      final result = await repository.confirmTransfer(
        transferId: 'trf_1',
        idempotencyKey: 'idem_trf_1',
      );

      expect(result.valueOrNull?.status, TransferStatus.completed);
      verify(
        () => remote.confirm(
          transferId: 'trf_1',
          idempotencyKey: 'idem_trf_1',
        ),
      ).called(1);
    });

    test('a 422 becomes a ValidationFailure carrying its field errors',
        () async {
      when(
        () => remote.confirm(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/transfers/trf_1/confirm'),
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/transfers/trf_1/confirm'),
            statusCode: 422,
            data: const {
              'message': 'Insufficient funds',
              'errors': {
                'amountMinor': ['Not enough available balance'],
              },
            },
          ),
        ),
      );

      final result = await repository.confirmTransfer(
        transferId: 'trf_1',
        idempotencyKey: 'idem_trf_1',
      );

      final failure = result.failureOrNull;
      expect(failure, isA<ValidationFailure>());
      expect(
        (failure! as ValidationFailure).fieldErrors,
        contains('amountMinor'),
      );
    });
  });

  group('getBeneficiaries', () {
    test('maps and filters the payee list', () async {
      when(remote.beneficiaries).thenAnswer(
        (_) async => BeneficiariesDto.fromJson(const {
          'beneficiaries': [
            {
              'id': 'ben_sara',
              'name': 'Sara Malik',
              'iban': 'JO85CABK0030000000000012009903',
              'bankName': 'Cairo Amman Bank',
              'currency': 'USD',
            },
            {
              'id': 'ben_broken',
              'name': 'Broken',
              'iban': 'not-an-iban',
              'bankName': 'Nowhere',
              'currency': 'USD',
            },
          ],
        }),
      );

      final result = await repository.getBeneficiaries();

      expect(result.valueOrNull, hasLength(1));
      expect(result.valueOrNull!.single.id, 'ben_sara');
    });
  });
}
