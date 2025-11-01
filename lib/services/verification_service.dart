// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:foodly/controllers/phone_verification_controller.dart';

// class VerificationService {
//   // تأكد أن الكنترولر مسجل، وإذا ما كان مسجل يتم إضافته تلقائيًا
//   final PhoneVerificationController controller = 
//       Get.isRegistered<PhoneVerificationController>()
//           ? Get.find<PhoneVerificationController>()
//           : Get.put(PhoneVerificationController());

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   /// إرسال رمز التحقق للهاتف
//   Future<void> verifyPhoneNumber({
//     required String phoneNumber,
//     required void Function(String verificationId, int? resendToken) codeSentCallback,
//   }) async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         timeout: const Duration(seconds: 60),

//         verificationCompleted: (PhoneAuthCredential credential) async {
//           try {
//             await _auth.signInWithCredential(credential);
//             controller.verifyPhone();
//             debugPrint("✅ Phone automatically verified and user signed in.");
//           } catch (e) {
//             debugPrint("❌ Error signing in automatically: $e");
//             Get.snackbar("خطأ", "فشل تسجيل الدخول التلقائي");
//           }
//         },

//         verificationFailed: (FirebaseAuthException e) {
//           debugPrint("❌ Phone verification failed: ${e.code} - ${e.message}");
//           Get.snackbar("خطأ", e.message ?? "فشل التحقق من الرقم");
//         },

//         codeSent: (String verificationId, int? resendToken) {
//           codeSentCallback(verificationId, resendToken);
//           debugPrint("📩 Verification code sent! ID: $verificationId");
//         },

//         codeAutoRetrievalTimeout: (String verificationId) {
//           debugPrint("⏳ Auto retrieval timeout: $verificationId");
//         },
//       );
//     } catch (e) {
//       debugPrint("❌ verifyPhoneNumber error: $e");
//       Get.snackbar("خطأ", "حدث خطأ أثناء إرسال رمز التحقق");
//     }
//   }

//   /// التحقق من كود SMS
//   Future<void> verifySmsCode({
//     required String verificationId,
//     required String smsCode,
//   }) async {
//     if (verificationId.isEmpty || smsCode.isEmpty) {
//       Get.snackbar("خطأ", "رمز التحقق غير صالح");
//       return;
//     }

//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );

//       await _auth.signInWithCredential(credential);
//       controller.verifyPhone();

//       Get.snackbar("نجاح", "تم التحقق من الهاتف بنجاح!");
//       debugPrint("✅ Phone verified successfully!");
//     } on FirebaseAuthException catch (e) {
//       debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
//       Get.snackbar("خطأ", e.message ?? "فشل التحقق من الكود");
//     } catch (e) {
//       debugPrint("❌ Unknown error during SMS verification: $e");
//       Get.snackbar("خطأ", "حدث خطأ غير معروف أثناء التحقق");
//     }
//   }
// }
