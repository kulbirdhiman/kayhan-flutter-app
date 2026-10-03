import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/account/presentation/screens/address_form_screen.dart';
import '../../features/account/presentation/screens/addresses_screen.dart';
import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/catalog/presentation/screens/product_detail_screen.dart';
import '../../features/catalog/presentation/screens/product_list_screen.dart';
import '../../features/catalog/presentation/screens/search_screen.dart';
import '../../features/catalog/presentation/screens/shop_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/order_success_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/support/presentation/screens/help_screen.dart';
import '../../features/vehicle/presentation/screens/garage_screen.dart';
import '../../features/vehicle/presentation/screens/vehicle_selector_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter(AuthController auth) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.home,
    refreshListenable: auth,
    redirect: (context, state) {
      final path = state.uri.path;
      if (!auth.isLoggedIn && AppRoutes.isProtected(path)) {
        return AppRoutes.loginWith(state.uri.toString());
      }
      if (auth.isLoggedIn && AppRoutes.authPaths.contains(path)) {
        return state.uri.queryParameters['from'] ?? AppRoutes.account;
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.shop, builder: (_, _) => const ShopScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.garage, builder: (_, _) => const GarageScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.cart, builder: (_, _) => const CartScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.account,
              builder: (_, _) => const AccountScreen(),
              routes: [
                GoRoute(
                  path: 'orders',
                  builder: (_, _) => const OrdersScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['id']!),
                    ),
                  ],
                ),
                GoRoute(path: 'profile', builder: (_, _) => const ProfileScreen()),
                GoRoute(path: 'addresses', builder: (_, _) => const AddressesScreen()),
                GoRoute(path: 'help', builder: (_, _) => const HelpScreen()),
              ],
            ),
          ]),
        ],
      ),

      // Full-screen routes (no bottom bar)
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => SearchScreen(initialQuery: state.uri.queryParameters['q']),
      ),
      GoRoute(
        path: AppRoutes.products,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ProductListScreen(
          title: state.uri.queryParameters['title'] ?? 'Products',
          query: state.uri.queryParameters['q'],
        ),
      ),
      GoRoute(
        path: '/product/:slug',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ProductDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: AppRoutes.vehicleSelect,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => VehicleSelectorScreen(
          initialMakeId: int.tryParse(state.uri.queryParameters['make'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.addressNew,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const AddressFormScreen(),
      ),
      GoRoute(
        path: '/address/:id/edit',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => AddressFormScreen(addressId: state.pathParameters['id']),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const WishlistScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-success/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => OrderSuccessScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LoginScreen(redirectTo: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: AppRoutes.register,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => RegisterScreen(redirectTo: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
    ],
  );
}
