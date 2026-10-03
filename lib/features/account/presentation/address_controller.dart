import 'package:flutter/foundation.dart';

import '../../../core/storage/local_storage.dart';
import '../data/models/address.dart';

/// Saved delivery addresses (device-local until an address API exists).
class AddressController extends ChangeNotifier {
  AddressController(this._storage) {
    _items = _storage.readList(LocalStorage.addresses, Address.fromJson);
  }

  final LocalStorage _storage;
  late List<Address> _items;

  List<Address> get items => List.unmodifiable(_items);

  Address? get defaultAddress {
    for (final a in _items) {
      if (a.isDefault) return a;
    }
    return _items.isEmpty ? null : _items.first;
  }

  Address? byId(String id) {
    for (final a in _items) {
      if (a.id == id) return a;
    }
    return null;
  }

  void save(Address address) {
    final makeDefault = address.isDefault || _items.isEmpty;
    final exists = _items.any((a) => a.id == address.id);
    _items = exists
        ? [for (final a in _items) a.id == address.id ? address : a]
        : [..._items, address];
    if (makeDefault) _setDefault(address.id);
    _persist();
  }

  void remove(String id) {
    final wasDefault = byId(id)?.isDefault ?? false;
    _items = _items.where((a) => a.id != id).toList();
    if (wasDefault && _items.isNotEmpty) _setDefault(_items.first.id);
    _persist();
  }

  void setDefault(String id) {
    _setDefault(id);
    _persist();
  }

  void _setDefault(String id) {
    _items = [for (final a in _items) a.copyWith(isDefault: a.id == id)];
  }

  void _persist() {
    _storage.writeJson(LocalStorage.addresses, _items.map((a) => a.toJson()).toList());
    notifyListeners();
  }
}
