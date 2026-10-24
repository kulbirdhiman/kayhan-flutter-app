/// A car saved in the shopper's garage.
class Vehicle {
  const Vehicle({
    required this.makeId,
    required this.makeName,
    required this.modelId,
    required this.modelName,
    this.year,
    this.recordId,
    this.isSelected = false,
  });

  final int makeId;
  final String makeName;
  final int modelId;
  final String modelName;
  final int? year;
  final int? recordId;
  final bool isSelected;

  String get id => '$makeId-$modelId-${year ?? 'any'}';
  String get label => [if (year != null) '$year', makeName, modelName].join(' ');

  /// Keyword sent to the product search endpoint.
  String get searchQuery => '$makeName $modelName';

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        makeId: int.tryParse('${json['make_id'] ?? json['makeId'] ?? 0}') ?? 0,
        makeName: (json['make_name'] ?? json['makeName'] ?? '').toString(),
        modelId: int.tryParse('${json['model_id'] ?? json['modelId'] ?? 0}') ?? 0,
        modelName: (json['model_name'] ?? json['modelName'] ?? '').toString(),
        year: (json['year'] as num?)?.toInt(),
        recordId: (json['id'] as num?)?.toInt() ?? (json['recordId'] as num?)?.toInt(),
        isSelected: json['is_selected'] == true || json['isSelected'] == true,
      );

  Map<String, dynamic> toJson() => {
        'makeId': makeId,
        'makeName': makeName,
        'modelId': modelId,
        'modelName': modelName,
        'year': year,
        'recordId': recordId,
        'isSelected': isSelected,
      };

  Vehicle copyWith({int? recordId, bool? isSelected}) => Vehicle(
        makeId: makeId,
        makeName: makeName,
        modelId: modelId,
        modelName: modelName,
        year: year,
        recordId: recordId ?? this.recordId,
        isSelected: isSelected ?? this.isSelected,
      );
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
