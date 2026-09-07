import 'package:flutter/foundation.dart';

/// The signed-in user. Immutable, hand-written JSON — no code generation, so
/// there is no build step to run before the project compiles.
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.locale,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: '${json['id'] ?? ''}',
    name: (json['name'] ?? json['full_name'] ?? '') as String,
    email: json['email'] as String?,
    phone: (json['phone'] ?? json['mobile_number']) as String?,
    avatarUrl: (json['avatar_url'] ?? json['avatar']) as String?,
    locale: json['locale'] as String?,
  );

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? locale;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'locale': locale,
  };

  /// First letters of the first two words — used by the avatar placeholder.
  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return '?';
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? locale,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    locale: locale ?? this.locale,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.name == name &&
          other.email == email &&
          other.phone == phone &&
          other.avatarUrl == avatarUrl &&
          other.locale == locale;

  @override
  int get hashCode => Object.hash(id, name, email, phone, avatarUrl, locale);
}
