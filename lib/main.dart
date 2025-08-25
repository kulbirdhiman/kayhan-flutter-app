import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/routes.dart';
import 'providers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authController = AuthController();
  await authController.init(); // load token / user data

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

