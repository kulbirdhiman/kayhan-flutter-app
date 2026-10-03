import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/network/api_client.dart';
import '../core/storage/local_storage.dart';
import '../core/theme/theme_controller.dart';
import '../features/account/presentation/address_controller.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/cart/presentation/cart_controller.dart';
import '../features/catalog/data/catalog_repository.dart';
import '../features/home/presentation/home_controller.dart';
import '../features/orders/data/order_repository.dart';
import '../features/orders/presentation/orders_controller.dart';
import '../features/vehicle/data/vehicle_repository.dart';
import '../features/vehicle/presentation/garage_controller.dart';
import '../features/wishlist/presentation/wishlist_controller.dart';

/// Composition root: builds repositories and app-wide controllers once.
class AppDependencies {
  AppDependencies._(this.storage, this.auth, this.api, this.authRepository);

  final LocalStorage storage;
  final AuthController auth;
  final ApiClient api;
  final AuthRepository authRepository;

  static Future<AppDependencies> create() async {
    final storage = await LocalStorage.create();
    final auth = AuthController(storage);
    final api = ApiClient(tokenProvider: () => auth.token);
    final authRepository = AuthRepository(api);
    auth.attach(authRepository);
    return AppDependencies._(storage, auth, api, authRepository);
  }

  List<SingleChildWidget> get providers {
    final catalog = CatalogRepository(api);
    return [
      Provider.value(value: storage),
      Provider.value(value: catalog),
      Provider.value(value: authRepository),
      Provider(create: (_) => VehicleRepository(api, catalog)),
      ChangeNotifierProvider.value(value: auth),
      ChangeNotifierProvider(create: (_) => ThemeController(storage)),
      ChangeNotifierProvider(create: (_) => HomeController(catalog)),
      ChangeNotifierProvider(create: (_) => CartController(storage)),
      ChangeNotifierProvider(create: (_) => WishlistController(storage)),
      ChangeNotifierProvider(create: (_) => GarageController(storage)),
      ChangeNotifierProvider(create: (_) => AddressController(storage)),
      ChangeNotifierProvider(create: (_) => OrdersController(LocalOrderRepository(storage))),
    ];
  }
}
