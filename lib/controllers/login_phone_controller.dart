import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/cart_controller.dart';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/login_response.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final box = GetStorage();
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  /// 🔹 إرسال OTP
  Future<void> requestOtp(String phone) async {
    setLoading = true;
    final Uri url = Uri.parse('$appBaseUrl/api/auth/request-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      debugPrint('📩 [requestOtp] Response: ${response.body}');
      setLoading = false;

      if (response.headers['content-type']?.contains('application/json') ?? false) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['success'] == true) {
          Get.snackbar(
            "تم الإرسال ✅",
            data['message'] ?? "تم إرسال رمز التحقق إلى رقمك",
            icon: Image.network(
              'https://d.top4top.io/p_3588wn4ke1.png',
              width: 30,
              height: 30,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: kBlueDark,
            colorText: Colors.white,
          );
        } else {
          final error = ApiError.fromJson(data);
          Get.snackbar("خطأ", error.message,
              colorText: Colors.white, backgroundColor: kRed);
        }
      } else {
        Get.snackbar("خطأ في السيرفر", "الاستجابة غير متوقعة",
            colorText: Colors.white, backgroundColor: kRed);
      }
    } catch (e) {
      setLoading = false;
      debugPrint('❌ [requestOtp] Error: $e');
      Get.snackbar("خطأ في الاتصال", e.toString(),
          colorText: Colors.white, backgroundColor: kRed);
    }
  }

  /// 🔹 تحقق OTP وتسجيل الدخول
  Future<void> verifyOtpAndLogin(String phone, String otp) async {
    setLoading = true;
    final Uri url = Uri.parse('$appBaseUrl/api/auth/verify-otp');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      debugPrint('📩 [verifyOtpAndLogin] Response: ${response.body}');
      setLoading = false;

      if (response.headers['content-type']?.contains('application/json') ?? false) {
        final Map<String, dynamic> resBody = jsonDecode(response.body);

        if (response.statusCode == 200 && resBody['success'] == true) {
          final data = resBody['data'];
          final token = resBody['token'];

          // حفظ بيانات المستخدم + التوكن
          await _saveUserData(data, token);

          // جلب السلة
          final cartController = Get.put(CartController());
          cartController.setLoading = true;
          await cartController.fetchCart();

          Get.snackbar(
            "تم تسجيل الدخول ✅",
            "مرحباً ${data['phone']}",
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

          Future.delayed(const Duration(seconds: 1), () {
            Get.offAll(() => MainScreen(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 900));
          });
        } else {
          final error = ApiError.fromJson(resBody);
          Get.snackbar("فشل العملية ❌", error.message,
              colorText: Colors.white, backgroundColor: kRed);
        }
      } else {
        Get.snackbar("خطأ", "الاستجابة غير متوقعة من السيرفر",
            colorText: Colors.white, backgroundColor: kRed);
      }
    } catch (e) {
      setLoading = false;
      debugPrint('❌ [verifyOtpAndLogin] Exception: $e');
      Get.snackbar("خطأ غير متوقع", e.toString(),
          backgroundColor: kRed, colorText: Colors.white);
    }
  }

  /// 🔹 حفظ بيانات المستخدم + التوكن
  Future<void> _saveUserData(Map<String, dynamic> userData, String token) async {
    await box.write("token", token);
    await box.write("userId", userData['_id']);
    await box.write("phone", userData['phone']);
    await box.write("verification", userData['phoneVerification']);
    await box.write("profile", userData['profile'] ?? "");
    await box.write("userType", userData['userType'] ?? "Client");
    await box.write("createdAt", userData['createdAt']);
    await box.write("updatedAt", userData['updatedAt']);
  }

  /// 🔹 جلب بيانات المستخدم من التخزين المحلي
  Map<String, dynamic>? getUserInfo() {
    try {
      final phone = box.read("phone");
      if (phone == null) return null;

      return {
        "id": box.read("userId") ?? "",
        "phone": phone,
        "phoneVerification": box.read("verification") ?? false,
        "userType": box.read("userType") ?? "Client",
        "profile": box.read("profile") ?? "",
        "createdAt": box.read("createdAt"),
        "updatedAt": box.read("updatedAt"),
      };
    } catch (e) {
      debugPrint('❌ فشل في تحميل بيانات المستخدم: $e');
      return null;
    }
  }

  /// 🔹 تسجيل الخروج
  void logout() {
    box.erase();
    Get.offAll(() => MainScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 900));
  }
}
