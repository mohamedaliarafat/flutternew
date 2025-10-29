import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/order_model.dart';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/hook_models/hook_result.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

/// Hook لجلب الطلبات الحالية أو السابقة
FetchHook useFetchOrders({required bool currentOrders}) {
  final box = GetStorage();

  // State للبيانات والحالة
  final orders = useState<List<OrdersModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  /// fetchData بشكل منفصل لتجنب loop
  Future<void> fetchData() async {
    // إذا البيانات موجودة مسبقًا ولا نريد refetch، نتجاهل
    if (orders.value != null && !isLoading.value) return;

    final token = box.read("accessToken");
    if (token == null) {
      error.value = Exception("لم يتم تسجيل الدخول بعد");
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final endpoint = currentOrders ? "user/current" : "user/past";
    final url = Uri.parse("$appBaseUrl/api/orders/$endpoint");

    isLoading.value = true;
    error.value = null;
    apiError.value = null;

    try {
      final response = await http.get(url, headers: headers);
      print("📍Orders response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        orders.value = data.map((json) => OrdersModel.fromJson(json)).toList();
      } else {
        apiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      error.value = Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // useEffect لتشغيل fetch مرة واحدة عند mount
  useEffect(() {
    fetchData();
    return null;
  }, []); // [] => تعمل مرة واحدة فقط

  /// refetch لإعادة تحميل البيانات
  void refetch() {
    orders.value = null; // إعادة تعيين البيانات القديمة قبل التحميل
    fetchData();
  }

  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value, // أي خطأ موجود يتم إرجاعه
    refetch: refetch,
  );
}
