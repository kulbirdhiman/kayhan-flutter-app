class Paged<T> {
  const Paged({required this.items, required this.page, required this.totalPages, this.totalItems});

  final List<T> items;
  final int page;
  final int totalPages;
  final int? totalItems;

  bool get hasMore => page < totalPages;
}
