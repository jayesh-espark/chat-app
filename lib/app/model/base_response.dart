class BaseResponseModel<T> {
  final bool success;
  final String message;
  final T? data;

  BaseResponseModel({required this.success, required this.message, this.data});

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponseModel<T>(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
    };
  }
}
