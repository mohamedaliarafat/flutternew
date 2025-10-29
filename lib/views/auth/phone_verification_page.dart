import 'package:flutter/material.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/phone_verification_controller.dart';
import 'package:foodly/services/verification_service.dart';
import 'package:get/get.dart';
import 'package:phone_otp_verification/phone_verification.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final VerificationService _verificationService = VerificationService();
  final PhoneVerificationController controller = Get.put(PhoneVerificationController());
  String _verificationId = "";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value == false
          ? 
          
          
          
          PhoneVerification(
              isFirstPage: false,
              enableLogo: false,
              themeColor: kBlueDark,
              backgroundColor: kLightWhite,
              initialPageText: "Verify Phone Al-Buhaira",
              initialPageTextStyle: appStyle(20, kBlueDark, FontWeight.bold),
              textColor: kDark,
              onSend: (String phoneNumber) async {
                controller.setPhoneNumber = phoneNumber;

                // تأكد من صيغة رقم الهاتف
                String formattedNumber = phoneNumber.startsWith('+')
                    ? phoneNumber
                    : '+966$phoneNumber';

                await _verifyPhoneNumber(formattedNumber);
              },
              onVerification: (String smsCode) async {
                await _submitVerificationCode(smsCode);
              },
            )
          : Container(
              color: kLightWhite,
              width: width,
              height: hieght,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  /// إرسال رمز SMS
  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    controller.isLoading.value = true;

    await _verificationService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSentCallback: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Get.snackbar("Info", "رمز التحقق تم إرساله إلى هاتفك",
        backgroundColor: kBlueDark,
        icon: Icon(Icons.message_outlined),
        colorText: kLightWhite
        );
      },
    );

    controller.isLoading.value = false;
  }

  /// التحقق من كود SMS
  Future<void> _submitVerificationCode(String smsCode) async {
    if (_verificationId.isEmpty || smsCode.isEmpty) {
      Get.snackbar("Error", "رمز التحقق غير صالح",
      backgroundColor: kBlueDark,
      colorText: kLightWhite,
      icon: Icon(Icons.error_outline_outlined,
      color: Colors.red,
      )
      );
      return;
    }

    controller.isLoading.value = true;

    await _verificationService.verifySmsCode(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    controller.isLoading.value = false;

    if (controller.isVerified.value) {
      Get.snackbar("Success", "تم التحقق من الهاتف بنجاح!",
      backgroundColor: kBlueDark,
      colorText: kLightWhite,
      icon: Icon(Icons.check_circle_outline,
      color: Colors.green,
      )
      );
      // هنا يمكنك الانتقال للشاشة التالية
    }
  }
}
