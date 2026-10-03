import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../catalog/data/catalog_repository.dart';
import '../../catalog/data/models/category.dart';
import 'models/vehicle.dart';

/// Make → model → year lookups for the vehicle selector.
class VehicleRepository {
  VehicleRepository(this._api, this._catalog);

  final ApiClient _api;
  final CatalogRepository _catalog;

  Future<List<Category>> makes() async =>
      (await _catalog.categories()).where((c) => c.isCarMake).toList();

  Future<List<CarModel>> models(Category make) async {
    final data = await _api.get(
      ApiEndpoints.categoryDetail(make.slug),
      query: {if (make.departmentIds.isNotEmpty) 'department_id': make.departmentIds.first},
    );
    final result = data is Map ? data['result'] : null;
    final list = (result is Map ? result['car_models'] : null) as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => CarModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<List<int>> years(int modelId) async {
    final data = await _api.get(ApiEndpoints.carModelYears(modelId));
    final list = (data is Map ? data['result'] : null) as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => int.tryParse('${e['name']}'))
        .whereType<int>()
        .toList()
      ..sort((a, b) => b.compareTo(a));
  }
}
