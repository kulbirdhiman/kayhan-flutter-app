/// A car saved in the shopper's garage.
class Vehicle {
  const Vehicle({
    required this.makeId,
    required this.makeName,
    required this.modelId,
    required this.modelName,
    this.year,
  });

  final int makeId;
  final String makeName;
  final int modelId;
  final String modelName;
  final int? year;

  String get id => '$makeId-$modelId-${year ?? 'any'}';
  String get label => [if (year != null) '$year', makeName, modelName].join(' ');

  /// Keyword sent to the product search endpoint.
  String get searchQuery => '$makeName $modelName';

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        makeId: json['makeId'] as int,
        makeName: json['makeName'] as String,
        modelId: json['modelId'] as int,
        modelName: json['modelName'] as String,
        year: json['year'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'makeId': makeId,
        'makeName': makeName,
        'modelId': modelId,
        'modelName': modelName,
        'year': year,
      };
}

/// A model (A4, Ranger…) or sub-model under a make.
class CarModel {
  const CarModel({required this.id, required this.name, required this.slug});

  final int id;
  final String name;
  final String slug;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? '').toString().trim(),
        slug: (json['slug'] ?? '').toString(),
      );
}
