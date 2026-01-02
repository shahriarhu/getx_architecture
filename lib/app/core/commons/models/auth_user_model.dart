class AuthUserModel {
  String? name;
  String? mobileNumber;
  String? accessToken;
  String? refreshToken;
  DateTime? accessExpiry;
  String? email;
  int? shopCount;
  String? language;

  AuthUserModel({
    this.name,
    this.mobileNumber,
    this.accessToken,
    this.refreshToken,
    this.accessExpiry,
    this.email,
    this.shopCount,
    this.language,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        accessToken: json["access_token"] ?? json["token"], // backward compat
        refreshToken: json["refresh_token"],
        accessExpiry: json["access_expiry"] != null ? DateTime.fromMillisecondsSinceEpoch(json["access_expiry"]) : null,
        email: json["email"],
        shopCount: json["shop_count"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "email": email,
        "shop_count": shopCount,
        "language": language,

        // ❌ Do NOT persist tokens here anymore
      };
}
