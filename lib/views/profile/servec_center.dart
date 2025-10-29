import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/constants/constants.dart';

// **ملاحظة:** قد تحتاج إلى إضافة الملفات المفقودة مثل 'app_style.dart' و 'reusable_text.dart' و 'constants.dart' 
// أو استبدالها بمكافئات Flutter القياسية (مثل TextStyle و Text) إذا كنت لا تمتلكها.
// في هذا الكود، سنستبدل `ReusableText` و `appStyle` و `kLightWhite` بالمكافئات القياسية لتجنب الأخطاء.

class ServiceCenter extends StatelessWidget {
  const ServiceCenter({Key? key}) : super(key: key);

  // **استبدال الدوال المفقودة بمكافئات Flutter القياسية لأغراض هذا المثال**
  TextStyle _appStyle(double size, Color color, FontWeight weight) {
    return TextStyle(fontSize: size, color: color, fontWeight: weight);
  }
  
  Widget _reusableText(String text, TextStyle style) {
    return Text(text, style: style);
  }
  
  final Color _kLightWhite = Colors.white;
  final Color _kPrimaryColor = kBlueDark; // لون أزرق داكن جذاب

  @override
  Widget build(BuildContext context) {
    // تحديد أبعاد الشاشة لتكون ثابتة
    return ScreenUtilInit(
      designSize: const Size(375, 812), // أبعاد شائعة للهواتف
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          // 1. شريط التطبيق (AppBar) بتصميم نظيف
          appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'خروج',
          onPressed: () => Navigator.pop(context), // وظيفة الرجوع
        ),
            title: _reusableText(
              "مركز المساعدة والدعم",
              _appStyle(18.sp, _kLightWhite, FontWeight.w700),
            ),
            backgroundColor: kBlueDark,
            centerTitle: true,
            elevation: 0, // إزالة الظل لإطلالة حديثة
          ),
          // 2. جسم الصفحة (Body) مع تباعد مناسب
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان رئيسي
                Text(
                  "الخدمات المتوفرة",
                  style: _appStyle(24.sp, Colors.black87, FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                Text(
                  "اختر نوع الدعم الذي تحتاجه:",
                  style: _appStyle(14.sp, Colors.grey, FontWeight.w500),
                ),
                SizedBox(height: 30.h),

                // 3. شبكة الأيقونات (GridView) بتصميم حديث
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25.h,
                    crossAxisSpacing: 20.w,
                    childAspectRatio: 0.9, // تعديل النسبة لجعل البطاقات مربعة تقريباً
                    children: [
                      // استخدام أيقونات عصرية (مُعبأة أو مدمجة)
                      _serviceCard(Icons.support_agent_rounded, "الدعم الفني"),
                      _serviceCard(Icons.receipt_long_rounded, "الفواتير والمدفوعات"),
                      _serviceCard(Icons.delivery_dining_rounded, "تتبع الطلبات والتوصيل"),
                      _serviceCard(Icons.question_answer_rounded, "الأسئلة الشائعة (FAQ)"),
                    ],
                  ),
                ),

                // 4. زر التحويل (الزر الوهمي)
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // **ملاحظة:** هنا يمكنك وضع دالة التنقل الفعلي
                      // مثال: Navigator.push(context, MaterialPageRoute(builder: (context) => ServicesDetailsScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('')),
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded, color: kLightWhite, size: 18.sp),
                    label: Text(
                      "انتقل لتفاصيل الخدمات",
                      style: _appStyle(16.sp, _kLightWhite, FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBlueDark,
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // **دالة بناء بطاقة الخدمة (Service Card) بتصميم مُحسّن**
  Widget _serviceCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.blue.shade50, width: 2), // حدود خفيفة
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1), // ظل أزرق خفيف
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material( // استخدام Material لتمكين تأثيرات النقر (مثل Splash)
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // هنا يمكن وضع دالة التعامل مع النقر على البطاقة (مثل فتح صفحة الدعم الفني)
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 55.sp, color: _kPrimaryColor),
                SizedBox(height: 15.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: _appStyle(15.sp, Colors.black87, FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Text(
                  "اضغط للمساعدة",
                  style: _appStyle(12.sp, Colors.blueGrey, FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}