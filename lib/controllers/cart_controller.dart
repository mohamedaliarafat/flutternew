import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/cart_request.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  final box = GetStorage();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  /// 🛒 إضافة منتج للسلة
  Future<void> addToCart(CartRequest cart) async {
    setLoading = true;

    String? accessToken = box.read("token");
    if (accessToken == null || accessToken.isEmpty) {
      setLoading = false;
      Get.snackbar(
        "خطأ",
        "الرجاء تسجيل الدخول لإضافة منتجات إلى السلة",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    var url = Uri.parse("$appBaseUrl/api/cart");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var body = jsonEncode(cart.toJson());
      debugPrint("🟢 Sending to Cart API: $body");

      var response = await http.post(url, headers: headers, body: body);
      debugPrint("📦 Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "تمت الإضافة للسلة",
          "استمتع بتجربتك",
          colorText: Colors.white,
          backgroundColor: kBlueDark,
          icon: Icon(
            AntDesign.shoppingcart,
          )
        );
      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar(
          "خطأ",
          error.message,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("❌ Error addToCart: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الاتصال بالسيرفر",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      setLoading = false;
    }
  }

  /// ❌ حذف منتج من السلة
  void removeFromCart(String productId, Function refetch) async {
    setLoading = true;
    String? accessToken = box.read("token");

    if (accessToken == null || accessToken.isEmpty) {
      setLoading = false;
      Get.snackbar(
        "خطأ",
        "الرجاء تسجيل الدخول لإدارة السلة",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    var url = Uri.parse("$appBaseUrl/api/cart/$productId");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await http.delete(url, headers: headers);
      debugPrint("🟡 Remove Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        setLoading = false;

        refetch();

        Get.snackbar(
          "تم الحذف",
          "تمت إزالة المنتج من السلة 🛒",
          colorText: kLightWhite,
          backgroundColor: kBlueDark,
          icon: Icon(
            Icons.check_circle_outline,
          )
        );
      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar(
          "خطأ",
          error.message,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("❌ Error removeFromCart: $e");
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الحذف",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: kLightWhite,
        )
      );
    } finally {
      setLoading = false;
    }
  }

  void updateQuantity(String id, int i, Function() param2) {}
}
