import 'package:flutter/material.dart';
import 'package:vaulta/features/transactions/presentation/widgets/transaction_detail_view.dart';

/// Pushed receipt route for compact/medium layouts. Expanded layouts
/// render the same view in the shell's secondary pane instead.
class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: SafeArea(
        child: TransactionDetailView(transactionId: transactionId),
      ),
    );
  }
}
