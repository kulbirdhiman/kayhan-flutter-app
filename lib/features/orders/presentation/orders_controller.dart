import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/load_state.dart';
import '../data/models/order.dart';
import '../data/order_repository.dart';

class OrdersController extends ChangeNotifier {
  OrdersController(this._repo);

  final OrderRepository _repo;
  LoadState<List<Order>> _state = const LoadState.idle();

  LoadState<List<Order>> get state => _state;

  Order? byId(String id) {
    for (final o in _state.data ?? const <Order>[]) {
      if (o.id == id) return o;
    }
    return null;
  }

  Future<void> load() async {
    _state = LoadState.loading(_state.data);
    notifyListeners();
    try {
      _state = LoadState.success(await _repo.orders());
    } catch (e) {
      _state = LoadState.failure(ApiException.from(e).message, _state.data);
    }
    notifyListeners();
  }

  Future<Order> place(Order order) async {
    final placed = await _repo.place(order);
    await load();
    return placed;
  }
}
