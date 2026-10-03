import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../../vehicle/presentation/garage_controller.dart';
import '../../../wishlist/presentation/wishlist_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final wishlistCount = context.select<WishlistController, int>((w) => w.count);
    final garageCount = context.select<GarageController, int>((g) => g.vehicles.length);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          Padding(
            padding: AppSpacing.page,
            child: auth.isLoggedIn ? _ProfileHeader(auth: auth) : const _GuestHeader(),
          ),
          AppSpacing.gapLg,
          _Group(
            title: 'Shopping',
            tiles: [
              _Tile(Icons.receipt_long_outlined, 'My orders', () => context.push(AppRoutes.orders)),
              _Tile(
                Icons.favorite_border_rounded,
                'Wishlist',
                () => context.push(AppRoutes.wishlist),
                trailing: wishlistCount > 0 ? '$wishlistCount' : null,
              ),
              _Tile(
                Icons.directions_car_outlined,
                'My garage',
                () => context.go(AppRoutes.garage),
                trailing: garageCount > 0 ? '$garageCount' : null,
              ),
              _Tile(Icons.location_on_outlined, 'Addresses', () => context.push(AppRoutes.addresses)),
            ],
          ),
          _Group(
            title: 'Settings',
            tiles: [
              if (auth.isLoggedIn) _Tile(Icons.person_outline_rounded, 'Profile & security', () => context.push(AppRoutes.profile)),
              _Tile(Icons.dark_mode_outlined, 'Appearance', () => _pickTheme(context)),
            ],
          ),
          _Group(
            title: 'Support',
            tiles: [
              _Tile(Icons.help_outline_rounded, 'Help & FAQs', () => context.push(AppRoutes.help)),
            ],
          ),
          if (auth.isLoggedIn)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.lg, AppSpacing.gutter, 0),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.sale),
                onPressed: () => _confirmSignOut(context, auth),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign out'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, AuthController auth) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sign out')),
        ],
      ),
    );
    if (ok == true) await auth.signOut();
  }

  void _pickTheme(BuildContext context) {
    final controller = context.read<ThemeController>();
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (mode, label, icon) in [
              (ThemeMode.system, 'Use device setting', Icons.brightness_auto_outlined),
              (ThemeMode.light, 'Light', Icons.light_mode_outlined),
              (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
            ])
              ListTile(
                leading: Icon(icon),
                title: Text(label),
                trailing: controller.mode == mode ? const Icon(Icons.check_rounded) : null,
                onTap: () {
                  controller.setMode(mode);
                  Navigator.pop(ctx);
                },
              ),
            AppSpacing.gapMd,
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = auth.user;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                user?.initials ?? '?',
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
            AppSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.displayName ?? 'Signed in', style: theme.textTheme.titleMedium),
                  if (user?.email.isNotEmpty ?? false)
                    Text(
                      user!.email,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestHeader extends StatelessWidget {
  const _GuestHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(color: AppColors.ink, borderRadius: AppRadius.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sign in to Kayhan', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
          AppSpacing.gapXs,
          Text(
            'Track orders, save addresses and check out faster.',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          AppSpacing.gapLg,
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primaryBright, foregroundColor: AppColors.ink),
                  onPressed: () => context.push(AppRoutes.login),
                  child: const Text('Sign in'),
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                  ),
                  onPressed: () => context.push(AppRoutes.register),
                  child: const Text('Join'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.tiles});

  final String title;
  final List<_Tile> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, AppSpacing.md, AppSpacing.gutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.1,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  if (i > 0) const Divider(indent: 56),
                  tiles[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, this.onTap, {this.trailing});

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing!, style: Theme.of(context).textTheme.bodySmall),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
