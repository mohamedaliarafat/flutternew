import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/views/auth/OtpVerificationScreen.dart';

// تعريف الألوان الداكنة للكارد وحقل الإدخال
const Color _kDarkCardColor = Color(0xFF0F144D);
const Color _kDarkInputFieldFill = Color(0xFF1A237E);

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+966'; // رمز الدولة الافتراضي
  final AuthController _authController = AuthController();

  // 🔹 الزر يظهر إذا تم إدخال 9 أرقام أو أكثر
  bool get showSendOtpButton => _phoneController.text.trim().length >= 9;

  /// 🔹 إرسال OTP
  void _sendOtp() async {
    if (!showSendOtpButton) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم الجوال غير صالح')),
      );
      return;
    }

    String fullPhoneNumber = _selectedCountryCode + _phoneController.text.trim();

    try {
      // طلب إرسال OTP باستخدام الكونترولر
      await _authController.requestOtp(fullPhoneNumber);

      // التنقل إلى شاشة التحقق من OTP وتمرير رقم الهاتف
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: fullPhoneNumber),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070B35), Color(0xFF3455D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // شعار التطبيق
                Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _kDarkCardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Image.network(
                      'https://www2.0zz0.com/2025/11/03/16/290260377.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // الكارد الرئيسي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    color: _kDarkCardColor,
                    elevation: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.5),
                    ),
                    shadowColor: const Color(0xFF070B35).withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'مرحباً بعودتك!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'أدخل رقم جوالك للدخول. سيتم إرسال رمز تحقق لمرة واحدة.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                          ),
                          const SizedBox(height: 40),
                          // إدخال رقم الهاتف
                          Row(
                            children: [
                              CountryCodePicker(
                                onChanged: (code) {
                                  setState(() {
                                    _selectedCountryCode = code.dialCode!;
                                  });
                                },
                                initialSelection: 'SA',
                                favorite: const ['+966', 'SA'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'رقم الجوال',
                                    hintText: '5xxxxxxxx',
                                    hintStyle: TextStyle(color: Colors.white38),
                                    labelStyle: TextStyle(color: Colors.white54),
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
                                      borderSide: BorderSide(color: Color(0xFF3455D8), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: _kDarkInputFieldFill,
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                  ),
                                  onChanged: (_) {
                                    setState(() {}); // تحديث حالة الزر
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          // زر إرسال OTP يظهر عند إدخال 9 أرقام أو أكثر
                          if (showSendOtpButton)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3455D8), Color(0xFF070B35)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF3455D8).withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'إرسال رمز التحقق',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
