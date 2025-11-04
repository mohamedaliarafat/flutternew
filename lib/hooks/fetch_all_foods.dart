import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/models/hook_models/hook_result.dart';

FetchHook useFetchAllFoods(String code) {
  final foods = useState<List<FoodsModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final appiError = useState<ApiError?>(null);

  useEffect(() {
    bool mounted = true; // ✅ حماية ضد تحديث القيم بعد dispose

    Future<void> fetchData() async {
      try {
        if (!mounted) return;
        isLoading.value = true;

        final url = Uri.parse("$appBaseUrl/api/foods/byCode/$code");
        final response = await http.get(url);

        if (!mounted) return;

        if (response.statusCode == 200) {
          foods.value = foodsModelFromJson(response.body);
          appiError.value = null;
          error.value = null;
        } else {
          appiError.value = apiErrorFromJson(response.body);
        }
      } catch (e) {
        if (mounted) error.value = Exception(e.toString());
      } finally {
        if (mounted) isLoading.value = false;
      }
    }

    fetchData();

    // ✅ عند التخلص من الـ widget
    return () {
      mounted = false;
    };
  }, [code]); // ← لو تغيّر الكود، يعيد التحميل

  void refetch() {
    // ✅ يمنع التحديث بعد إغلاق الصفحة
    if (!isLoading.value) {
      isLoading.value = true;
      Future.microtask(() {
        if (isLoading.value) {
          // استدعاء التحديث بأمان
          final url = Uri.parse("$appBaseUrl/api/foods/byCode/$code");
          http.get(url).then((response) {
            if (response.statusCode == 200) {
              foods.value = foodsModelFromJson(response.body);
            } else {
              appiError.value = apiErrorFromJson(response.body);
            }
          }).catchError((e) {
            error.value = Exception(e.toString());
          }).whenComplete(() {
            isLoading.value = false;
          });
        }
      });
    }
  }

  return FetchHook(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}