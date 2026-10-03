import 'package:flutter/foundation.dart';

import '../../../core/storage/local_storage.dart';
import '../../catalog/data/models/product.dart';

/// Saved products, stored on device.
class WishlistController extends ChangeNotifier {
  WishlistController(this._storage) {
    _items = _storage.readList(LocalStorage.wishlist, Product.fromJson);
  }

  final LocalStorage _storage;
  late List<Product> _items;

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool contains(int productId) => _items.any((p) => p.id == productId);

  /// Returns `true` if the product is now saved.
  bool toggle(Product product) {
    final saved = contains(product.id);
    _items = saved
        ? _items.where((p) => p.id != product.id).toList()
        : [product, ..._items];
    _storage.writeJson(LocalStorage.wishlist, _items.map((p) => p.toSnapshotJson()).toList());
    notifyListeners();
    return !saved;
  }
}
