class User {
  const User({
    required this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.phone,
  });

  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;

  String get displayName {
    final full = '$firstName $lastName'.trim();
    return full.isEmpty ? email.split('@').first : full;
  }

  String get initials {
    final parts = displayName.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString().trim();
    final nameParts = name.split(' ');
    return User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: (json['email'] ?? '').toString(),
      firstName: (json['first_name'] ?? json['firstName'] ?? (nameParts.isNotEmpty ? nameParts.first : '')).toString(),
      lastName: (json['last_name'] ?? json['lastName'] ?? (nameParts.length > 1 ? nameParts.skip(1).join(' ') : ''))
          .toString(),
      phone: (json['phone'] ?? json['phone_number'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      };
}
