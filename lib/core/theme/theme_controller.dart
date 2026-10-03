import 'package:flutter/material.dart';

import '../storage/local_storage.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._storage) {
    final saved = _storage.getString(LocalStorage.themeMode);
    _mode = ThemeMode.values.firstWhere((m) => m.name == saved, orElse: () => ThemeMode.system);
  }

  final LocalStorage _storage;
  late ThemeMode _mode;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    _mode = mode;
    _storage.setString(LocalStorage.themeMode, mode.name);
    notifyListeners();
  }
}
