// ignore_for_file: prefer_final_fields
import 'dart:convert';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/address_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class UserLocationController extends GetxController {

  /// العنوان المختار من قائمة العناوين
  Rx<AddressResponse?> selectedAddress = Rx<AddressResponse?>(null);

  void selectAddress(AddressResponse address) {
    selectedAddress.value = address;
    setAddress = address.addressLine1; // تحديث العنوان الحالي تلقائيًا
  }

  AddressResponse? get getSelectedAddress => selectedAddress.value;

  /// للتحكم في تعيين العنوان الافتراضي
  final RxBool _isDefault = false.obs;

  bool get isDefault => _isDefault.value;

  set isDefault(bool value) {
    _isDefault.value = value;
  }

  /// لإدارة الصفحة الحالية في الـ PageView
  RxInt _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;

  set setTabIndex(int value) {
    _tabIndex.value = value;
  }

  /// الموقع الحالي
  LatLng position = const LatLng(0, 0);

  void setPosition(LatLng value) {
    position = value;
    update();
  }

  /// العنوان كنص للعرض في الصفحة
  RxString _address = "".obs;

  String get address => _address.value;

  set setAddress(String value) {
    _address.value = value;
  }

  /// الرمز البريدي
  RxString _postalCode = "".obs;

  String get postalCode => _postalCode.value;

  set setIsDefault(bool setIsDefault) {}

  set setPostalCode(String value) {
    _postalCode.value = value;
  }

  /// جلب العنوان من الموقع الحالي باستخدام Google Geocoding API
  void getUserAddress(LatLng position) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['results'] != null && responseBody['results'].isNotEmpty) {
        setAddress = responseBody['results'][0]['formatted_address'];

        final addressComponents = responseBody['results'][0]['address_components'];

        for (var component in addressComponents) {
          if (component['types'].contains("postal_code")) {
            setPostalCode = component['long_name'];
          }
        }
      }
    }
  }

  /// إضافة عنوان جديد إلى قاعدة البيانات
  Future<void> addAddress(String data) async {
    final box = GetStorage();
    String? accessToken = box.read("token");

    if (accessToken == null) {
      Get.snackbar("خطأ", "لم يتم العثور على التوكن");
      return;
    }

    Uri url = Uri.parse('$appBaseUrl/api/address');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: data, // إرسال JSON مباشرة
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        Get.snackbar("تم بنجاح", resData["message"] ?? "تم إضافة العنوان");
        print("✅ Address added: ${response.body}");
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("خطأ", errorData["message"] ?? "فشل في إضافة العنوان");
        print("❌ Error: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال: $e");
      print("⚠️ Exception: $e");
    }
  }
}
