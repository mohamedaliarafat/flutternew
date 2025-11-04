import 'dart:convert';
import 'package:foodly/models/petrol_model.dart';
import 'package:get/get.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;

  /// 🔹 جلب الطلبات الخاصة بالمستخدم
  Future<void> fetchUserOrders(String userId, String token) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$appBaseUrl/api/petrol/user');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        orders.value = (data['orders'] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList();
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('خطأ', error['message'] ?? 'فشل في جلب الطلبات');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 إنشاء طلب جديد
  Future<void> createOrder({
    required String fuelType,
    required double fuelLiters,
    String notes = '',
    required String token,
  }) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$appBaseUrl/api/petrol/create');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fuelType': fuelType,
          'fuelLiters': fuelLiters,
          'notes': notes,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // إضافة الطلب الجديد للقائمة
        orders.insert(0, OrderModel.fromJson(data['order']));
        Get.snackbar('نجاح', 'تم إنشاء الطلب بنجاح');
      } else {
        Get.snackbar('خطأ', data['message'] ?? 'فشل في إنشاء الطلب');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 تحديث حالة الطلب (للأدمن)
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    double? price,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$appBaseUrl/api/orders/$orderId/status');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status, 'price': price}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // تحديث الطلب محليًا
        int index = orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          orders[index] = OrderModel.fromJson(data['order']);
        }
        Get.snackbar('نجاح', 'تم تحديث حالة الطلب');
      } else {
        Get.snackbar('خطأ', data['message'] ?? 'فشل في تحديث الطلب');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }
}
