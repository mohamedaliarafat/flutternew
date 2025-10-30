import 'dart:convert';

import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/api_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:foodly/models/hook_models/hook_result.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

/// Hook مخصص لجلب بيانات السلة
FetchHook useFetchCart() {
  final box = GetStorage();
  final cart = useState<List<CartResponse>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiErrorState = useState<ApiError?>(null);

  /// دالة لجلب بيانات السلة
  Future<void> fetchData() async {
    isLoading.value = true;
    error.value = null;
    apiErrorState.value = null;

    String? accessToken = box.read("token");
    if (accessToken == null || accessToken.isEmpty) {
      error.value = Exception("Token not found. الرجاء تسجيل الدخول");
      cart.value = [];
      isLoading.value = false;
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      Uri url = Uri.parse("$appBaseUrl/api/cart");
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        try {
          // ⚡ تعديل هنا: قراءة items داخل كل cart
          final List<dynamic> jsonList = jsonDecode(response.body);
          final List<CartResponse> carts = jsonList.map((jsonItem) {
            return CartResponse.fromJson(jsonItem);
          }).toList();

          cart.value = carts;
        } catch (e) {
          error.value = Exception("Invalid JSON format: $e");
          cart.value = [];
        }
      } else {
        try {
          apiErrorState.value = apiErrorFromJson(response.body);
        } catch (_) {
          error.value = Exception("خطأ غير متوقع من السيرفر");
        }
        cart.value = [];
      }
    } catch (e) {
      error.value = Exception("فشل الاتصال بالسيرفر: $e");
      cart.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // useEffect لتشغيل الجلب عند إنشاء الواجهة
  useEffect(() {
    fetchData();
    return null;
  }, []);

  // دالة لإعادة تحميل السلة يدوياً
  void refetch() {
    fetchData();
  }

  return FetchHook(
    data: cart.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
