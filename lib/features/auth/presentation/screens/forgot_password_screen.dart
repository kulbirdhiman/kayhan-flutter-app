import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../data/auth_repository.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/password_field.dart';

/// Two steps: request a code by email, then enter code + new password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final repo = context.read<AuthRepository>();
    setState(() => _loading = true);
    try {
      if (!_codeSent) {
        await repo.sendResetCode(_email.text.trim());
        setState(() => _codeSent = true);
        if (mounted) context.showMessage('We’ve emailed you a verification code');
      } else {
        final email = _email.text.trim();
        final otp = _code.text.trim();
        await repo.verifyResetCode(email: email, otp: otp);
        await repo.setNewPassword(email: email, otp: otp, password: _password.text);
        if (!mounted) return;
        context.showMessage('Password updated. Please sign in.');
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) context.showMessage(ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: _codeSent ? 'Check your email' : 'Reset password',
      subtitle: _codeSent
          ? 'Enter the code sent to ${_email.text.trim()} and choose a new password.'
          : 'Enter your account email and we’ll send you a verification code.',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              enabled: !_codeSent,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline_rounded)),
            ),
            if (_codeSent) ...[
              AppSpacing.gapMd,
              TextFormField(
                controller: _code,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                validator: (v) => Validators.required(v, 'Code'),
                decoration: const InputDecoration(labelText: 'Verification code', prefixIcon: Icon(Icons.pin_outlined)),
              ),
              AppSpacing.gapMd,
              PasswordField(
                controller: _password,
                label: 'New password',
                validator: Validators.password,
                autofillHints: const [AutofillHints.newPassword],
                onSubmitted: (_) => _submit(),
              ),
            ],
            AppSpacing.gapXl,
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(_codeSent ? 'Update password' : 'Send code'),
            ),
            if (_codeSent)
              TextButton(
                onPressed: _loading ? null : () => setState(() => _codeSent = false),
                child: const Text('Use a different email'),
              ),
          ],
        ),
      ),
    );
  }
}
