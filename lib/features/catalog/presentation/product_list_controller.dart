import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../data/catalog_repository.dart';
import '../data/models/product.dart';

/// Paginated product listing for one search query.
class ProductListController extends ChangeNotifier {
  ProductListController(this._repo, {String? query}) : _query = query;

  final CatalogRepository _repo;
  String? _query;

  final List<Product> _items = [];
  int _page = 0;
  bool _hasMore = true;
  bool _loading = false;
  int? _total;
  String? _error;
  int _requestId = 0;

  List<Product> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  bool get isInitialLoading => _loading && _items.isEmpty;
  bool get hasMore => _hasMore;
  int? get total => _total;
  String? get error => _error;
  String? get query => _query;

  Future<void> refresh({String? query}) async {
    if (query != null) _query = query;
    _items.clear();
    _page = 0;
    _hasMore = true;
    _total = null;
    _error = null;
    _loading = false;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (_loading || !_hasMore) return;
    _loading = true;
    _error = null;
    final requestId = ++_requestId;
    notifyListeners();

    try {
      final result = await _repo.searchProducts(query: _query, page: _page + 1);
      if (requestId != _requestId) return; // a newer search superseded this one
      _items.addAll(result.items);
      _page = result.page;
      _total = result.totalItems;
      _hasMore = result.hasMore && result.items.isNotEmpty;
    } catch (e) {
      if (requestId != _requestId) return;
      _error = ApiException.from(e).message;
    } finally {
      if (requestId == _requestId) {
        _loading = false;
        notifyListeners();
      }
    }
  }
}
