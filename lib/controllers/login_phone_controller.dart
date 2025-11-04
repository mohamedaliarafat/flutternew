import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/notificationsController.dart' hide appBaseUrl;
import 'package:foodly/models/api_error.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// 🟦 AuthController مسؤول عن تسجيل الدخول بالهاتف + OTP وتخزين المستخدم في MongoDB
class AuthController extends GetxController {
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  String? _userId;
  String? _phone;
  String? _token;
  String? _userType;
  String? _profile;
  bool _profileCompleted = false;

  /// 🔹 التحقق إن المستخدم مسجل دخول
  bool get isLoggedIn =>
      _userId != null && _userId!.isNotEmpty && _phone != null && _phone!.isNotEmpty;

  /// 🔹 معرفة إذا أنهى المستخدم ملفه الشخصي
  bool get isProfileCompleted => _profileCompleted;

  /// 🔹 تحديث حالة اكتمال الملف الشخصي
  void setProfileCompleted(bool value) {
    _profileCompleted = value;
  }

  /// 🔹 الحصول على صلاحيات المستخدم (headers)
  Map<String, String>? getUserAuthHeaders() {
    if (_token == null || _token!.isEmpty || _userId == null || _userId!.isEmpty) return null;
    return {
      "Authorization": "Bearer $_token",
      "UserId": _userId!,
    };
  }

  /// 🔹 إرسال OTP
  Future<void> requestOtp(String phone) async {
    setLoading = true;

    try {
      final response = await http.post(
        Uri.parse('$appBaseUrl/api/auth/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      setLoading = false;
      debugPrint("📩 [requestOtp] ${response.body}");

      if (!_isJson(response)) {
        _showError("الاستجابة غير متوقعة من السيرفر");
        return;
      }

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        _showSuccess("تم إرسال رمز التحقق", data['message']);
      } else {
        final error = ApiError.fromJson(data);
        _showError(error.message);
      }
    } catch (e) {
      setLoading = false;
      debugPrint('❌ [requestOtp] Error: $e');
      _showError("حدث خطأ أثناء الإرسال، حاول مرة أخرى");
    }
  }

  /// 🔹 تحقق OTP وتسجيل الدخول
  Future<void> verifyOtpAndLogin(String phone, String otp) async {
    setLoading = true;

    try {
      final response = await http.post(
        Uri.parse('$appBaseUrl/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      setLoading = false;
      debugPrint('📩 [verifyOtpAndLogin] ${response.body}');

      if (!_isJson(response)) {
        _showError("الاستجابة غير متوقعة من السيرفر");
        return;
      }

      final resBody = jsonDecode(response.body);
      if (response.statusCode == 200 && resBody['success'] == true) {
        final data = resBody['data'];
        final token = resBody['token'];

        // حفظ بيانات المستخدم في MongoDB
        await _saveUserToServer(
          data['_id'], data['phone'], token, data['userType'], data['profile']
        );

        // تحديث المتغيرات المحلية
        _userId = data['_id'];
        _phone = data['phone'];
        _token = token;
        _userType = data['userType'] ?? "Client";
        _profile = data['profile'] ?? "";
        _profileCompleted = data['profileCompleted'] ?? false;

        // 🔔 جلب إشعارات المستخدم مرتبطه بالـ userId
        final notificationController = Get.put(NotificationController());
        await notificationController.fetchNotifications(_userId!, _token!);

        _showSuccess("تم تسجيل الدخول ✅", "مرحباً ${data['phone']}");

        // 🚀 الانتقال إلى الصفحة الرئيسية
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(() => MainScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 900));
        });
      } else {
        final error = ApiError.fromJson(resBody);
        _showError(error.message);
      }
    } catch (e) {
      setLoading = false;
      debugPrint('❌ [verifyOtpAndLogin] Exception: $e');
      _showError("حدث خطأ غير متوقع أثناء تسجيل الدخول");
    }
  }

  /// 🔹 حفظ بيانات المستخدم في MongoDB
  Future<void> _saveUserToServer(
      String userId, String phone, String token, String? userType, String? profile) async {
    try {
      final response = await http.post(
        Uri.parse('$appBaseUrl/api/users/save'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          "userId": userId,
          "phone": phone,
          "phoneVerification": true,
          "userType": userType ?? "Client",
          "profile": profile ?? "",
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ [MongoDB] بيانات المستخدم مخزنة بنجاح");
      } else {
        debugPrint("❌ [MongoDB] فشل في حفظ بيانات المستخدم: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ [MongoDB] Exception أثناء حفظ المستخدم: $e");
    }
  }

  /// 🔹 جلب بيانات المستخدم
  Map<String, dynamic>? getUserInfo() {
    if (_userId == null || _userId!.isEmpty || _phone == null || _phone!.isEmpty) return null;

    return {
      "id": _userId,
      "phone": _phone,
      "phoneVerification": true,
      "userType": _userType ?? "Client",
      "profile": _profile ?? "",
      "profileCompleted": _profileCompleted,
    };
  }

  /// 🔹 تسجيل الخروج
  void logout() {
    _userId = null;
    _phone = null;
    _token = null;
    _userType = null;
    _profile = null;
    _profileCompleted = false;

    Get.offAll(() => MainScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 900));
  }

  // 🧩 أدوات مساعدة
  bool _isJson(http.Response res) =>
      res.headers['content-type']?.contains('application/json') ?? false;

  void _showError(String message) {
    Get.snackbar("خطأ", message,
        colorText: Colors.white, backgroundColor: kRed);
  }

  void _showSuccess(String title, String? message) {
    Get.snackbar(
      title,
      message ?? "",
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
  }
}
