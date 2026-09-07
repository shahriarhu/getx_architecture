import 'package:flutter/foundation.dart';

/// Credentials for the current session. Deliberately separate from the user
/// profile so tokens only ever live in secure storage.
@immutable
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiry,
  });

  factory AuthTokens.fromJson(
    Map<String, dynamic> json, {
    String? fallbackRefresh,
  }) {
    final expiresIn = json['expires_in'];
    return AuthTokens(
      accessToken: (json['access_token'] ?? json['token'] ?? '') as String,
      refreshToken: (json['refresh_token'] as String?) ?? fallbackRefresh ?? '',
      accessExpiry:
          expiresIn is num
              ? DateTime.now().add(Duration(seconds: expiresIn.toInt()))
              : DateTime.now().add(const Duration(hours: 1)),
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiry;

  bool get isValid => accessToken.isNotEmpty;

  bool get canRefresh => refreshToken.isNotEmpty;

  /// True when the access token is expired or about to be, so callers can
  /// refresh proactively instead of eating a 401.
  bool isExpiringWithin(Duration buffer) =>
      DateTime.now().isAfter(accessExpiry.subtract(buffer));

  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? accessExpiry,
  }) => AuthTokens(
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    accessExpiry: accessExpiry ?? this.accessExpiry,
  );
}
