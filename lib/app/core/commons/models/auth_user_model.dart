import 'dart:convert';

AuthUserModel authUserModelFromJson(String str) => AuthUserModel.fromJson(json.decode(str));

String authUserModelToJson(AuthUserModel data) => json.encode(data.toJson());

class AuthUserModel {
  String? name;
  String? mobileNumber;
  String? token;
  String? email;
  int? shopCount;
  String? language;

  AuthUserModel({
    this.name,
    this.mobileNumber,
    this.token,
    this.email,
    this.shopCount,
    this.language,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        token: json["token"],
        email: json["email"],
        shopCount: json["shop_count"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "token": token,
        "email": email,
        "shop_count": shopCount,
        "language": language,
      };
}
