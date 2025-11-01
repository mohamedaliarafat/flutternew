// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:foodly/common/app_style.dart';
// import 'package:foodly/common/custom_button.dart';
// import 'package:foodly/common/custom_container.dart';
// import 'package:foodly/common/reusable_text.dart';
// import 'package:foodly/constants/constants.dart';
// import 'package:foodly/controllers/verification_controller.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// class VerificationPage extends StatelessWidget {
//   const VerificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(VerificationController());
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       appBar: AppBar(
//         title: ReusableText(text: "Please Verify Your Account", 
//         style: appStyle(13, kGray, FontWeight.w600), tex: ""),
//         centerTitle: true,
//         backgroundColor: kOffWhite,
//         elevation: 0,
//       ),
      
//       body: CustomContainer(
//         color: Colors.white,
//         containerContent: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: SizedBox(
//             height: hieght,
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                Lottie.asset("assets/anime/otp.json"),
//                SizedBox(
//                 height: 10.h,
//                 ),
//                 ReusableText(text: "Enter OTP", 
//                 style: appStyle(20, Colors.blueAccent, FontWeight.bold), tex: ""),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 Text("Enter the 6-digit code sent to your email, if you don't see the code , please check your spam folder.", 
//                textAlign: TextAlign.justify,
//                 style: appStyle(10, Colors.grey, FontWeight.normal)),
//                 SizedBox(
//                   height: 20.h,
//                 ),

//                 OtpTextField(
//                         numberOfFields: 6,
//                         borderColor: Colors.blueAccent,
//                         borderWidth: 2.0,
//                         textStyle: appStyle(17, kDark, FontWeight.bold),
//                         onCodeChanged: (String code) {},
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         onSubmit: (String verificationCode){
//                           controller.setCode = verificationCode;
//                         }, // end onSubmit
//                     ),
//                   SizedBox(
//                     height: 20.h,
//                   ),

//                   CustomButton(
//                         text: "F E R I F Y   A C C O U N T",
//                         onTap: () {
//                           controller.verificationFuncation();
//                         },
//                         btnHeight: 35.h,
//                         btnWidth: 30.w,
//                       ),

//               ],
//             ),
//           ),
//         )),
//     );
//   }
// }