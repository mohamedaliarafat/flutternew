import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/models/payment_model';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/hook_models/payments.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:foodly/constants/constants.dart';

FetchPayments useFetchPayments() {
  final box = GetStorage();
  final payments = useState<List<PaymentModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read("token");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;

    try {
      Uri url = Uri.parse("$appBaseUrl/api/payments");
      final response = await http.get(url, headers: headers);

      print("📡 Payments API Status: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        payments.value = jsonData.map((e) => PaymentModel.fromJson(e)).toList();
      } else {
        apiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      error.value = Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchPayments(
    data: payments.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
    apiError: apiError.value,
  );
}
