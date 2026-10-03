import 'package:flutter/foundation.dart';

import '../../../core/storage/local_storage.dart';
import '../../catalog/data/models/product.dart';
import '../data/models/cart_item.dart';

/// Device-local cart (works for guests). Persisted between sessions.
class CartController extends ChangeNotifier {
  CartController(this._storage) {
    _items = _storage.readList(LocalStorage.cart, CartItem.fromJson);
  }

  static const maxQuantity = 20;

  final LocalStorage _storage;
  late List<CartItem> _items;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => _items.fold(0, (sum, i) => sum + i.lineTotal);
  double get savings => _items.fold(0, (sum, i) => sum + i.lineSavings);

  void add(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.productId == product.id);
    if (index == -1) {
      _items = [..._items, CartItem.fromProduct(product, quantity.clamp(1, maxQuantity))];
    } else {
      final current = _items[index];
      _items[index] = current.copyWith(quantity: (current.quantity + quantity).clamp(1, maxQuantity));
    }
    _persist();
  }

  void setQuantity(int productId, int quantity) {
    _items = [
      for (final i in _items)
        if (i.productId == productId) i.copyWith(quantity: quantity.clamp(1, maxQuantity)) else i,
    ];
    _persist();
  }

  /// Removes an item and returns it so the UI can offer "Undo".
  CartItem? remove(int productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index == -1) return null;
    final removed = _items[index];
    _items = [..._items]..removeAt(index);
    _persist();
    return removed;
  }

  void restore(CartItem item) {
    if (_items.any((i) => i.productId == item.productId)) return;
    _items = [..._items, item];
    _persist();
  }

  void clear() {
    _items = [];
    _persist();
  }

  void _persist() {
    _storage.writeJson(LocalStorage.cart, _items.map((i) => i.toJson()).toList());
    notifyListeners();
  }
}
