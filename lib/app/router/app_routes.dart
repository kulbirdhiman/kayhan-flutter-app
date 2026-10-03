/// Route paths and builders. Screens navigate only through these helpers.
class AppRoutes {
  AppRoutes._();

  // Bottom-tab roots
  static const home = '/';
  static const shop = '/shop';
  static const garage = '/garage';
  static const cart = '/cart';
  static const account = '/account';

  // Catalog
  static const search = '/search';
  static const products = '/products';
  static String product(String slug) => '/product/${Uri.encodeComponent(slug)}';
  static String productList({required String title, String? query}) => Uri(
        path: products,
        queryParameters: {'title': title, if (query != null) 'q': query},
      ).toString();

  // Vehicle
  static const vehicleSelect = '/vehicle/select';
  static String vehicleSelectFor(int makeId) => '$vehicleSelect?make=$makeId';

  // Shopping
  static const wishlist = '/wishlist';
  static const checkout = '/checkout';
  static String orderSuccess(String id) => '/order-success/$id';

  // Account
  static const orders = '/account/orders';
  static String order(String id) => '$orders/$id';
  static const profile = '/account/profile';
  static const addresses = '/account/addresses';
  static const addressNew = '/address/new';
  static String addressEdit(String id) => '/address/$id/edit';
  static const help = '/account/help';

  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static String loginWith(String? from) =>
      from == null ? login : Uri(path: login, queryParameters: {'from': from}).toString();
  static String registerWith(String? from) =>
      from == null ? register : Uri(path: register, queryParameters: {'from': from}).toString();

  /// Paths that require a signed-in user.
  static const protectedPrefixes = [checkout, orders, profile, addresses];
  static const authPaths = [login, register, forgotPassword];

  static bool isProtected(String path) => protectedPrefixes.any(path.startsWith);
}
