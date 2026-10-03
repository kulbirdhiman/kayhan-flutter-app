/// Backend "category". `type == 1` is a car make (Audi, Ford…),
/// `type == 2` is a product category (Speakers, Dash Cams…).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    this.departmentIds = const [],
  });

  final int id;
  final String name;
  final String slug;
  final int type;
  final List<int> departmentIds;

  bool get isCarMake => type == 1;
  bool get isProductType => type == 2;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? '').toString().trim(),
        slug: (json['slug'] ?? '').toString(),
        type: (json['type'] as num?)?.toInt() ?? 0,
        departmentIds: (json['department_ids'] as List?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            const [],
      );
}
