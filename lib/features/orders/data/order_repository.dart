import '../../../core/storage/local_storage.dart';
import 'models/order.dart';

/// Order storage contract. Swap [LocalOrderRepository] for an API-backed
/// implementation once the backend exposes order + payment endpoints.
abstract class OrderRepository {
  Future<List<Order>> orders();
  Future<Order> place(Order order);
}

/// Keeps orders on the device. Payment is NOT processed.
class LocalOrderRepository implements OrderRepository {
  LocalOrderRepository(this._storage);

  final LocalStorage _storage;

  @override
  Future<List<Order>> orders() async =>
      _storage.readList(LocalStorage.orders, Order.fromJson)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<Order> place(Order order) async {
    final all = await orders();
    await _storage.writeJson(LocalStorage.orders, [order, ...all].map((o) => o.toJson()).toList());
    return order;
  }
}
