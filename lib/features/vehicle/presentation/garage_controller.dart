import 'package:flutter/foundation.dart';

import '../../../core/storage/local_storage.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/garage_repository.dart';
import '../data/models/vehicle.dart';

/// Saved vehicles, kept locally and synchronized for signed-in customers.
class GarageController extends ChangeNotifier {
  GarageController(this._storage, this._repository, this._auth) {
    _vehicles = _storage.readList(LocalStorage.garage, Vehicle.fromJson);
    _selectedId = _storage.getString(LocalStorage.selectedVehicle);
    _wasLoggedIn = _auth.isLoggedIn;
    _auth.addListener(_onAuthChanged);
    if (_wasLoggedIn) _sync();
  }

  final LocalStorage _storage;
  final GarageRepository _repository;
  final AuthController _auth;
  late List<Vehicle> _vehicles;
  String? _selectedId;
  late bool _wasLoggedIn;
  bool _syncing = false;

  List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  bool get isSyncing => _syncing;

  Vehicle? get selected {
    for (final v in _vehicles) {
      if (v.id == _selectedId) return v;
    }
    return _vehicles.isEmpty ? null : _vehicles.first;
  }

  void add(Vehicle vehicle) {
    _vehicles = [
      vehicle.copyWith(isSelected: true),
      ..._vehicles.where((v) => v.id != vehicle.id).map((v) => v.copyWith(isSelected: false)),
    ];
    _selectedId = vehicle.id;
    _persist();
    if (_auth.isLoggedIn) _sync();
  }

  void remove(Vehicle vehicle) {
    _vehicles = _vehicles.where((v) => v.id != vehicle.id).toList();
    if (_selectedId == vehicle.id) _selectedId = _vehicles.isEmpty ? null : _vehicles.first.id;
    _persist();
    if (_auth.isLoggedIn) _syncRemoval(vehicle);
  }

  void select(Vehicle vehicle) {
    _selectedId = vehicle.id;
    _vehicles = _vehicles
        .map((v) => v.copyWith(isSelected: v.id == vehicle.id))
        .toList();
    _persist();
    if (_auth.isLoggedIn) _syncSelection(vehicle);
  }

  void _onAuthChanged() {
    final loggedIn = _auth.isLoggedIn;
    if (loggedIn && !_wasLoggedIn) _sync();
    _wasLoggedIn = loggedIn;
  }

  Future<void> _sync() async {
    if (_syncing || !_auth.isLoggedIn) return;
    _syncing = true;
    notifyListeners();
    try {
      // Upload local-only vehicles first so signing in does not lose them.
      for (final vehicle in List<Vehicle>.from(_vehicles)) {
        if (vehicle.recordId == null) {
          final saved = await _repository.save(vehicle, selected: vehicle.id == _selectedId);
          _vehicles = _vehicles.map((v) => v.id == vehicle.id ? saved : v).toList();
        }
      }
      final remote = await _repository.list();
      if (remote.isNotEmpty || _vehicles.isEmpty) {
        final selectedRemote = remote.where((v) => v.isSelected).firstOrNull;
        _vehicles = remote;
        _selectedId = selectedRemote?.id ?? (_vehicles.isEmpty ? null : _vehicles.first.id);
        _persist();
      }
    } catch (_) {
      // Keep the local garage available while offline or if the API is down.
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }

  Future<void> _syncSelection(Vehicle vehicle) async {
    try {
      await _repository.select(vehicle);
    } catch (_) {}
  }

  Future<void> _syncRemoval(Vehicle vehicle) async {
    try {
      await _repository.remove(vehicle);
    } catch (_) {}
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

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }
}
