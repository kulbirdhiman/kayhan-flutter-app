import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/config/app_config.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../features/auth/presentation/auth_controller.dart';
import 'router/app_router.dart';

class KayhanApp extends StatefulWidget {
  const KayhanApp({super.key});

  @override
  State<KayhanApp> createState() => _KayhanAppState();
}

class _KayhanAppState extends State<KayhanApp> {
  // Created once so navigation state survives auth/theme changes.
  late final GoRouter _router = createRouter(context.read<AuthController>());

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeController, ThemeMode>((t) => t.mode);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
