// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:foodly/common/app_style.dart';
// import 'package:foodly/common/back_ground_container.dart';
// import 'package:foodly/common/custom_button.dart';
// import 'package:foodly/common/reusable_text.dart';
// import 'package:foodly/constants/constants.dart';
// import 'package:foodly/controllers/register_controller.dart';
// import 'package:foodly/models/registration_mdel.dart';
// import 'package:foodly/views/auth/login_page.dart';
// import 'package:foodly/views/auth/widget/email_textField.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   late final TextEditingController _emailController = TextEditingController();
//   late final TextEditingController _passwordController = TextEditingController();
//   late final TextEditingController _userController = TextEditingController();

//   final FocusNode _passwordFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _passwordFocusNode.dispose();
//     _passwordController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(RegisterController());
//     return Scaffold(
      
//       appBar: AppBar(
//          leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
//           tooltip: 'خروج',
//           onPressed: () => Navigator.pop(context), // وظيفة الرجوع
//         ),
//         elevation: 0,
//         backgroundColor: kBlueDark,
//         title: Center(
//           child: ReusableText(text: "AlBuhaira Register", style: appStyle(20, kLightWhite, FontWeight.bold), tex: ""),
//         ),
//       ),
//       body: BackGroundContainer(
//         color: Colors.white,
//         child: ClipRRect(
//           borderRadius: BorderRadiusGeometry.only(
//             topLeft: Radius.circular(30.r),
//             topRight: Radius.circular(30.r),
//           ),
//           child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             SizedBox(
//               height: 50.h,
//             ),
//              Center(
//                 child: Image.asset(
//                   "assets/images/logo1.png", // ضع مسار الصورة الصحيح هنا
//                   height: 190.h,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               SizedBox(
//               height: 50.h,
//             ),


//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   EmailTextfield(
//                     hinText: "Username", 
//                     prefixIcon: Icon(AntDesign.user, size: 22, color: kGrayLight,),
//                     controller: _userController,
//                   ),


                   
//                   SizedBox(
//                     height: 25.h,
//                   ),
//                   EmailTextfield(
//                      hinText: "Enter Email", 
//                     prefixIcon: Icon(CupertinoIcons.mail, size: 22, color: kGrayLight,),
//                     controller: _emailController,
//                   ),

                  
//                   SizedBox(
//                     height: 25.h,
//                   ),
//                   EmailTextfield(
//                      hinText: "Enter Password", 
//                     prefixIcon: Icon(AntDesign.key, size: 22, color: kGrayLight,),
//                     controller: _passwordController,
//                   ),
                 
//                   SizedBox(
//                     height: 10,
//                           ),
                   
//                     CustomButton(
//                         text: "R E G I S T E R",
//                         onTap: () {
//                           if (_emailController.text.isNotEmpty &&
//                               _userController.text.isNotEmpty &&
//                               _passwordController.text.length >= 8) {
//                             RegistrationModel model = RegistrationModel(
//                               username: _userController.text,
//                               email: _emailController.text,
//                               password: _passwordController.text,
//                             );

//                             String data = registrationModelToJson(model);

//                             controller.registrationFunction(data);
//                           }
//                         },
//                         btnHeight: 35.h,
//                         btnWidth: width,
//                       ),

//                       SizedBox(height: 15.h),

//                       GestureDetector(
//                         onTap: () {
//                           // ضع هنا التوجيه إلى صفحة تسجيل الدخول
//                           Get.to(() => LoginPage(), 
//                             transition: Transition.fadeIn,
//                             duration: const Duration(milliseconds: 500),
//                           );
//                         },
//                         child: RichText(
//                           text: TextSpan(
//                             text: "لو لديك حساب؟ ",
//                             style: appStyle(12, Colors.grey, FontWeight.normal),
//                             children: [
//                               TextSpan(
//                                 text: "تسجيل الدخول",
//                                 style: appStyle(15, kBlueDark, FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                        SizedBox(
//                         height: 30.h,
//                        ), 

//                        SizedBox(height: 20.h),

//                     Center(
//                       child: ReusableText(
//                         text: "Or continue with",
//                         style: appStyle(14, kDark, FontWeight.w400), tex: '',
//                       ),
//                     ),

//                     SizedBox(
                      
//                       height: 10.h,
//                       width: width,
//                       ),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             // controller.signInWithGoogle();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Image.asset(
//                               'assets/icons/google.png',
//                               height: 35,
//                               width: 35,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 20.w),
//                         GestureDetector(
//                           onTap: () {
//                             // controller.signInWithApple();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Image.asset(
//                               'assets/icons/apple.png',
//                               height: 35,
//                               width: 35,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

                      
//                 ],
//               ),
//             )
//           ],
//                 ),
//         ),
//          ),
//     );
//   }
// }