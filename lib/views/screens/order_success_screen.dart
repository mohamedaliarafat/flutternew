import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/views/request_order.dart/request_page.dart' hide kWhite70;



class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.chevron_forward, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/logo.png', height: 40.h, fit: BoxFit.contain, color: Colors.white),
          ),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [kNavyStart, kNavyEnd], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Stack(
            children: [
              const BubblesBackground(),
              BackdropFilter(filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), child: Container(color: Colors.black.withOpacity(0.01))),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 100.w),
                    SizedBox(height: 20.h),
                    Text("✅ تم تأكيد الطلب بنجاح!",
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        "تاجرنا العزيز، تم استلام طلب الوقود الخاص بك بنجاح. سنراجع التفاصيل وسنرسل لك إشعارًا بظهور صفحة الدفع قريبًا.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.sp, color: kWhite70, height: 1.5),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    TextButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text("العودة إلى الصفحة الرئيسية",
                          style: TextStyle(color: kNavyEnd, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
