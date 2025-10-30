import 'package:foodly/models/cart_response.dart';
import 'package:foodly/models/login_phone_model.dart';

class LoginResponse {
  final bool success;
  final String message;
  final User? user;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        user: json['user'] != null ? User.fromJson(json['user']) : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'user': user?.toJson(),
      };
}
