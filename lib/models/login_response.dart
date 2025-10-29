import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  final bool status;
  final String id;
   String username;
  final String email;
  final String? fcm;
  final String? phone;
  final bool verification; // ← كان String، المفروض bool
  final bool phoneVerification;
  final String? userType;
  final String? profile;
  final String? userToken;
  String? address;

  LoginResponse({
    required this.status,
    required this.id,
    required this.username,
    required this.email,
    this.fcm,
    this.phone,
    required this.verification,
    required this.phoneVerification,
    this.userType,
    this.profile,
    this.userToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"] ?? false,
        id: json["_id"] ?? "",
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        fcm: json["fcm"],
        phone: json["phone"],
        verification: json["verification"] is bool
            ? json["verification"]
            : (json["verification"].toString().toLowerCase() == "true"),
        phoneVerification: json["phoneVerification"] ?? false,
        userType: json["userType"],
        profile: json["profile"],
        userToken: json["userToken"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "username": username,
        "email": email,
        "fcm": fcm,
        "phone": phone,
        "verification": verification,
        "phoneVerification": phoneVerification,
        "userType": userType,
        "profile": profile,
        "userToken": userToken,
      };
}
