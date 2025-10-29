import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/address_response.dart';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/hook_models/hook_result.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchDefault() {
  final box = GetStorage();
  final address = useState<AddressResponse?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    final accessToken = box.read("token");
    if (accessToken == null) {
      error.value = Exception("Token not found");
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;

    try {
      final url = Uri.parse("$appBaseUrl/api/address/default");
      final response = await http.get(url, headers: headers);

      print("📍Default address response: ${response.body}");

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);

        // تحقق من أن البيانات موجودة وليست رسالة خطأ
        if (decode is Map<String, dynamic> && decode["status"] == true) {
          address.value = AddressResponse.fromJson(decode["data"]);
        } else {
          // API أعاد خريطة مباشرة
          address.value = AddressResponse.fromJson(decode);
        }
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

  return FetchHook(
    data: address.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
