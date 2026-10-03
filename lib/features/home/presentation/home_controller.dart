import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/load_state.dart';
import '../../catalog/data/catalog_repository.dart';
import '../../catalog/data/models/combo_deal.dart';
import '../../catalog/data/models/department.dart';
import '../../catalog/data/models/product.dart';

typedef ProductGroups = Map<String, List<Product>>;

/// Loads every home section independently so one failing endpoint
/// doesn't blank the whole page.
class HomeController extends ChangeNotifier {
  HomeController(this._repo);

  final CatalogRepository _repo;

  LoadState<List<Department>> departments = const LoadState.idle();
  LoadState<ProductGroups> highlights = const LoadState.idle();
  LoadState<List<Product>> hotDeals = const LoadState.idle();
  LoadState<List<ComboDeal>> comboDeals = const LoadState.idle();
  LoadState<ProductGroups> audio = const LoadState.idle();
  LoadState<ProductGroups> accessories = const LoadState.idle();

  bool _started = false;

  void ensureLoaded() {
    if (_started) return;
    _started = true;
    load();
  }

  Future<void> load() => Future.wait([
        _fetch(_repo.departments, (s) => departments = s, departments),
        _fetch(_repo.weeklyHighlights, (s) => highlights = s, highlights),
        _fetch(_repo.hotDeals, (s) => hotDeals = s, hotDeals),
        _fetch(_repo.comboDeals, (s) => comboDeals = s, comboDeals),
        _fetch(_repo.audioGroups, (s) => audio = s, audio),
        _fetch(_repo.accessoryGroups, (s) => accessories = s, accessories),
      ]);

  Future<void> _fetch<T>(
    Future<T> Function() request,
    void Function(LoadState<T>) assign,
    LoadState<T> current,
  ) async {
    assign(LoadState.loading(current.data));
    notifyListeners();
    try {
      assign(LoadState.success(await request()));
    } catch (e) {
      assign(LoadState.failure(ApiException.from(e).message, current.data));
    }
    notifyListeners();
  }
}
