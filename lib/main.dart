import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'utils/routes.dart';
import 'providers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authController = AuthController();
  await authController.init();
// await Firebase.initializeApp(
//   options: defa
// )
  // Initialize OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("e499e747-b75d-4316-acc3-fdbb9517d58e"); // Replace with your OneSignal App ID
  OneSignal.Notifications.requestPermission(true);

  // Handle notification opened
  OneSignal.Notifications.addClickListener((event) {
    print("Notification clicked: ${event.notification.jsonRepresentation()}");
    // You can navigate to specific screen here
  });

  runApp(
    ChangeNotifierProvider.value(
      value: authController,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final router = createRouter(auth);

    return MaterialApp.router(
      title: 'Kayhan Audio App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
