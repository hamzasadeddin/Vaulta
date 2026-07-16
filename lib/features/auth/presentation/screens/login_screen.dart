import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/auth/presentation/forms/auth_inputs.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var _email = const EmailInput.pure();
  var _password = const PasswordInput.pure();
  var _submitting = false;
  Failure? _failure;

  bool get _valid => Formz.validate([_email, _password]);

  Future<void> _submit() async {
    setState(() {
      _email = EmailInput.dirty(_email.value);
      _password = PasswordInput.dirty(_password.value);
      _failure = null;
    });
    if (!_valid) return;

    setState(() => _submitting = true);
    final failure = await ref.read(authControllerProvider.notifier).login(
          email: _email.value.trim(),
          password: _password.value,
        );
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _failure = failure;
    });
    // On success the router redirects to /otp via the state change.
  }

  String? get _emailError => switch (_email.displayError) {
        EmailValidationError.empty => 'Email is required',
        EmailValidationError.invalid => 'Enter a valid email address',
        null => null,
      };

  String? get _passwordError => switch (_password.displayError) {
        PasswordValidationError.empty => 'Password is required',
        PasswordValidationError.tooShort =>
          'At least ${PasswordInput.minLength} characters',
        null => null,
      };

  String _failureCopy(Failure failure) => switch (failure) {
        AuthFailure() => 'Invalid email or password.',
        NetworkFailure() ||
        TimeoutFailure() =>
          'Can\u2019t reach Vaulta. Check your connection.',
        _ => 'Something went wrong. Please try again.',
      };

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    return Scaffold(
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
                    'Vaulta',
                    textAlign: TextAlign.center,
                    style: context.textStyles.displaySmall,
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    'Sign in to your account',
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMedium
                        ?.copyWith(color: context.colors.textSecondary),
                  ),
                  SizedBox(height: context.spacing.xl),
                  if (_failure != null) ...[
                    _ErrorBanner(message: _failureCopy(_failure!)),
                    SizedBox(height: context.spacing.md),
                  ],
                  AppTextField(
                    label: 'Email',
                    hint: 'name@example.com',
                    prefixIcon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    errorText: _emailError,
                    onChanged: (value) =>
                        setState(() => _email = EmailInput.dirty(value)),
                  ),
                  SizedBox(height: context.spacing.md),
                  AppTextField(
                    label: 'Password',
                    hint: 'Your password',
                    prefixIcon: LucideIcons.lock,
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    errorText: _passwordError,
                    onChanged: (value) =>
                        setState(() => _password = PasswordInput.dirty(value)),
                    onSubmitted: (_) => _submit(),
                  ),
                  SizedBox(height: context.spacing.lg),
                  AppButton(
                    label: 'Continue',
                    size: AppButtonSize.large,
                    expand: true,
                    loading: _submitting,
                    onPressed: _submit,
                  ),
                  if (config.useMockApi) ...[
                    SizedBox(height: context.spacing.lg),
                    Text(
                      'Demo build: any email, any password of 8+ '
                      'characters. OTP code is 123456.',
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodySmall
                          ?.copyWith(color: context.colors.textTertiary),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(context.spacing.md),
      decoration: BoxDecoration(
        color: colors.danger.withValues(alpha: 0.12),
        borderRadius: context.radii.brMd,
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, size: 18, color: colors.danger),
          SizedBox(width: context.spacing.sm),
          Expanded(
            child: Text(
              message,
              style:
                  context.textStyles.bodyMedium?.copyWith(color: colors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
