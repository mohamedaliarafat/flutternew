import 'dart:convert';

/// 🟢 LoginResponse يمثل استجابة السيرفر عند التحقق من OTP أو تسجيل الدخول
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
      data: User.fromJson(json['data'] ?? {}),
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

/// 🟢 User يمثل بيانات المستخدم بعد تسجيل الدخول
class User {
  final String id;
  final String phone;
  final bool phoneVerification;
  final String userType;
  final String profile;
  final bool profileCompleted;
  final List<Address> addresses;
  final List<AppNotification> notifications; // ✅ إشعارات المستخدم
  final String? defaultAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.phone,
    required this.phoneVerification,
    required this.userType,
    required this.profile,
    required this.profileCompleted,
    required this.addresses,
    required this.notifications,
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
      profileCompleted: json['profileCompleted'] ?? false,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) => AppNotification.fromJson(e))
              .toList() ??
          [],
      defaultAddress: json['defaultAddress'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'phone': phone,
        'phoneVerification': phoneVerification,
        'userType': userType,
        'profile': profile,
        'profileCompleted': profileCompleted,
        'addresses': addresses.map((e) => e.toJson()).toList(),
        'notifications': notifications.map((e) => e.toJson()).toList(),
        'defaultAddress': defaultAddress,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

/// 🟢 Address يمثل عنوان المستخدم
class Address {
  final String? id;
  final String? city;
  final String? area;
  final String? street;
  final String? details;
  final double? lat;
  final double? lng;

  Address({
    this.id,
    this.city,
    this.area,
    this.street,
    this.details,
    this.lat,
    this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'],
      city: json['city'],
      area: json['area'],
      street: json['street'],
      details: json['details'],
      lat: (json['lat'] is num) ? (json['lat'] as num).toDouble() : null,
      lng: (json['lng'] is num) ? (json['lng'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'city': city,
        'area': area,
        'street': street,
        'details': details,
        'lat': lat,
        'lng': lng,
      };
}

/// 🟢 AppNotification يمثل إشعار خاص بالمستخدم
class AppNotification {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'body': body,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// 🟢 دوال مساعدة لتحويل JSON
LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
