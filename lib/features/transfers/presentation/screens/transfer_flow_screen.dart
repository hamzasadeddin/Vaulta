import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';
import 'package:vaulta/features/transfers/presentation/widgets/amount_step.dart';
import 'package:vaulta/features/transfers/presentation/widgets/receipt_view.dart';
import 'package:vaulta/features/transfers/presentation/widgets/recipient_step.dart';
import 'package:vaulta/features/transfers/presentation/widgets/review_step.dart';

/// The send-money flow: recipient → amount → review → receipt.
///
/// One route holding four surfaces rather than four routes. The steps
/// share a single draft that only means something as a whole — a URL
/// pointing at "the amount step" would restore a half-built transfer with
/// no recipient, and a browser back button between steps would desync the
/// server-issued quote. The flow owns its own back handling instead.
class TransferFlowScreen extends ConsumerWidget {
  const TransferFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferFlowProvider);
    final notifier = ref.read(transferFlowProvider.notifier);
    final atStart = state.step == TransferStep.recipient;
    final done = state.step == TransferStep.receipt;

    void leave() {
      notifier.reset();
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    }

    return PopScope(
      // Mid-flow, a system back gesture steps backwards through the draft
      // rather than abandoning it. The receipt is terminal, so it pops.
      canPop: atStart || done,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          notifier.reset();
          return;
        }
        notifier.back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleFor(state.step)),
          leading: IconButton(
            icon: Icon(done ? LucideIcons.x : LucideIcons.arrowLeft),
            tooltip: atStart || done ? 'Close' : 'Back',
            onPressed: atStart || done ? leave : notifier.back,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _StepProgress(step: state.step),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: switch (state.step) {
                      TransferStep.recipient => const RecipientStep(),
                      TransferStep.amount => const AmountStep(),
                      TransferStep.review => const ReviewStep(),
                      TransferStep.receipt => ReceiptView(onDone: leave),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _titleFor(TransferStep step) => switch (step) {
        TransferStep.recipient => 'Send money',
        TransferStep.amount => 'Amount',
        TransferStep.review => 'Review',
        TransferStep.receipt => 'Receipt',
      };
}

/// Three filling segments — the receipt shows all of them complete.
class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step});

  final TransferStep step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final reached = switch (step) {
      TransferStep.recipient => 1,
      TransferStep.amount => 2,
      TransferStep.review || TransferStep.receipt => 3,
    };

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          for (var index = 1; index <= 3; index++) ...[
            if (index != 1) SizedBox(width: spacing.xs),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: 3,
                decoration: BoxDecoration(
                  color: index <= reached ? colors.accent : colors.border,
                  borderRadius: context.radii.brFull,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
