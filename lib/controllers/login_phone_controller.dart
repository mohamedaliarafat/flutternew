import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/login_phone_model.dart';
import '../models/api_error.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  /// إرسال OTP
  Future<void> requestOtp(String phone) async {
    setLoading = true;

    Uri url = Uri.parse('$appBaseUrl/api/auth/request-otp');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, String> body = {'phone': phone};

    try {
      var response = await http.post(url, headers: headers, body: jsonEncode(body));
      setLoading = false;

      if (response.headers['content-type'] != null &&
          response.headers['content-type']!.contains('application/json')) {
        if (response.statusCode == 200) {
          Get.snackbar(
            "نجاح",
            "تم ارسال رمز التحقق",
            icon: Image.network(
              'https://d.top4top.io/p_3588wn4ke1.png',
              width: 30,
              height: 30,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: kBlueDark,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
          );
        } else {
          var error = apiErrorFromJson(response.body);
          Get.snackbar(
            "فشل",
            error.message,
            colorText: Colors.white,
            backgroundColor: kRed,
          );
        }
      } else {
        Get.snackbar(
          "خطأ",
          "السيرفر أعاد استجابة غير متوقعة",
          colorText: Colors.white,
          backgroundColor: kRed,
        );
      }
    } catch (e) {
      setLoading = false;
      debugPrint(e.toString());
      Get.snackbar(
        "خطأ",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: kRed,
      );
    }
  }

  /// التحقق من OTP وتسجيل الدخول
  Future<void> verifyOtpAndNavigate(String phone, String otp) async {
    setLoading = true;

    Uri url = Uri.parse('$appBaseUrl/api/auth/verify-otp'); 
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Map<String, String> body = {'phone': phone, 'otp': otp};

    try {
      var response = await http.post(url, headers: headers, body: jsonEncode(body));
      setLoading = false;

      if (response.headers['content-type'] != null &&
          response.headers['content-type']!.contains('application/json') &&
          response.statusCode == 200) {

        var data = jsonDecode(response.body)['user'];
        User user = User.fromJson(data);

        // تخزين بيانات المستخدم كاملة
        box.write("userId", user.id);
        box.write(user.id, jsonEncode(data));
        box.write("phone", user.phone);
        box.write("verification", user.phoneVerification);

        // اظهار Snackbar باللوجو والترحيب
        Get.snackbar(
          "نجاح",
          "مرحباً بك ${user ?? ''}",
          icon: Image.network(
            'https://d.top4top.io/p_3588wn4ke1.png',
            width: 30,
            height: 30,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: kBlueDark,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        // الانتقال للصفحة الرئيسية بعد تخزين البيانات
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(() => MainScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 900),
          );
        });

      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar(
          "فشل",
          error.message,
          colorText: Colors.white,
          backgroundColor: kRed,
        );
      }
    } catch (e) {
      setLoading = false;
      debugPrint(e.toString());
      Get.snackbar(
        "خطأ",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: kRed,
      );
    }
  }

  /// الحصول على بيانات المستخدم من التخزين المحلي
  User? getUserInfo() {
    String? userId = box.read("userId");
    if (userId != null) {
      String? data = box.read(userId);
      if (data != null) {
        try {
          return User.fromJson(jsonDecode(data));
        } catch (e) {
          debugPrint('Failed to parse user data: $e');
          return null;
        }
      }
    }
    return null;
  }

  /// تسجيل الخروج
  void logout() {
    box.erase();
    Get.offAll(() => MainScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 900),
    );
  }
}
