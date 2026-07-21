import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';
import 'package:vaulta/features/cards/presentation/widgets/card_visual.dart';

/// Swipeable card deck. Tapping a card flips it; the page indicator and
/// the action row below track [onPageChanged]. The parent owns the
/// selected index so the actions always target the visible card.
class CardCarousel extends StatefulWidget {
  const CardCarousel({
    required this.cards,
    required this.selectedIndex,
    required this.onPageChanged,
    super.key,
  });

  final List<BankCard> cards;
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  final _controller = PageController(viewportFraction: 0.88);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      children: [
        // Height derives from the card ratio at the carousel's page width,
        // so the deck never letterboxes on narrow screens.
        LayoutBuilder(
          builder: (context, constraints) {
            final pageWidth = constraints.maxWidth * 0.88 - spacing.sm * 2;
            final height = pageWidth / CardVisual.aspectRatio;
            return SizedBox(
              height: height,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: widget.onPageChanged,
                itemCount: widget.cards.length,
                itemBuilder: (context, index) {
                  final card = widget.cards[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                    child: Hero(
                      tag: CardVisual.heroTag(card.id),
                      child: Material(
                        type: MaterialType.transparency,
                        child: CardFlip(card: card),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: spacing.md),
        _PageDots(
          count: widget.cards.length,
          selected: widget.selectedIndex,
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.selected});

  final int count;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == selected ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == selected ? colors.accent : colors.border,
              borderRadius: context.radii.brFull,
            ),
          ),
      ],
    );
  }
}
