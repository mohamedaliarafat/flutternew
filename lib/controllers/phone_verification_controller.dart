// // ignore_for_file: prefer_final_fields
// import 'package:foodly/views/entrypoint.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:foodly/constants/constants.dart';
// import 'package:foodly/models/api_error.dart';
// import 'package:foodly/models/login_response.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;

// class PhoneVerificationController extends GetxController {
//   final box = GetStorage();

//   String _phone = "";
//   String get phone => _phone;

//   set setPhoneNumber(String value) => _phone = value;

//   RxBool isLoading = false.obs;
//   RxBool isVerified = false.obs;

//   void setLoading(bool value) => isLoading.value = value;

//   /// هذه الدالة تُستدعى بعد التحقق من SMS بنجاح عبر Firebase
//   void verifyPhone() async {
//     setLoading(true);

//     try {
//       String accessToken = box.read("token") ?? "";
//       if (accessToken.isEmpty) {
//         Get.snackbar("Error", "User token not found",
//             colorText: kLightWhite, backgroundColor: kRed);
//         setLoading(false);
//         return;
//       }

//       Uri url = Uri.parse('$appBaseUrl/api/users/verify_phone/$_phone');

//       Map<String, String> headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken'
//       };

//       var response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         LoginResponse data = loginResponseFromJson(response.body);

//         // حفظ بيانات المستخدم
//         box.write("userId", data.id);
//         box.write("token", data.userToken);
//         box.write("verification", data.verification);
//         box.write(data.id, jsonEncode(data));
// // 
//         isVerified.value = true;

//         Get.snackbar(
//           "Success",
//           "You are successfully verified. Enjoy your awesome experience",
//           colorText: kLightWhite,
//           backgroundColor: kPrimary,
//           icon: const Icon(Ionicons.train_outline),
//         );

//         // الانتقال للشاشة الرئيسية
//         Get.offAll(() => MainScreen());
//       } else {
//         var error = apiErrorFromJson(response.body);
//         Get.snackbar(
//           "Failed to verify account",
//           error.message,
//           colorText: kLightWhite,
//           backgroundColor: kRed,
//           icon: const Icon(Icons.error_outline),
//         );
//       }
//     } catch (e) {
//       debugPrint("verifyPhone error: $e");
//       Get.snackbar(
//         "Error",
//         "حدث خطأ أثناء التحقق من الهاتف",
//         colorText: kLightWhite,
//         backgroundColor: kRed,
//         icon: const Icon(Icons.error_outline),
//       );
//     } finally {
//       setLoading(false);
//     }
//   }
// }
