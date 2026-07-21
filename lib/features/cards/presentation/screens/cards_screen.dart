import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/presentation/cards_paths.dart';
import 'package:vaulta/features/cards/presentation/failure_copy.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_carousel.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visuals.dart';
import 'package:vaulta/features/cards/presentation/widgets/cards_skeleton.dart';
import 'package:vaulta/features/cards/presentation/widgets/limits_sheet.dart';

/// The cards deck: swipe between cards, tap to flip, act on the visible
/// one. Freeze is optimistic — the card frosts the instant the button is
/// tapped and reconciles (or rolls back with a snackbar) behind it.
class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  var _selectedIndex = 0;

  Future<void> _refresh() async {
    final failure = await ref.read(cardsControllerProvider.notifier).refresh();
    if (failure == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(cardsFailureCopy(failure))));
  }

  Future<void> _toggleFrozen(BankCard card) async {
    final failure =
        await ref.read(cardsControllerProvider.notifier).toggleFrozen(card.id);
    if (failure == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(cardsFailureCopy(failure))));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
      body: SafeArea(
        child: switch (state) {
          AsyncData(:final value) => value.isEmpty
              ? const _EmptyCards()
              : _Deck(
                  cards: value,
                  selectedIndex: _selectedIndex.clamp(0, value.length - 1),
                  onPageChanged: (index) =>
                      setState(() => _selectedIndex = index),
                  onRefresh: _refresh,
                  onToggleFrozen: _toggleFrozen,
                ),
          AsyncError(:final error) => _LoadFailed(error: error),
          _ => const CardsSkeleton(),
        },
      ),
    );
  }
}

class _Deck extends StatelessWidget {
  const _Deck({
    required this.cards,
    required this.selectedIndex,
    required this.onPageChanged,
    required this.onRefresh,
    required this.onToggleFrozen,
  });

  final List<BankCard> cards;
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function() onRefresh;
  final ValueChanged<BankCard> onToggleFrozen;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final card = cards[selectedIndex];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardCarousel(
                    cards: cards,
                    selectedIndex: selectedIndex,
                    onPageChanged: onPageChanged,
                  ),
                  SizedBox(height: spacing.lg),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    child: _SelectedCardPanel(
                      card: card,
                      onToggleFrozen: () => onToggleFrozen(card),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedCardPanel extends StatelessWidget {
  const _SelectedCardPanel({
    required this.card,
    required this.onToggleFrozen,
  });

  final BankCard card;
  final VoidCallback onToggleFrozen;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                card.label,
                style: context.textStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: spacing.sm),
            StatusBadge(
              label: card.status.label,
              kind: card.status.badgeKind,
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: card.isFrozen ? 'Unfreeze' : 'Freeze',
                variant: AppButtonVariant.secondary,
                icon: card.isFrozen ? LucideIcons.sun : LucideIcons.snowflake,
                onPressed: onToggleFrozen,
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: AppButton(
                label: 'Limits',
                variant: AppButtonVariant.secondary,
                icon: LucideIcons.slidersHorizontal,
                onPressed: () => showLimitsSheet(context, card),
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: AppButton(
                label: 'Details',
                icon: LucideIcons.arrowRight,
                onPressed: () => context.go(CardsPaths.detail(card.id)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyCards extends StatelessWidget {
  const _EmptyCards();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.creditCard,
              size: 32,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'No cards yet',
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadFailed extends ConsumerWidget {
  const _LoadFailed({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.cloudOff,
              size: 32,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: spacing.sm),
            Text(
              cardsFailureCopy(error),
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Try again',
              variant: AppButtonVariant.secondary,
              onPressed: () =>
                  ref.read(cardsControllerProvider.notifier).refresh(),
            ),
          ],
        ),
      ),
    );
  }
}
