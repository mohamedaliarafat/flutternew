import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_controller.dart';
import 'package:foodly/models/login_model.dart';
import 'package:foodly/views/auth/register_page.dart';
import 'package:foodly/views/auth/widget/email_textField.dart';
import 'package:foodly/views/auth/widget/password_textfild.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

     
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'خروج',
          onPressed: () => Navigator.pop(context), // وظيفة الرجوع
        ),
        elevation: 0,
        backgroundColor: kBlueDark,
        title: Center(
          child: ReusableText(text: "AlBuhaira LogIn", style: appStyle(20, kLightWhite, FontWeight.bold), tex: ""),
        ),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 50.h,
            ),
             Center(
                child: Image.asset(
                  "assets/images/logo1.png", // ضع مسار الصورة الصحيح هنا
                  height: 190.h,
                  
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
              height: 50.h,
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  EmailTextfield(
                     hinText: "Enter Email", 
                    prefixIcon: Icon(CupertinoIcons.mail, size: 22, color: kGrayLight,),
                    controller: _emailController,
                  ),

                  
                  SizedBox(
                    height: 25.h,
                  ),
                  PasswordTextfild(
                    
                    controller: _passwordController,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 10
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ReusableText(
                          text: "ليس لديك حساب؟ ",
                          style: appStyle(12, Colors.grey, FontWeight.normal),
                          tex: "",
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.to(
                                () => RegisterPage(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent, width: 1.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ReusableText(
                                text: "تسجيل",
                                style: appStyle(15, Colors.blueAccent, FontWeight.bold),
                                tex: "",
                              ),
                            ),
                          ),
                          ],
                    ),
                  ),


                  SizedBox(
                    height: 10,
                          ),
                   
                    CustomButton(
                      text: "L O G I N",
                      onTap: () {
                        if(_emailController.text.isNotEmpty && _passwordController.text.length >= 8 ) {
                          var model = LoginModel(
                            email: _emailController.text, 
                            password: _passwordController.text);

                            String data = loginModelToJson(model);

                             controller.loginFunction(data);                      
                        }
                      },

                      btnHeight: 35.h,
                      btnWidth: width,
                       ),

                       SizedBox(
                        height: 30.h,
                       ), 

                       SizedBox(height: 20.h),

                    Center(
                      child: ReusableText(
                        text: "Or continue with",
                        style: appStyle(14, Colors.blueAccent, FontWeight.w400), tex: '',
                      ),
                    ),

                    SizedBox(
                      
                      height: 10.h,
                      width: width,
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // controller.signInWithGoogle();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/icons/google.png',
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        GestureDetector(
                          onTap: () {
                            // controller.signInWithApple();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/icons/apple.png',
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ),
                      ],
                    ),


                      
                ],
              ),
            )
          ],
                ),
        ),
         ),
    );
  }
}