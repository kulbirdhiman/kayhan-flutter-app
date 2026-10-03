import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/dependencies.dart';
import 'core/services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // clean web URLs (/product/x instead of /#/product/x)

  final deps = await AppDependencies.create();
  PushNotificationService.init();
  deps.auth.refreshProfile();

  runApp(
    MultiProvider(
      providers: deps.providers,
      child: const KayhanApp(),
    ),
  );
}
