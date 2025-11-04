import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:foodly/constants/constants.dart';

class AddressController extends GetxController {
  get address => null;

  Future<bool> addAddress(String data) async {
    final box = GetStorage();
    String? accessToken = box.read("token");

    if (accessToken == null) return false;

    Uri url = Uri.parse('$appBaseUrl/api/address');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: data,
      );

      if (response.statusCode == 201) {
        print("✅ Address added successfully");
        return true;
      } else {
        print("❌ Failed to add address: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error: $e");
      return false;
    }
  }
}
