// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class ApiService {
//    String appBaseUrl = "http://192.168.8.11:6013";// غيّر IP حسب جهازك المحلي

//   // ✅ إرسال طلب الدفع مع الإيصال
//   static Future<Map<String, dynamic>> createPayment({
//     required String token,
//     required String orderId,
//     required double totalAmount,
//     required String currency,
//     required String bank,
//     required String iban,
//     required String userName,
//     required String userId,
//     required File receiptFile,
//   }) async {
//     try {
//       var uri = Uri.parse("$appBaseUrl/payments/");

//       var request = http.MultipartRequest('POST', uri);
//       request.headers['Authorization'] = 'Bearer $token';
//       request.fields['orderId'] = orderId;
//       request.fields['totalAmount'] = totalAmount.toString();
//       request.fields['currency'] = currency;
//       request.fields['bank'] = bank;
//       request.fields['iban'] = iban;
//       request.fields['userName'] = userName;
//       request.fields['userId'] = userId;

//       request.files.add(await http.MultipartFile.fromPath(
//         'receipt',
//         receiptFile.path,
//       ));

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 201) {
//         return json.decode(response.body);
//       } else {
//         print(response.body);
//         return {'error': 'فشل في إرسال الدفع'};
//       }
//     } catch (e) {
//       print("❌ خطأ أثناء الاتصال بالسيرفر: $e");
//       return {'error': e.toString()};
//     }
//   }

//   // ✅ جلب مدفوعات المستخدم
//   static Future<List<dynamic>> getUserPayments(String token, String userId) async {
//     try {
//       final response = await http.get(
//         Uri.parse("$baseUrl/payments/user/$userId"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         print(response.body);
//         return [];
//       }
//     } catch (e) {
//       print("❌ خطأ أثناء جلب البيانات: $e");
//       return [];
//     }
//   }
// }
