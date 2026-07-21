import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visuals.dart';

enum CardSide { front, back }

/// The rendered card at the standard ID-1 aspect ratio. Physical cards get
/// the accent gradient; virtual cards a quieter raised surface with an
/// accent edge. A frozen card frosts over rather than changing shape, so
/// the freeze toggle reads instantly without any relayout.
class CardVisual extends StatelessWidget {
  const CardVisual({
    required this.card,
    this.side = CardSide.front,
    super.key,
  });

  final BankCard card;
  final CardSide side;

  /// ID-1 card ratio (85.6 × 53.98 mm).
  static const aspectRatio = 1.586;

  /// One tag per card. Used only by the carousel tile and the pushed
  /// detail route — cards have no expanded-layout pane, so the tag can
  /// never render twice in one tree (the accounts dual-render rule).
  static String heroTag(String cardId) => 'card-visual-$cardId';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final physical = card.type == CardType.physical;

    // Semantic colors only — the gradient is a blend of theme roles, never
    // an inlined hex (spec §5).
    final decoration = physical
        ? BoxDecoration(
            borderRadius: context.radii.brLg,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.accent,
                Color.lerp(colors.accent, colors.canvas, 0.55)!,
              ],
            ),
          )
        : BoxDecoration(
            borderRadius: context.radii.brLg,
            color: colors.surfaceRaised,
            border: Border.all(color: colors.accent),
          );
    final onCard = physical ? colors.onAccent : colors.textPrimary;
    final onCardMuted = onCard.withValues(alpha: 0.7);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: decoration,
            child: Padding(
              padding: EdgeInsets.all(context.spacing.md),
              child: side == CardSide.front
                  ? _Front(card: card, onCard: onCard, onCardMuted: onCardMuted)
                  : _Back(card: card, onCard: onCard, onCardMuted: onCardMuted),
            ),
          ),
          if (card.isFrozen) const _FrostOverlay(),
        ],
      ),
    );
  }
}

class _Front extends StatelessWidget {
  const _Front({
    required this.card,
    required this.onCard,
    required this.onCardMuted,
  });

  final BankCard card;
  final Color onCard;
  final Color onCardMuted;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                card.label,
                style: context.textStyles.labelMedium?.copyWith(
                  color: onCardMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _NetworkMark(network: card.network, color: onCard),
          ],
        ),
        const Spacer(),
        _Chip(color: onCardMuted),
        SizedBox(height: spacing.sm),
        Text(
          '\u2022\u2022\u2022\u2022  \u2022\u2022\u2022\u2022  '
          '\u2022\u2022\u2022\u2022  ${card.panLast4}',
          style: context.typography.moneyMd.copyWith(color: onCard),
          maxLines: 1,
        ),
        SizedBox(height: spacing.xs),
        Row(
          children: [
            Text(
              card.type.label.toUpperCase(),
              style: context.textStyles.labelSmall?.copyWith(
                color: onCardMuted,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Text(
              card.expiryLabel,
              style: context.typography.moneySm.copyWith(color: onCardMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({
    required this.card,
    required this.onCard,
    required this.onCardMuted,
  });

  final BankCard card;
  final Color onCard;
  final Color onCardMuted;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Magstripe.
        Container(
          height: 32,
          margin: EdgeInsets.only(top: spacing.xs),
          decoration: BoxDecoration(
            color: context.colors.canvas.withValues(alpha: 0.65),
            borderRadius: context.radii.brSm,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              'CVV',
              style: context.textStyles.labelSmall?.copyWith(
                color: onCardMuted,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(width: spacing.sm),
            Text(
              '\u2022\u2022\u2022',
              style: context.typography.moneyMd.copyWith(color: onCard),
            ),
            const Spacer(),
            Text(
              'Reveal in details',
              style: context.textStyles.labelSmall?.copyWith(
                color: onCardMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// EMV chip stand-in: a small rounded plate, drawn — no asset, no icon
/// font stretch.
class _Chip extends StatelessWidget {
  const _Chip({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _NetworkMark extends StatelessWidget {
  const _NetworkMark({required this.network, required this.color});

  final CardNetwork network;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      network.wordmark,
      style: context.textStyles.titleSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w800,
        fontStyle:
            network == CardNetwork.visa ? FontStyle.italic : FontStyle.normal,
        letterSpacing: network == CardNetwork.visa ? 1.5 : 0,
      ),
    );
  }
}

/// Frost sheet over a frozen card: overlay tint + snowflake, no relayout.
class _FrostOverlay extends StatelessWidget {
  const _FrostOverlay();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.overlay,
        borderRadius: context.radii.brLg,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.snowflake, size: 28, color: colors.info),
            SizedBox(height: context.spacing.xs),
            Text(
              'Frozen',
              style: context.textStyles.labelMedium?.copyWith(
                color: colors.info,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3D Y-axis flip between a card's front and back, driven by tap. The
/// animation is a single finite controller run (240ms), so
/// `pumpAndSettle` terminates (§8 animation rule).
class CardFlip extends StatefulWidget {
  const CardFlip({required this.card, super.key});

  final BankCard card;

  @override
  State<CardFlip> createState() => _CardFlipState();
}

class _CardFlipState extends State<CardFlip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_controller.isAnimating) return;
    if (_controller.value < 0.5) {
      unawaited(_controller.forward());
    } else {
      unawaited(_controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.card.label} card, tap to flip',
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final angle = _controller.value * math.pi;
            final showBack = _controller.value >= 0.5;
            return Transform(
              alignment: Alignment.center,
              // entry(3, 1) adds perspective so the rotation reads as
              // depth instead of a horizontal squash.
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(angle),
              child: showBack
                  // The back is built mirrored, so pre-flip it to read
                  // correctly at rotation > 90°.
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: CardVisual(
                        card: widget.card,
                        side: CardSide.back,
                      ),
                    )
                  : CardVisual(card: widget.card),
            );
          },
        ),
      ),
    );
  }
}
