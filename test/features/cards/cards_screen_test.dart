import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/core/security/biometric_service.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/domain/repositories/cards_repository.dart';
import 'package:vaulta/features/cards/presentation/cards_paths.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';
import 'package:vaulta/features/cards/presentation/screens/card_detail_screen.dart';
import 'package:vaulta/features/cards/presentation/screens/cards_screen.dart';

class _MockCardsRepository extends Mock implements CardsRepository {}

class _MockAccountsRepository extends Mock implements AccountsRepository {}

class _FakeBiometrics implements BiometricService {
  _FakeBiometrics({required this.granted});

  final bool granted;

  @override
  Future<bool> authenticate({required String reason}) async => granted;
}

final _accounts = [
  Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  ),
];

CardLimits _limits() => CardLimits(
      daily: Money.parse('500.00', Currency.usd),
      monthly: Money.parse('12000.00', Currency.usd),
      spentToday: Money.parse('120.00', Currency.usd),
      spentThisMonth: Money.parse('3400.00', Currency.usd),
    );

BankCard _card({CardStatus status = CardStatus.active}) => BankCard(
      id: 'crd_1',
      accountId: 'acc_chk',
      label: 'Everyday',
      type: CardType.physical,
      network: CardNetwork.visa,
      status: status,
      panLast4: '4242',
      expiryMonth: 9,
      expiryYear: 2028,
      limits: _limits(),
    );

const _pan = CardPan(
  pan: '4242424242424242',
  cvv: '123',
  expiryMonth: 9,
  expiryYear: 2028,
);

void main() {
  late _MockCardsRepository repository;
  late _MockAccountsRepository accountsRepository;

  setUpAll(() {
    registerFallbackValue(Money.zero(Currency.usd));
  });

  setUp(() {
    repository = _MockCardsRepository();
    accountsRepository = _MockAccountsRepository();
    when(accountsRepository.watchAccounts)
        .thenAnswer((_) => Stream.value(Result.success(_accounts)));
    when(accountsRepository.refreshAccounts)
        .thenAnswer((_) async => Result.success(_accounts));
    when(repository.getCards)
        .thenAnswer((_) async => Result.success([_card()]));
  });

  Widget harness({BiometricService? biometrics}) {
    final router = GoRouter(
      initialLocation: CardsPaths.root,
      routes: [
        GoRoute(
          path: CardsPaths.root,
          builder: (context, state) => const CardsScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => CardDetailScreen(
                cardId: state.pathParameters['id'] ?? '',
              ),
            ),
          ],
        ),
      ],
    );
    return ProviderScope(
      overrides: [
        cardsRepositoryProvider.overrideWithValue(repository),
        accountsRepositoryProvider.overrideWithValue(accountsRepository),
        if (biometrics != null)
          biometricServiceProvider.overrideWithValue(biometrics),
      ],
      child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
    );
  }

  testWidgets('shows a skeleton, then the card deck', (tester) async {
    await tester.pumpWidget(harness());
    expect(find.byType(SkeletonBox), findsWidgets);

    await tester.pumpAndSettle();

    expect(find.byType(SkeletonBox), findsNothing);
    expect(find.text('Everyday'), findsWidgets);
    expect(find.text('Freeze'), findsOneWidget);
  });

  testWidgets('the freeze button flips its label and calls the repository',
      (tester) async {
    when(
      () => repository.setCardFrozen(
        cardId: any(named: 'cardId'),
        frozen: any(named: 'frozen'),
      ),
    ).thenAnswer((_) async => Result.success(_card(status: CardStatus.frozen)));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Freeze'));
    await tester.pumpAndSettle();

    expect(find.text('Unfreeze'), findsOneWidget);
    verify(() => repository.setCardFrozen(cardId: 'crd_1', frozen: true))
        .called(1);
  });

  testWidgets('a load failure shows retry, which reloads', (tester) async {
    when(repository.getCards)
        .thenAnswer((_) async => const Result.failure(NetworkFailure()));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(
      find.text('Can\u2019t reach Vaulta. Check your connection.'),
      findsOneWidget,
    );

    when(repository.getCards)
        .thenAnswer((_) async => Result.success([_card()]));
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Freeze'), findsOneWidget);
  });

  testWidgets(
      'detail masks the PAN, reveals it on biometric grant, then '
      'auto-hides', (tester) async {
    when(() => repository.revealPan('crd_1'))
        .thenAnswer((_) async => const Result.success(_pan));

    await tester
        .pumpWidget(harness(biometrics: _FakeBiometrics(granted: true)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();

    // Masked by default — the grouped PAN is absent until revealed.
    expect(find.text('4242 4242 4242 4242'), findsNothing);
    expect(find.text('Reveal'), findsOneWidget);

    await tester.tap(find.text('Reveal'));
    await tester.pumpAndSettle();

    expect(find.text('4242 4242 4242 4242'), findsOneWidget);

    // Pump past the 30s auto-hide timer (else the pending timer fails the
    // test).
    await tester.pump(RevealedPan.autoHideAfter + const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('4242 4242 4242 4242'), findsNothing);
  });

  testWidgets('a declined biometric prompt leaves the PAN masked',
      (tester) async {
    await tester
        .pumpWidget(harness(biometrics: _FakeBiometrics(granted: false)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reveal'));
    await tester.pumpAndSettle();

    expect(find.text('4242 4242 4242 4242'), findsNothing);
    verifyNever(() => repository.revealPan(any()));
  });

  testWidgets('the limits sheet opens and saves', (tester) async {
    when(
      () => repository.updateCardLimits(
        cardId: any(named: 'cardId'),
        daily: any(named: 'daily'),
        monthly: any(named: 'monthly'),
      ),
    ).thenAnswer((_) async => Result.success(_card()));

    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Limits'));
    await tester.pumpAndSettle();

    expect(find.text('Spending limits'), findsOneWidget);

    await tester.tap(find.text('Save limits'));
    await tester.pumpAndSettle();

    verify(
      () => repository.updateCardLimits(
        cardId: 'crd_1',
        daily: any(named: 'daily'),
        monthly: any(named: 'monthly'),
      ),
    ).called(1);
  });
}
