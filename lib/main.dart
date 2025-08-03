import 'package:flutter/material.dart';
import 'package:kayhan_app/screens/cart_screen.dart';
import 'package:kayhan_app/screens/favorites_sceen.dart';
import 'package:kayhan_app/widgets/auth/login_page.dart';
import 'screens/home_screem.dart';
import 'widgets/layout/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kayhan Audio',
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Placeholder(),
    CartScreen(), // replace with SettingsPage()
    TodoListPage(),
    LoginPage(),
     // replace with ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
