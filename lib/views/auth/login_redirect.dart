import 'package:flutter/material.dart';
import 'package:foodly/views/auth/PhoneInputScreen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// الألوان الداكنة المستخدمة من شاشة OTP (للتناسق)
const Color _kDarkBackground = Color(0xFF070B35); // كحلي غامق للخلفية
const Color _kAccentColor = Color(0xFF3455D8); // أزرق حيوي للتركيز

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. تغيير الخلفية إلى اللون الداكن
      backgroundColor: _kDarkBackground,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              
              const SizedBox(height: 20),

              // 2. النص العلوي
              Column(
                children: [
                  const Text(
                    "تسجيل الدخول مطلوب", // نص معرب ومناسب
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white, // لون أبيض ساطع
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "يرجى تسجيل الدخول أو إنشاء حساب للوصول إلى هذه الميزات.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7), // رمادي فاتح
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // 3. الصورة (Lottie Animation)
              // ملاحظة: تأكد من وجود ملف 'login.json' في مجلد assets/anime
              SizedBox(
                height: 350,
                child: Lottie.asset(
                  'assets/anime/login.json', // ← حافظنا على المسار، يرجى التأكد من توفر الملف
                  fit: BoxFit.contain,
                  // لإضفاء تناغم، يمكن تلوين الرسوم المتحركة إذا كانت تدعم ذلك
                ),
              ),

              const SizedBox(height: 40),

              // 4. زر تسجيل الدخول (بتصميم بارز)
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  width: double.infinity,
                  height: 60, // زر أطول
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // إضافة تدرج ولون وظل للزر لجعله بارزاً وفخماً
                    gradient: const LinearGradient(
                      colors: [_kAccentColor, Color(0xFF1A237E)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kAccentColor.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const PhoneInputScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // لجعل التدرج يظهر
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "تسجيل الدخول الآن",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
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
