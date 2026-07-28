import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/savings/data/datasources/pots_remote_data_source.dart';
import 'package:vaulta/features/savings/data/models/pot_dtos.dart';
import 'package:vaulta/features/savings/data/repositories/pots_repository_impl.dart';

class _MockRemote extends Mock implements PotsRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late PotsRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = PotsRepositoryImpl(remote: remote);
  });

  group('getPots', () {
    test('maps minor units and currency into domain Money', () async {
      when(remote.pots).thenAnswer(
        (_) async => const PotsDto(
          pots: [
            PotDto(
              id: 'pot_rainy',
              accountId: 'acc_chk',
              name: 'Rainy Day',
              balanceMinor: 45000,
              currency: 'USD',
              goalMinor: 200000,
              roundUpsEnabled: true,
            ),
          ],
        ),
      );

      final result = await repository.getPots();
      final pots = result.valueOrNull!;
      expect(pots, hasLength(1));
      expect(pots.single.balance, Money.parse('450.00', Currency.usd));
      expect(pots.single.goal, Money.parse('2000.00', Currency.usd));
      expect(pots.single.roundUpsEnabled, isTrue);
    });

    test('drops a pot in an unsupported currency rather than coercing it',
        () async {
      when(remote.pots).thenAnswer(
        (_) async => const PotsDto(
          pots: [
            PotDto(
              id: 'ok',
              accountId: 'acc_chk',
              name: 'Fine',
              balanceMinor: 100,
              currency: 'USD',
            ),
            PotDto(
              id: 'bad',
              accountId: 'acc_chk',
              name: 'Unknown',
              balanceMinor: 100,
              currency: 'XXX',
            ),
          ],
        ),
      );

      final result = await repository.getPots();
      expect(result.valueOrNull!.map((pot) => pot.id), ['ok']);
    });
  });

  group('createPot', () {
    test('returns the created pot on success', () async {
      when(
        () => remote.create(
          accountId: any(named: 'accountId'),
          name: any(named: 'name'),
          goalMinor: any(named: 'goalMinor'),
        ),
      ).thenAnswer(
        (_) async => const PotDto(
          id: 'pot_new',
          accountId: 'acc_chk',
          name: 'Japan Trip',
          balanceMinor: 0,
          currency: 'USD',
          goalMinor: 500000,
        ),
      );

      final result = await repository.createPot(
        accountId: 'acc_chk',
        name: 'Japan Trip',
        goal: Money.parse('5000.00', Currency.usd),
      );
      expect(result.valueOrNull?.name, 'Japan Trip');
      expect(result.valueOrNull?.goal, Money.parse('5000.00', Currency.usd));
    });

    test('surfaces an unrepresentable created pot as a failure', () async {
      when(
        () => remote.create(
          accountId: any(named: 'accountId'),
          name: any(named: 'name'),
          goalMinor: any(named: 'goalMinor'),
        ),
      ).thenAnswer(
        (_) async => const PotDto(
          id: 'pot_new',
          accountId: 'acc_chk',
          name: 'Broken',
          balanceMinor: 0,
          currency: 'XXX',
        ),
      );

      final result = await repository.createPot(
        accountId: 'acc_chk',
        name: 'Broken',
      );
      expect(result.failureOrNull, isA<UnexpectedFailure>());
    });
  });
}
