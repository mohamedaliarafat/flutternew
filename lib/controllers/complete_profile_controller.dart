import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/complete_profile_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class CompleteProfileController extends GetxController {
  final String baseUrl = appBaseUrl;
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  /// 🔹 رفع المستندات والإيميل للعميل
  Future<bool> uploadDocuments({
    required String userId,
    required String email,
    required Map<String, File> documents, required String token,
  }) async {
    setLoading = true;
    try {
      var uri = Uri.parse("$baseUrl/api/company-profile/complete-profile");
      var request = http.MultipartRequest('POST', uri);
      request.fields['userId'] = userId;
      request.fields['email'] = email;

      documents.forEach((key, file) {
        if (file.existsSync()) {
          request.files.add(http.MultipartFile(
            key,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split("/").last,
          ));
        }
      });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      setLoading = false;

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar("نجاح ✅", data['message'],
            colorText: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFF1A759F));
        return true;
      } else {
        Get.snackbar("خطأ ❌", data['message'] ?? "حدث خطأ",
            colorText: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFFE74C3C));
        return false;
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar("خطأ ⚠️", "فشل في رفع البيانات: $e",
          colorText: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFFE74C3C));
      return false;
    }
  }

  /// 🔹 جلب بيانات ملف العميل الشخصي
  Future<CompleteProfileResponse?> getProfileClient(String userId) async {
    setLoading = true;
    try {
      var uri = Uri.parse("$baseUrl/api/company-profile/profile/$userId");
      var response = await http.get(uri);
      setLoading = false;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return CompleteProfileResponse.fromJson(data);
      } else {
        Get.snackbar("خطأ ❌", "فشل في جلب البيانات",
            colorText: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFFE74C3C));
        return null;
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar("خطأ ⚠️", "فشل في جلب البيانات: $e",
          colorText: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFFE74C3C));
      return null;
    }
  }

  /// 🔹 جلب كل ملفات العملاء للأدمين
  Future<List<CompleteProfileResponse>> getProfilesAdmin() async {
    setLoading = true;
    try {
      var uri = Uri.parse("$baseUrl/api/company-profile/all-profiles");
      var response = await http.get(uri);
      setLoading = false;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        return data
            .map((item) => CompleteProfileResponse.fromJson(item))
            .toList();
      } else {
        Get.snackbar("خطأ ❌", "فشل في جلب البيانات",
            colorText: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFFE74C3C));
        return [];
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar("خطأ ⚠️", "فشل في جلب البيانات: $e",
          colorText: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFFE74C3C));
      return [];
    }
  }
}
