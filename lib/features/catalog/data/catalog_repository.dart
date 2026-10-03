import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import 'models/category.dart';
import 'models/combo_deal.dart';
import 'models/department.dart';
import 'models/paged.dart';
import 'models/product.dart';

class CatalogRepository {
  CatalogRepository(this._api);

  final ApiClient _api;

  List<Department>? _departmentsCache;
  List<Category>? _categoriesCache;

  // ---- Products -----------------------------------------------------------

  Future<Paged<Product>> searchProducts({
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    final data = await _api.get(ApiEndpoints.shopProducts, query: {
      'page': page,
      'limit': limit,
      if (query != null && query.trim().isNotEmpty) 'search': query.trim(),
    });
    final items = _productList(data is Map ? data['result'] : null);
    return Paged(
      items: items,
      page: page,
      totalPages: (data is Map ? int.tryParse('${data['totalPage']}') : null) ?? page,
      totalItems: data is Map ? int.tryParse('${data['totalRecords']}') : null,
    );
  }

  Future<Product> productBySlug(String slug) async {
    final data = await _api.get(ApiEndpoints.productDetail(slug));
    return Product.fromJson(Map<String, dynamic>.from(data['result'] as Map));
  }

  Future<Map<String, List<Product>>> weeklyHighlights() => _homeGroups(ApiEndpoints.weeklyHighlights, const {
        'android': 'Android stereos',
        'car_play': 'CarPlay modules',
        'linux': 'Linux head units',
      });

  Future<List<Product>> hotDeals() => _homeList(ApiEndpoints.hotDeals);

  /// Car audio rails: amplifiers, speakers, subwoofers, sub boxes.
  Future<Map<String, List<Product>>> audioGroups() => _homeGroups(ApiEndpoints.audioProducts, const {
        'amplifier': 'Amplifiers',
        'speakers': 'Speakers',
        'subBoofers': 'Subwoofers',
        'subBooferBox': 'Sub boxes',
      });

  /// Accessory rails: fascias, wiring, batteries, other accessories.
  Future<Map<String, List<Product>>> accessoryGroups() => _homeGroups(ApiEndpoints.accessoryProducts, const {
        'frames_and_fascia': 'Fascias',
        'wiring_harness': 'Wiring',
        'batteries': 'Batteries',
        'acessories': 'Accessories',
      });

  Future<List<ComboDeal>> comboDeals() async {
    final data = await _api.get(ApiEndpoints.comboDeals);
    final list = data is List ? data : const [];
    return list.whereType<Map>().map((e) => ComboDeal.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // ---- Taxonomy -----------------------------------------------------------

  Future<List<Department>> departments() async {
    if (_departmentsCache != null) return _departmentsCache!;
    final data = await _api.get(ApiEndpoints.departments);
    final list = (data is Map ? data['result'] : null) as List? ?? const [];
    final departments = list
        .whereType<Map>()
        .where((e) => e['is_view'] == 1)
        .map((e) => Department.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return _departmentsCache = departments;
  }

  Future<List<Category>> categories() async {
    if (_categoriesCache != null) return _categoriesCache!;
    final data = await _api.get(ApiEndpoints.categories);
    final list = (data is Map ? data['result'] : null) as List? ?? const [];
    final categories = list
        .whereType<Map>()
        .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return _categoriesCache = categories;
  }

  // ---- Helpers ------------------------------------------------------------

  /// Home endpoints that return `{ key: { data: [...] } }`. Returns
  /// `label → products` in [labels] order, skipping empty groups.
  Future<Map<String, List<Product>>> _homeGroups(String path, Map<String, String> labels) async {
    final data = await _api.get(path);
    final result = data is Map ? data['result'] : null;
    final groups = <String, List<Product>>{};
    for (final entry in labels.entries) {
      final group = result is Map ? result[entry.key] : null;
      final products = _productList(group is Map ? group['data'] : null);
      if (products.isNotEmpty) groups[entry.value] = products.take(12).toList();
    }
    return groups;
  }

  Future<List<Product>> _homeList(String path) async {
    final data = await _api.get(path);
    return _productList(data is Map ? data['result'] : data);
  }

  List<Product> _productList(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .where((p) => p.slug.isNotEmpty)
        .toList();
  }
}
