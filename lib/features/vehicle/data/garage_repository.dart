import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import 'models/vehicle.dart';

/// API persistence for the signed-in customer's saved vehicles.
class GarageRepository {
  GarageRepository(this._api);

  final ApiClient _api;

  Future<List<Vehicle>> list() async {
    final data = await _api.get(ApiEndpoints.garageVehicles);
    final result = data is Map ? data['result'] : null;
    return (result is List ? result : const [])
        .whereType<Map>()
        .map((row) => Vehicle.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<Vehicle> save(Vehicle vehicle, {required bool selected}) async {
    final data = await _api.post(ApiEndpoints.garageVehicles, body: {
      'make_id': vehicle.makeId,
      'make_name': vehicle.makeName,
      'model_id': vehicle.modelId,
      'model_name': vehicle.modelName,
      'year': vehicle.year,
      'is_selected': selected,
    });
    final row = data is Map ? data['result'] : null;
    return row is Map
        ? Vehicle.fromJson(Map<String, dynamic>.from(row))
        : vehicle;
  }

  Future<void> select(Vehicle vehicle) async {
    if (vehicle.recordId == null) return;
    await _api.patch(ApiEndpoints.garageVehicleSelect(vehicle.recordId!));
  }

  Future<void> remove(Vehicle vehicle) async {
    if (vehicle.recordId == null) return;
    await _api.delete(ApiEndpoints.garageVehicleDelete(vehicle.recordId!));
  }
}
