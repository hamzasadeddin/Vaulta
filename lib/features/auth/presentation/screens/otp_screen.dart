import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/presentation/forms/auth_inputs.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_state.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controller = TextEditingController();
  var _submitting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = OtpCodeInput.dirty(_controller.text);
    if (code.isNotValid) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final failure =
        await ref.read(authControllerProvider.notifier).verifyOtp(code.value);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _error = switch (failure) {
        null => null,
        ValidationFailure(:final fieldErrors) =>
          fieldErrors['code']?.first ?? 'Incorrect code',
        AuthFailure() => null, // controller sent us back to login
        _ => 'Something went wrong. Please try again.',
      };
    });
    if (_error != null) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Router guarantees this screen is only reachable in OtpPending.
    final state = ref.watch(authControllerProvider);
    final masked =
        state is OtpPending ? state.challenge.maskedDestination : 'your device';

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              ref.read(authControllerProvider.notifier).cancelOtp(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: context.spacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter the code',
                    textAlign: TextAlign.center,
                    style: context.textStyles.headlineSmall,
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    'We sent a 6-digit code to $masked',
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium
                        ?.copyWith(color: context.colors.textSecondary),
                  ),
                  SizedBox(height: context.spacing.xl),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: OtpCodeInput.length,
                    // Tabular figures keep the 6 digits evenly spaced.
                    style:
                        context.typography.moneyLg.copyWith(letterSpacing: 12),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••••',
                      errorText: _error,
                    ),
                    onChanged: (value) {
                      if (value.length == OtpCodeInput.length && !_submitting) {
                        unawaited(_submit());
                      }
                    },
                  ),
                  SizedBox(height: context.spacing.lg),
                  AppButton(
                    label: 'Verify',
                    size: AppButtonSize.large,
                    expand: true,
                    loading: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
