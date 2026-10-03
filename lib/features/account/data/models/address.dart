import '../../../../core/config/store_config.dart';

class Address {
  const Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.line1,
    required this.suburb,
    required this.state,
    required this.postcode,
    this.line2 = '',
    this.country = StoreConfig.country,
    this.isDefault = false,
  });

  final String id;
  final String fullName;
  final String phone;
  final String line1;
  final String line2;
  final String suburb;
  final String state;
  final String postcode;
  final String country;
  final bool isDefault;

  String get singleLine => [line1, if (line2.isNotEmpty) line2, '$suburb $state $postcode'].join(', ');

  Address copyWith({bool? isDefault}) => Address(
        id: id,
        fullName: fullName,
        phone: phone,
        line1: line1,
        line2: line2,
        suburb: suburb,
        state: state,
        postcode: postcode,
        country: country,
        isDefault: isDefault ?? this.isDefault,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        line1: json['line1'] as String,
        line2: (json['line2'] ?? '') as String,
        suburb: json['suburb'] as String,
        state: json['state'] as String,
        postcode: json['postcode'] as String,
        country: (json['country'] ?? StoreConfig.country) as String,
        isDefault: (json['isDefault'] ?? false) as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phone': phone,
        'line1': line1,
        'line2': line2,
        'suburb': suburb,
        'state': state,
        'postcode': postcode,
        'country': country,
        'isDefault': isDefault,
      };
}
