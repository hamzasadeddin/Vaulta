import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';
import 'package:vaulta/features/transfers/presentation/widgets/amount_step.dart';
import 'package:vaulta/features/transfers/presentation/widgets/queued_view.dart';
import 'package:vaulta/features/transfers/presentation/widgets/receipt_view.dart';
import 'package:vaulta/features/transfers/presentation/widgets/recipient_step.dart';
import 'package:vaulta/features/transfers/presentation/widgets/review_step.dart';

/// The send-money flow: recipient → amount → review → receipt.
///
/// One route holding five surfaces rather than five routes. The steps
/// share a single draft that only means something as a whole — a URL
/// pointing at "the amount step" would restore a half-built transfer with
/// no recipient, and a browser back button between steps would desync the
/// server-issued quote. The flow owns its own back handling instead.
///
/// [resume] re-enters the flow at review with a fresh price for a
/// transfer the outbox could not deliver. It arrives as go_router's
/// `extra` rather than through a provider because the flow controller is
/// auto-dispose: a request written into it from the queue's UI would be
/// discarded before this screen existed to read it.
class TransferFlowScreen extends ConsumerStatefulWidget {
  const TransferFlowScreen({this.resume, super.key});

  final TransferRequest? resume;

  @override
  ConsumerState<TransferFlowScreen> createState() => _TransferFlowScreenState();
}

class _TransferFlowScreenState extends ConsumerState<TransferFlowScreen> {
  @override
  void initState() {
    super.initState();
    final resume = widget.resume;
    if (resume == null) return;
    // After the first frame: `resumeFrom` writes provider state, and
    // Riverpod rejects that during a build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(transferFlowProvider.notifier).resumeFrom(resume));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferFlowProvider);
    final notifier = ref.read(transferFlowProvider.notifier);
    final atStart = state.step == TransferStep.recipient;
    // Both terminal surfaces close the flow rather than stepping back.
    final done =
        state.step == TransferStep.receipt || state.step == TransferStep.queued;

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
      // rather than abandoning it. The terminal surfaces pop.
      canPop: atStart || done,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Deferred by a microtask, not called inline. This callback runs
          // from inside the Navigator's `didUpdateWidget`, i.e. mid-build,
          // and `reset()` writes provider state — Riverpod rejects that
          // outright. A microtask lands immediately after the frame's
          // synchronous work, before any timer, so the draft is still
          // cleared promptly.
          scheduleMicrotask(notifier.reset);
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
                      TransferStep.queued => QueuedView(onDone: leave),
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
        TransferStep.queued => 'Saved to send',
      };
}

/// Three filling segments — the terminal surfaces show all of them
/// complete. A queued transfer is finished from the flow's point of
/// view: there is nothing left for the user to do.
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
      TransferStep.review || TransferStep.receipt || TransferStep.queued => 3,
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
