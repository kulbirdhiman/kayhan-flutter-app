import 'package:flutter/foundation.dart';

import '../../../core/storage/local_storage.dart';
import '../data/models/vehicle.dart';

/// Saved vehicles ("My Garage") and the currently selected one.
class GarageController extends ChangeNotifier {
  GarageController(this._storage) {
    _vehicles = _storage.readList(LocalStorage.garage, Vehicle.fromJson);
    _selectedId = _storage.getString(LocalStorage.selectedVehicle);
  }

  final LocalStorage _storage;
  late List<Vehicle> _vehicles;
  String? _selectedId;

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  Vehicle? get selected {
    for (final v in _vehicles) {
      if (v.id == _selectedId) return v;
    }
    return _vehicles.isEmpty ? null : _vehicles.first;
  }

  void add(Vehicle vehicle) {
    _vehicles = [vehicle, ..._vehicles.where((v) => v.id != vehicle.id)];
    _selectedId = vehicle.id;
    _persist();
  }

  void remove(Vehicle vehicle) {
    _vehicles = _vehicles.where((v) => v.id != vehicle.id).toList();
    if (_selectedId == vehicle.id) _selectedId = _vehicles.isEmpty ? null : _vehicles.first.id;
    _persist();
  }

  void select(Vehicle vehicle) {
    _selectedId = vehicle.id;
    _persist();
  }

  void _persist() {
    _storage.writeJson(LocalStorage.garage, _vehicles.map((v) => v.toJson()).toList());
    if (_selectedId == null) {
      _storage.remove(LocalStorage.selectedVehicle);
    } else {
      _storage.setString(LocalStorage.selectedVehicle, _selectedId!);
    }
    notifyListeners();
  }
}
