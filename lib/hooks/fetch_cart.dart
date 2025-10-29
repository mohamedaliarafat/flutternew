import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/api_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:foodly/models/hook_models/hook_result.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchCart() {
  final box = GetStorage();
  final cart = useState<List<CartResponse>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiErrorState = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read("token");
    if (accessToken == null || accessToken.isEmpty) {
      error.value = Exception("Token not found");
      cart.value = [];
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;

    try {
      Uri url = Uri.parse("$appBaseUrl/api/cart");
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        try {
          cart.value = cartResponseFromJson(response.body);
        } catch (e) {
          error.value = Exception("Invalid JSON format");
          cart.value = [];
        }
      } else {
        try {
          apiErrorState.value = apiErrorFromJson(response.body);
        } catch (_) {
          
        }
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
    fetchData();
  }

  return FetchHook(
    data: cart.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
