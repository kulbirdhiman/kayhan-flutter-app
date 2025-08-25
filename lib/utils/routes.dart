import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kayhan_app/screens/cart_screen.dart';

// Import your screens
import '../screens/home_screen.dart';
import '../screens/auth/login_screen.dart';
import "../screens/auth/register_screen.dart";
import '../screens/search_screen.dart';
import '../screens/products/product_detail_screen.dart'; // <-- add product detail screen

final GoRouter router = GoRouter(
  routes: [
    /// ShellRoute keeps BottomNav persistent
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const BottomNavBar(),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const ProductSearchPage(),
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => const CartPage(),
        ),

        // ✅ NEW: Product Detail Page route
        GoRoute(
          path: '/product/:id',
          name: 'productDetail',
          builder: (context, state) {
            final productId = state.pathParameters['id']!;
            return ProductDetailPage(productId: productId);
          },
        ),
      ],
    ),

    // Auth routes (without BottomNav)
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/search')) currentIndex = 1;
    else if (location.startsWith('/cart')) currentIndex = 2;
    else if (location.startsWith('/support')) currentIndex = 3;
    else if (location.startsWith('/profile')) currentIndex = 4;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/search');
            break;
          case 2:
            context.go('/cart');
            break;
          case 3:
            context.go('/login');
            break;
          case 4:
            context.go('/login');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "My Cart"),
        // BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Support"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
