// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:foodly/constants/constants.dart';
// import 'package:foodly/models/cart_request.dart';
// import 'package:foodly/models/cart_response.dart';
// import 'package:foodly/models/api_error.dart';

// class CartController extends GetxController {
//   final box = GetStorage();

//   // حالة التحميل
//   final RxBool _isLoading = false.obs;
//   bool get isLoading => _isLoading.value;
//   set setLoading(bool value) => _isLoading.value = value;

//   // السلة الحالية
//   Rx<CartResponse?> cart = Rx<CartResponse?>(null);

//   /// 🛒 إضافة منتج للسلة
//  Future<void> addToCart(CartRequest cartRequest) async {
//   setLoading = true;
//   try {
//     final token = box.read("token");
//     if (token == null || token.isEmpty) {
//       // المستخدم غير مسجل دخول → عرض Snackbar مع أيقونة
//       Get.snackbar(
//         "خطأ ❌",
//         "الرجاء تسجيل الدخول لإضافة منتجات إلى السلة",
//         icon: Image.network(
//           "https://www2.0zz0.com/2025/11/02/18/596306472.png", // ضع شعارك أو أيقونتك هنا
//           width: 30,
//           height: 30,
//         ),
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red.shade600,
//         colorText: Colors.white,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       );
//       return; // الخروج من الدالة دون متابعة الطلب
//     }

//     final url = Uri.parse("$appBaseUrl/api/cart");

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(cartRequest.toJson()),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Get.snackbar(
//         "تمت الإضافة ✅",
//         "تمت إضافة المنتج إلى السلة بنجاح",
//         icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
//         colorText: Colors.white,
//         backgroundColor: kBlueDark,
//         snackPosition: SnackPosition.TOP,
//         borderRadius: 12,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       );
//       await fetchCart();
//     } else {
//       final error = apiErrorFromJson(response.body);
//       throw error.message;
//     }
//   } catch (e) {
//     debugPrint("❌ addToCart Error: $e");
//     Get.snackbar(
//       "خطأ",
//       e.toString(),
//       icon: const Icon(Icons.error, color: Colors.white),
//       colorText: Colors.white,
//       backgroundColor: Colors.red,
//       snackPosition: SnackPosition.TOP,
//       borderRadius: 12,
//       margin: const EdgeInsets.all(16),
//       duration: const Duration(seconds: 3),
//     );
//   } finally {
//     setLoading = false;
//   }
// }


//   /// ❌ حذف منتج من السلة
//   Future<void> removeFromCart(String cartItemId, Function() param1) async {
//     try {
//       final token = box.read('token');
//       if (token == null || token.isEmpty) {
//         throw "الرجاء تسجيل الدخول أولاً";
//       }

//       final url = Uri.parse("$appBaseUrl/api/cart/$cartItemId");

//       final response = await http.delete(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         await fetchCart();
//         Get.snackbar("تم", "تم حذف المنتج من السلة بنجاح");
//       } else {
//         Get.snackbar("خطأ", "تعذر حذف المنتج من السلة");
//       }
//     } catch (e) {
//       Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخادم");
//       debugPrint("❌ removeFromCart Error: $e");
//     }
//   }

//   /// 🔄 تحديث كمية المنتج في السلة
//   Future<void> updateQuantity(String cartItemId, int quantity) async {
//     setLoading = true;
//     try {
//       final token = box.read("token");
//       if (token == null || token.isEmpty) {
//         throw "الرجاء تسجيل الدخول لتحديث الكمية";
//       }

//       final url = Uri.parse("$appBaseUrl/api/cart/item/$cartItemId");

//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'quantity': quantity}),
//       );

//       if (response.statusCode == 200) {
//         await fetchCart();
//       } else {
//         final error = apiErrorFromJson(response.body);
//         throw error.message;
//       }
//     } catch (e) {
//       debugPrint("❌ updateQuantity Error: $e");
//       Get.snackbar("خطأ", e.toString(),
//           colorText: Colors.white, backgroundColor: Colors.red);
//     } finally {
//       setLoading = false;
//     }
//   }

//   /// 📦 جلب بيانات السلة من السيرفر
//   Future<void> fetchCart() async {
//     setLoading = true;
//     try {
//       final token = box.read("token");
//       if (token == null || token.isEmpty) {
//         cart.value = null;
//         throw "الرجاء تسجيل الدخول أولاً";
//       }

//       final url = Uri.parse("$appBaseUrl/api/cart");

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final fetchedCart = cartResponseFromJson(response.body);
//         cart.value = fetchedCart;
//       } else {
//         final error = apiErrorFromJson(response.body);
//         throw error.message;
//       }
//     } catch (e) {
//       debugPrint("❌ fetchCart Error: $e");
//       Get.snackbar("خطأ أثناء تحميل السلة", e.toString(),
//           colorText: Colors.white, backgroundColor: Colors.red);
//     } finally {
//       setLoading = false;
//     }
//   }

//   /// 🧹 مسح السلة عند تسجيل الخروج
//   void clearCart() {
//     cart.value = null;
//   }
// }

// extension on Rx<CartResponse?> {
//   void removeWhere(bool Function(dynamic item) param0) {}
// }
