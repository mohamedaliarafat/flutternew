import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/views/auth/OtpVerificationScreen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+966'; // رمز الدولة الافتراضي
  final AuthController _authController = AuthController();

  bool get isPhoneValid => _phoneController.text.length == 9; // 9 أرقام بعد رمز الدولة

  /// إرسال OTP باستخدام الكنترولر وربط قاعدة البيانات
  void _sendOtp() async {
    if (!isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم الجوال غير صالح')),
      );
      return;
    }

    String fullPhoneNumber = _selectedCountryCode + _phoneController.text;

    try {
      // طلب إرسال OTP من السيرفر
      await _authController.requestOtp(fullPhoneNumber);

      // التنقل إلى شاشة التحقق مع تمرير رقم الهاتف
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
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الخلفية العلوية
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBlueDark, 
                  Color.fromARGB(255, 51, 117, 216)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // شعار التطبيق
            Center(
              
              child: Container(
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
                child: Image.network(
                  'https://d.top4top.io/p_3588wn4ke1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // الكارد الرئيسي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'مرحباً بعودتك!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: kBlueDark,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'أدخل رقم جوالك للدخول. سيتم إرسال رمز تحقق لمرة واحدة.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      // Row لإدخال كود الدولة + رقم الهاتف
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
                            textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'رقم الجوال',
                                hintText: '5xxxxxxxx',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              onChanged: (_) {
                                setState(() {}); // تحديث حالة الزر
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // زر إرسال OTP
                      Container(
                        decoration: BoxDecoration(
                          gradient: isPhoneValid
                              ? const LinearGradient(
                                  colors: [kBlueDark, Color.fromARGB(255, 51, 117, 216)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isPhoneValid ? _sendOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'إرسال رمز التحقق',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // رابط مساعدة
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'هل نسيت رقم جوالك؟',
                          style: TextStyle(color: kBlueDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
