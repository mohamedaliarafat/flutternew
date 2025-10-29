import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendSeconds = 60;

  final AuthController _authController = Get.put(AuthController());

  void _verifyOtp() async {
    String enteredOtp = _otpController.text;
    if (enteredOtp.length < 6) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // استدعاء الكنترولر للتحقق من OTP وتسجيل الدخول + فتح الصفحة الرئيسية
      await _authController.verifyOtpAndNavigate(widget.phoneNumber, enteredOtp);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        "خطأ",
        "حدث خطأ: ${e.toString()}",
        colorText: Colors.white,
        backgroundColor: kRed,
      );
    }
  }

  void _resendCode() async {
    if (_resendSeconds == 0) {
      setState(() {
        _resendSeconds = 60;
      });

      try {
        await _authController.requestOtp(widget.phoneNumber);
      } catch (e) {
        Get.snackbar(
          "خطأ",
          "فشل في إعادة إرسال الرمز: ${e.toString()}",
          colorText: Colors.white,
          backgroundColor: kRed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kBlueDark, Color.fromARGB(255, 51, 117, 216)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.lock_open_rounded, size: 60, color: kBlueDark),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'رمز التحقق',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kBlueDark),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'أدخل الرمز المكون من 6 أرقام الذي تم إرساله إلى ${widget.phoneNumber}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, letterSpacing: 15.0, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: '• • • • • •',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [kBlueDark, Color.fromARGB(255, 51, 117, 216)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: kBlueDark, blurRadius: 10, offset: const Offset(0, 5)),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: _resendSeconds == 0 ? _resendCode : null,
                            child: Text(
                              _resendSeconds == 0
                                  ? 'لم يصلك الرمز؟ إعادة إرسال الرمز'
                                  : 'إعادة الإرسال بعد 0:$_resendSeconds',
                              style: TextStyle(color: _resendSeconds == 0 ? kBlueDark : Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'تغيير رقم الجوال',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
