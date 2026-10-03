import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../../auth/presentation/widgets/password_field.dart';

/// Account details and password change.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AuthController>().refreshProfile());
  }

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await context.read<AuthRepository>().changePassword(current: _current.text, next: _next.text);
      _current.clear();
      _next.clear();
      if (mounted) context.showMessage('Password updated');
    } catch (e) {
      if (mounted) context.showMessage(ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthController>().user;

    Widget field(String label, String? value) => ListTile(
          title: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          subtitle: Text(value?.isNotEmpty == true ? value! : '—', style: theme.textTheme.titleSmall),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & security')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          Text('Personal details', style: theme.textTheme.titleMedium),
          AppSpacing.gapSm,
          Card(
            child: Column(
              children: [
                field('Name', user?.displayName),
                const Divider(),
                field('Email', user?.email),
                const Divider(),
                field('Phone', user?.phone),
              ],
            ),
          ),
          AppSpacing.gapXl,
          Text('Change password', style: theme.textTheme.titleMedium),
          AppSpacing.gapSm,
          Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PasswordField(
                  controller: _current,
                  label: 'Current password',
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, 'Current password'),
                ),
                AppSpacing.gapMd,
                PasswordField(
                  controller: _next,
                  label: 'New password',
                  validator: Validators.password,
                  autofillHints: const [AutofillHints.newPassword],
                  onSubmitted: (_) => _changePassword(),
                ),
                AppSpacing.gapLg,
                FilledButton(
                  onPressed: _saving ? null : _changePassword,
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Text('Update password'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
