import 'package:flutter/material.dart';
import 'utils/routes.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
