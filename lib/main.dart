// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:foodly/constants/constants.dart';
// import 'package:foodly/firebase_options.dart';
// import 'package:foodly/views/intro_page.dart'; // ✅ صفحة الانترو الجديدة
// import 'package:foodly/views/profile/complete_profilePage.dart';
// import 'package:foodly/views/profile/profile_page.dart';
// import 'package:get/get.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 825),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Al-Buhaira',
//           // locale: LocalizationService.locale,
//           // fallbackLocale: LocalizationService.fallbackLocale,
//           // translations: LocalizationService(),
//           theme: ThemeData(
//             scaffoldBackgroundColor: kOffWhite,
//             iconTheme: const IconThemeData(
//               color: Colors.white,
//             ),
//             primarySwatch: Colors.grey,
//           ),
//           home: const ProfilePage(), 
//         );
//       },
//     );
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/firebase_options.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:foodly/views/intro_page.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تسجيل AuthController عند بدء التطبيق
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Al-Buhaira',
          theme: ThemeData(
            scaffoldBackgroundColor: kOffWhite,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            primarySwatch: Colors.grey,
          ),
          // ✅ يمكن تغيير الصفحة الرئيسية حسب حالة المستخدم
          home:  IntroPage(), // أو IntroPage() للانترو
        );
      },
    );
  }
}
