// ignore_for_file: unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/category_controller.dart';
import 'package:foodly/models/api_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


FetchHook useFetchRestaurantFoods(String id) {
  final controller = Get.put(CategoryController());
  final foods = useState<List<FoodsModel>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final appiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse("$appBaseUrl/api/foods/restaurant-foods/$id");
      final response = await http.get(url);
            if (response.statusCode == 200) {
        foods.value = foodsModelFromJson(response.body);
      } 
    } catch (e) {
  debugPrint(e.toString());
}
 finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    Future.delayed(const Duration(seconds: 3));
    fetchData();


    
    return null;
  }, []);

  void refetch(){
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}