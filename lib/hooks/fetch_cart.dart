// import 'dart:convert';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:foodly/constants/constants.dart';
// import 'package:foodly/models/cart_response.dart';
// import 'package:foodly/models/hook_models/hook_result.dart';
// import 'package:foodly/models/api_error.dart';

// /// Hook مخصص لجلب بيانات السلة حسب رقم الجوال
// FetchHook useFetchCart() {
//   final box = GetStorage();
//   final cart = useState<CartResponse?>(null);
//   final isLoading = useState<bool>(false);
//   final error = useState<Exception?>(null);
//   final apiErrorState = useState<ApiError?>(null);

//   Future<void> fetchData() async {
//     isLoading.value = true;
//     error.value = null;
//     apiErrorState.value = null;

//     final phone = box.read('phone');
//     if (phone == null || phone.isEmpty) {
//       error.value = Exception("رقم الجوال غير موجود. الرجاء تسجيل الدخول");
//       cart.value = null;
//       isLoading.value = false;
//       return;
//     }

//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${box.read('token')}',

//     };

//     try {
//       Uri url = Uri.parse("$appBaseUrl/api/cart");
//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         try {
//           final Map<String, dynamic> jsonMap = jsonDecode(response.body);
//           final CartResponse cartResponse = CartResponse.fromJson(jsonMap);
//           cart.value = cartResponse;
//         } catch (e) {
//           error.value = Exception("خطأ في صيغة JSON: $e");
//           cart.value = null;
//         }
//       } else {
//         try {
//           apiErrorState.value = apiErrorFromJson(response.body);
//         } catch (_) {
//           error.value = Exception("خطأ غير متوقع من السيرفر");
//         }
//         cart.value = null;
//       }
//     } catch (e) {
//       error.value = Exception("فشل الاتصال بالسيرفر: $e");
//       cart.value = null;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // useEffect لتشغيل الجلب عند إنشاء الواجهة
//   useEffect(() {
//     fetchData();
//     return null;
//   }, []);

//   // دالة لإعادة تحميل السلة يدوياً
//   void refetch() {
//     fetchData();
//   }

//   return FetchHook(
//     data: cart.value,
//     isLoading: isLoading.value,
//     error: error.value,
//     refetch: refetch,
//   );
// }
