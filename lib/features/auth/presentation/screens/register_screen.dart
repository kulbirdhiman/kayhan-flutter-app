import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../auth_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/password_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _acceptTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_first, _last, _email, _phone, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (!_acceptTerms) {
      context.showMessage('Please accept the terms to continue');
      return;
    }
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().signUp(
            firstName: _first.text.trim(),
            lastName: _last.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            password: _password.text,
          );
      if (mounted) context.go(widget.redirectTo ?? AppRoutes.account);
    } catch (e) {
      if (mounted) context.showMessage(ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create account',
      subtitle: 'Save your garage, wishlist and order history.',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already have an account?'),
          TextButton(
            onPressed: () => context.pushReplacement(AppRoutes.loginWith(widget.redirectTo)),
            child: const Text('Sign in'),
          ),
        ],
      ),
      child: Form(
        key: _form,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _first,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.givenName],
                      validator: (v) => Validators.required(v, 'First name'),
                      decoration: const InputDecoration(labelText: 'First name'),
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: TextFormField(
                      controller: _last,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.familyName],
                      validator: (v) => Validators.required(v, 'Last name'),
                      decoration: const InputDecoration(labelText: 'Last name'),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline_rounded)),
              ),
              AppSpacing.gapMd,
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                validator: Validators.phone,
                decoration: const InputDecoration(labelText: 'Mobile', prefixIcon: Icon(Icons.phone_outlined)),
              ),
              AppSpacing.gapMd,
              PasswordField(
                controller: _password,
                textInputAction: TextInputAction.next,
                validator: Validators.password,
                autofillHints: const [AutofillHints.newPassword],
              ),
              AppSpacing.gapMd,
              PasswordField(
                controller: _confirm,
                label: 'Confirm password',
                validator: (v) => v != _password.text ? 'Passwords don’t match' : null,
                onSubmitted: (_) => _submit(),
                autofillHints: const [AutofillHints.newPassword],
              ),
              AppSpacing.gapSm,
              CheckboxListTile(
                value: _acceptTerms,
                onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('I agree to the Terms & Conditions and Privacy Policy'),
              ),
              AppSpacing.gapMd,
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                    : const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
