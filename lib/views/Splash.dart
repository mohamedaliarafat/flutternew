import 'package:flutter/material.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:foodly/views/auth/verification_page.dart';


class EntryPoint extends StatelessWidget {
  final box = GetStorage();

  EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      String? token = box.read("token");
      bool isVerified = box.read("verification") ?? false;

      if (token != null && isVerified) {
        // المستخدم مسجّل دخول وتم التحقق -> انتقل مباشرة للصفحة الرئيسية
        Get.offAll(() => MainScreen());
      } else if (token != null && !isVerified) {
        // مسجّل دخول لكن لم يتم التحقق -> صفحة التحقق
        Get.offAll(() => VerificationPage());
      } else {
        // لم يتم تسجيل الدخول -> MainScreen أو صفحة Login حسب التطبيق
        Get.offAll(() => MainScreen());
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
