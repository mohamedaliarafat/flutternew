import 'package:flutter/material.dart';
import 'package:foodly/views/auth/PhoneInputScreen.dart';
import 'package:get/get.dart';
import 'package:foodly/views/auth/login_page.dart';
import 'package:lottie/lottie.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // النص العلوي
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: const Text(
                      "Please login to access this page",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // الصورة (ضع صورتك في assets)
              SizedBox(
                height: 350,
                child: Lottie.asset(
                  'assets/anime/login.json', // ← ضع المسار الصحيح لصورتك
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 50),

              // زر تسجيل الدخول
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const PhoneInputScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // اللون الأخضر المزرق
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
