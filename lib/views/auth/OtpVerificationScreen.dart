import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:foodly/views/profile/complete_profilePage.dart';
import 'package:get/get.dart';
import 'dart:async';

const Color _kDarkBackground = Color(0xFF070B35);
const Color _kDarkCardColor = Color(0xFF0F144D);
const Color _kDarkInputFieldFill = Color(0xFF1A237E);

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  bool _isLoading = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  /// 🔹 تحقق OTP عبر الكونترولر وتوجيه المستخدم
  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) return;

    setState(() => _isLoading = true);
    _timer?.cancel();

    try {
      await _authController.verifyOtpAndLogin(widget.phoneNumber, otp);

      final userInfo = _authController.getUserInfo();
      final bool isProfileComplete = userInfo?['profileCompleted'] ?? false;

      if (!isProfileComplete) {
        Get.offAll(() => const CompleteProfilePage());
      } else {
        Get.offAll(() => MainScreen());
      }
    } catch (e) {
      Get.snackbar(
        'خطأ ⚠️',
        'الرمز غير صحيح أو حدث خطأ: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      _startResendTimer();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 إعادة إرسال OTP
  void _resendCode() async {
    if (_resendSeconds == 0) {
      try {
        await _authController.requestOtp(widget.phoneNumber);
        _startResendTimer();
        Get.snackbar(
          'نجاح ✅',
          'تم إعادة إرسال رمز التحقق',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'خطأ ❌',
          'فشل إعادة الإرسال: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        setState(() => _resendSeconds = 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBackground,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_kDarkBackground, Color(0xFF3455D8)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شعار التطبيق
                  Container(
                    width: 130,
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: kBlueDark, width: 1),
                    ),
                    child: Image.network(
                      'https://www2.0zz0.com/2025/11/03/16/290260377.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    color: _kDarkCardColor.withOpacity(0.9),
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'رمز التحقق',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'أدخل الرمز المكون من 6 أرقام الذي تم إرساله إلى ${widget.phoneNumber}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              letterSpacing: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: '• • • • • •',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), letterSpacing: 12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Color(0xFF3455D8), width: 2),
                              ),
                              filled: true,
                              fillColor: _kDarkInputFieldFill.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3455D8), _kDarkBackground],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading || _otpController.text.length < 6 ? null : _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'تأكيد والدخول',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextButton(
                            onPressed: _resendSeconds == 0 ? _resendCode : null,
                            child: Text(
                              _resendSeconds == 0
                                  ? 'لم يصلك الرمز؟ إعادة إرسال الرمز'
                                  : 'إعادة الإرسال بعد 0:${_resendSeconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: _resendSeconds == 0 ? Color(0xFF3455D8) : Colors.white54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'تغيير رقم الجوال',
                              style: TextStyle(color: Colors.white38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
