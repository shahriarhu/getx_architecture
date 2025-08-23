class ResponseModel<T> {
  int? code;
  bool? success;
  T? data;
  String? message;
  List<ValidationError>? errors;

  ResponseModel({
    this.code,
    this.success,
    this.data,
    this.message,
    this.errors,
  });

  factory ResponseModel.fromJson({
    required Map<String, dynamic> json,
    required T Function(dynamic data) fromJsonData,
  }) {
    return ResponseModel<T>(
      code: json["code"],
      success: json["success"],
      data: json["data"] != null ? fromJsonData(json["data"]) : null,
      message: json["message"],
      errors: json["errors"] == null
          ? []
          : List<ValidationError>.from(json["errors"]!.map((x) => ValidationError.fromJson(x))),
    );
  }
}

class ValidationError {
  String? message;

  ValidationError({
    this.message,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) => ValidationError(
        message: json["message"],
      );
}
