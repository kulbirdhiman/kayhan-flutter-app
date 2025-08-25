import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart'; 
import '../providers/auth_controller.dart'; 

import '../screens/home_screen.dart';
import '../screens/auth/login_screen.dart';
import "../screens/auth/register_screen.dart";
import '../screens/search_screen.dart';
import '../screens/users/profile_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/products/product_detail_screen.dart';

GoRouter createRouter(AuthController auth) {
  return GoRouter(
    refreshListenable: auth, // 👈 listens to login/logout
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;

      // If logged in and trying to go to login/register → send to home
      if (loggedIn &&
          (state.fullPath == '/login' || state.fullPath == '/register')) {
        return '/profile';
      }

      // If not logged in and trying to access profile/cart → send to login
      if (!loggedIn &&
          (state.fullPath == '/profile' || state.fullPath == '/cart')) {
        return '/login';
      }

      return null;
    },
    routes: [
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
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const ProductSearchPage(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: '/product/:id',
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailPage(productId: productId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/search')) currentIndex = 1;
    else if (location.startsWith('/cart')) currentIndex = 2;
    else if (location.startsWith('/profile')) currentIndex = 3;

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
            context.go('/profile'); // Profile page when logged in
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "My Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
