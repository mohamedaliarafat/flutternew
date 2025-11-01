import 'dart:convert';

/// 🟢 LoginResponse يمثل الاستجابة عند تسجيل الدخول أو التحقق من OTP
class LoginResponse {
  final bool success;
  final String message;
  final User data;
  final String token;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: User.fromJson(json['data']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
        'token': token,
      };
}

/// 🟢 User يمثل بيانات المستخدم
class User {
  final String id;
  final String phone;
  final bool phoneVerification;
  final String userType;
  final String profile;
  final List<dynamic> addresses; // يمكن تغييره لاحقًا لنوع Address
  final String? defaultAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.phone,
    required this.phoneVerification,
    required this.userType,
    required this.profile,
    required this.addresses,
    required this.defaultAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      phoneVerification: json['phoneVerification'] ?? false,
      userType: json['userType'] ?? 'Client',
      profile: json['profile'] ?? '',
      addresses: json['addresses'] ?? [],
      defaultAddress: json['defaultAddress'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'phone': phone,
        'phoneVerification': phoneVerification,
        'userType': userType,
        'profile': profile,
        'addresses': addresses,
        'defaultAddress': defaultAddress,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

/// 🟢 دوال مساعدة لتحويل JSON
LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
