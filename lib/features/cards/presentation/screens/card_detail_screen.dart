import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/presentation/failure_copy.dart';
import 'package:vaulta/features/cards/presentation/providers/cards_providers.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_detail_view.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visual.dart';

/// One card's management surface. Resolves the card from the loaded list
/// (`cardById`); a deep link works because [CardsController] loads on
/// first watch — there is no separate detail fetch to duplicate.
class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({required this.cardId, super.key});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cardsControllerProvider);
    final card = ref.watch(cardByIdProvider(cardId));

    return Scaffold(
      appBar: AppBar(title: Text(card?.label ?? 'Card')),
      body: SafeArea(
        child: switch (state) {
          AsyncData() =>
            card == null ? const _NotFound() : CardDetailView(card: card),
          AsyncError(:final error) => _DetailError(
              message: cardsFailureCopy(error),
              onRetry: () =>
                  ref.read(cardsControllerProvider.notifier).refresh(),
            ),
          _ => const _DetailSkeleton(),
        },
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.creditCard,
            size: 32,
            color: context.colors.textTertiary,
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            'This card isn\u2019t available',
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
              LucideIcons.cloudOff,
              size: 32,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: spacing.sm),
            Text(
              message,
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            AppButton(
              label: 'Try again',
              variant: AppButtonVariant.secondary,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing.md),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: CardVisual.aspectRatio,
                  child: SkeletonBox(
                    height: double.infinity,
                    radius: context.radii.brLg,
                  ),
                ),
                SizedBox(height: spacing.md),
                const SkeletonBox(height: 72),
                SizedBox(height: spacing.md),
                const SkeletonBox(height: 96),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
