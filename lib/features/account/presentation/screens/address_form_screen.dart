import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/store_config.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/bottom_action_bar.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../data/models/address.dart';
import '../address_controller.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key, this.addressId});

  /// `null` creates a new address.
  final String? addressId;

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _form = GlobalKey<FormState>();
  late final Address? _existing = widget.addressId == null
      ? null
      : context.read<AddressController>().byId(widget.addressId!);

  late final _name = TextEditingController(
    text: _existing?.fullName ?? context.read<AuthController>().user?.displayName,
  );
  late final _phone = TextEditingController(text: _existing?.phone ?? context.read<AuthController>().user?.phone);
  late final _line1 = TextEditingController(text: _existing?.line1);
  late final _line2 = TextEditingController(text: _existing?.line2);
  late final _suburb = TextEditingController(text: _existing?.suburb);
  late final _postcode = TextEditingController(text: _existing?.postcode);
  late String? _state = _existing?.state;
  late bool _isDefault = _existing?.isDefault ?? false;
  bool _submitted = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _line1, _line2, _suburb, _postcode]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    setState(() => _submitted = true);
    final valid = _form.currentState!.validate();
    if (!valid || _state == null) return;
    context.read<AddressController>().save(
          Address(
            id: _existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
            fullName: _name.text.trim(),
            phone: _phone.text.trim(),
            line1: _line1.text.trim(),
            line2: _line2.text.trim(),
            suburb: _suburb.text.trim(),
            state: _state!,
            postcode: _postcode.text.trim(),
            isDefault: _isDefault,
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    InputDecoration deco(String label) => InputDecoration(labelText: label);

    return Scaffold(
      appBar: AppBar(title: Text(_existing == null ? 'New address' : 'Edit address')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: (v) => Validators.required(v, 'Full name'),
              decoration: deco('Full name'),
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              validator: Validators.phone,
              decoration: deco('Phone'),
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _line1,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.streetAddressLine1],
              validator: (v) => Validators.required(v, 'Street address'),
              decoration: deco('Street address'),
            ),
            AppSpacing.gapMd,
            TextFormField(
              controller: _line2,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.streetAddressLine2],
              decoration: deco('Apartment, unit, etc. (optional)'),
            ),
            AppSpacing.gapMd,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _suburb,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.addressCity],
                    validator: (v) => Validators.required(v, 'Suburb'),
                    decoration: deco('Suburb'),
                  ),
                ),
                AppSpacing.gapMd,
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _postcode,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.postalCode],
                    validator: Validators.postcode,
                    decoration: deco('Postcode'),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            Text('State', style: theme.textTheme.titleSmall),
            AppSpacing.gapSm,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final s in StoreConfig.australianStates)
                  ChoiceChip(
                    label: Text(s),
                    selected: _state == s,
                    onSelected: (_) => setState(() => _state = s),
                  ),
              ],
            ),
            if (_state == null && _submitted)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text('Select a state', style: TextStyle(color: theme.colorScheme.error, fontSize: 12)),
              ),
            AppSpacing.gapLg,
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              title: const Text('Set as default address'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(onPressed: _save, child: const Text('Save address')),
      ),
    );
  }
}
