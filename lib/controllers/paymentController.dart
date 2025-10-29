import 'dart:convert';
import 'package:foodly/models/payment_model';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:foodly/models/api_error.dart';
import 'package:foodly/constants/constants.dart';

class PaymentController {
  final box = GetStorage();
  final String baseUrl = "$appBaseUrl/api/payments";

  /// 🧾 إنشاء عملية دفع جديدة
  Future<Map<String, dynamic>> createPayment({
    required String orderId,
    required double totalAmount,
    required String currency,
    required String bank,
    required String iban,
    String? receiptFile, // اسم الصورة أو null
  }) async {
    try {
      final token = box.read("token");
      final headers = {
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers.addAll(headers);

      // 🧩 الحقول العادية
      request.fields.addAll({
        'orderId': orderId,
        'totalAmount': totalAmount.toString(),
        'currency': currency,
        'bank': bank,
        'iban': iban,
      });

      // 📎 لو في صورة مرفقة (الإيصال)
      if (receiptFile != null) {
        request.files.add(await http.MultipartFile.fromPath('receipt', receiptFile));
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(body);
        return {'success': true, 'data': jsonResponse};
      } else {
        return {
          'success': false,
          'error': apiErrorFromJson(body),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// 📥 جلب جميع المدفوعات (للأدمن)
  Future<List<PaymentModel>> getAllPayments() async {
    try {
      final token = box.read("token");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(baseUrl), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => PaymentModel.fromJson(e)).toList();
      } else {
        throw Exception("فشل في تحميل البيانات");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 👤 جلب مدفوعات مستخدم معين
  Future<List<PaymentModel>> getUserPayments(String userId) async {
    try {
      final token = box.read("token");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse("$baseUrl/user/$userId"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => PaymentModel.fromJson(e)).toList();
      } else {
        throw Exception("فشل في تحميل المدفوعات");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 🔄 تحديث حالة الدفع (موافقة / رفض)
  Future<bool> updatePaymentStatus(String paymentId, String status) async {
    try {
      final token = box.read("token");
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = json.encode({'status': status});
      final response = await http.put(
        Uri.parse("$baseUrl/$paymentId/status"),
        headers: headers,
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
