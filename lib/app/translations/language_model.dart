import 'package:flutter/material.dart';

class LanguageModel {
  String code;
  String title;
  Locale locale;
  String? flag;

  LanguageModel({
    required this.code,
    required this.title,
    required this.locale,
    this.flag,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['code'],
      title: json['title'],
      locale: Locale(json['code']),
      flag: json['flag'],
    );
  }
}
