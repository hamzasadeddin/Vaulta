import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vaulta/design_system/theme/theme_context.dart';

/// Shimmering placeholder block. Pure SDK animation — no shimmer package.
/// Falls back to a static tone when the platform requests reduced motion,
/// or when [animate] is false (golden tests).
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    this.width,
    this.height = 16,
    this.radius,
    this.animate = true,
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadius? radius;
  final bool animate;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = widget.radius ?? context.radii.brSm;
    final shouldAnimate =
        widget.animate && !MediaQuery.disableAnimationsOf(context);

    if (shouldAnimate && !_controller.isAnimating) {
      unawaited(_controller.repeat());
    } else if (!shouldAnimate && _controller.isAnimating) {
      _controller.stop();
    }

    if (!shouldAnimate) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: colors.skeletonBase,
          borderRadius: radius,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              colors: [
                colors.skeletonBase,
                colors.skeletonHighlight,
                colors.skeletonBase,
              ],
              stops: const [0.25, 0.5, 0.75],
              transform: _SlidingGradientTransform(_controller.value),
            ),
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.progress);

  final double progress;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    // Slide the gradient across [-w, +w] so the highlight sweeps through.
    return Matrix4.translationValues(
      bounds.width * (progress * 2 - 1),
      0,
      0,
    );
  }
}

/// A text-shaped skeleton line; [widthFactor] of the available width.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    this.widthFactor = 1,
    this.height = 12,
    this.animate = true,
    super.key,
  });

  final double widthFactor;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: AlignmentDirectional.centerStart,
      child: SkeletonBox(height: height, animate: animate),
    );
  }
}
