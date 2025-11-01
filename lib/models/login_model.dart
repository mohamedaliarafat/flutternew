import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    String phone;
    String otp;

    LoginModel({
        required this.phone,
        required this.otp,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        phone: json["phone"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "otp": otp,
    };
}
