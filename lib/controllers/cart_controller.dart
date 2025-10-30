import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/cart_request.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:foodly/models/api_error.dart';

class CartController extends GetxController {
  final box = GetStorage();

  /// حالة التحميل
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  /// قائمة السلة
  RxList<CartResponse> cartItems = <CartResponse>[].obs;

  /// 🛒 إضافة منتج للسلة
  Future<void> addToCart(CartRequest cart) async {
    setLoading = true;
    try {
      final token = box.read<String>("token");
      if (token == null || token.isEmpty) {
        throw "الرجاء تسجيل الدخول لإضافة منتجات إلى السلة";
      }

      final url = Uri.parse("$appBaseUrl/api/cart");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode(cart.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("تمت الإضافة للسلة", "تمت إضافة المنتج بنجاح",
            colorText: Colors.white, backgroundColor: kBlueDark);
        await fetchCart();
      } else {
        final error = apiErrorFromJson(response.body);
        throw error.message;
      }
    } catch (e) {
      debugPrint("❌ addToCart Error: $e");
      Get.snackbar("خطأ", e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      setLoading = false;
    }
  }

  /// ❌ حذف منتج من السلة
  Future<void> removeFromCart(String productId, Function() param1) async {
    setLoading = true;
    try {
      final token = box.read<String>("token");
      if (token == null || token.isEmpty) {
        throw "الرجاء تسجيل الدخول لإدارة السلة";
      }

      final url = Uri.parse("$appBaseUrl/api/cart/$productId");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        Get.snackbar("تم الحذف", "تمت إزالة المنتج من السلة 🛒",
            colorText: Colors.white, backgroundColor: kBlueDark);
        await fetchCart();
      } else {
        final error = apiErrorFromJson(response.body);
        throw error.message;
      }
    } catch (e) {
      debugPrint("❌ removeFromCart Error: $e");
      Get.snackbar("خطأ", e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      setLoading = false;
    }
  }

  /// تحديث كمية المنتج
  Future<void> updateQuantity(String cartId, int quantity) async {
    setLoading = true;
    try {
      final token = box.read<String>("token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("$appBaseUrl/api/cart/$cartId");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({'quantity': quantity});

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        await fetchCart();
      } else {
        final error = apiErrorFromJson(response.body);
        throw error.message;
      }
    } catch (e) {
      debugPrint("❌ updateQuantity Error: $e");
      Get.snackbar("خطأ", e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      setLoading = false;
    }
  }

  /// جلب بيانات السلة من السيرفر
  Future<void> fetchCart() async {
    setLoading = true;
    try {
      final token = box.read<String>("token");
      if (token == null || token.isEmpty) {
        cartItems.clear();
        return;
      }

      final url = Uri.parse("$appBaseUrl/api/cart");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final carts = cartResponseFromJson(response.body);
        cartItems.assignAll(carts);
      } else {
        final error = apiErrorFromJson(response.body);
        throw error.message;
      }
    } catch (e) {
      debugPrint("❌ fetchCart Error: $e");
      Get.snackbar("خطأ", e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      setLoading = false;
    }
  }
}
