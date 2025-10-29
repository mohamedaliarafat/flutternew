import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/constants/constants.dart';

// **ملاحظة:** تم استبدال الدوال والكلاسات المفقودة
// (appStyle, ReusableText, kLightWhite, constants) 
// بمكافئات Flutter القياسية لتشغيل الكود.

class AppFeedback extends StatefulWidget {
  const AppFeedback({Key? key}) : super(key: key);

  @override
  State<AppFeedback> createState() => _AppFeedbackState();
}

class _AppFeedbackState extends State<AppFeedback> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;

  // **استبدال الدوال المفقودة بمكافئات Flutter القياسية**
  final Color _kPrimaryColor = kBlueDark; // أزرق داكن
  final Color _kLightWhite = Colors.white;

  TextStyle _appStyle(double size, Color color, FontWeight weight) {
    return TextStyle(fontSize: size.sp, color: color, fontWeight: weight);
  }

  Widget _reusableText(String text, TextStyle style) {
    return Text(text, style: style);
  }

  @override
  Widget build(BuildContext context) {
    // تثبيت أبعاد الشاشة
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
              "تقييم وملاحظات التطبيق",
              _appStyle(18, _kLightWhite, FontWeight.w700),
            ),
            backgroundColor: _kPrimaryColor,
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. بطاقة التقييم (Rating Card)
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _reusableText(
                          "ما هو تقييمك للتطبيق؟",
                          _appStyle(18, Colors.black87, FontWeight.bold),
                        ),
                        SizedBox(height: 15.h),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < _rating ? Icons.star_rate_rounded : Icons.star_border_rounded,
                                  color: Colors.amber.shade700,
                                  size: 40.sp, // زيادة حجم النجمة
                                ),
                                onPressed: () {
                                  setState(() {
                                    _rating = index + 1;
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                           child: Text(
                             _getRatingLabel(_rating),
                             style: _appStyle(14, Colors.grey.shade600, FontWeight.w500),
                           ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 30.h),

                // 3. بطاقة الملاحظات (Feedback Card)
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _reusableText(
                          "ملاحظاتك واقتراحاتك",
                          _appStyle(18, Colors.black87, FontWeight.bold),
                        ),
                        SizedBox(height: 15.h),
                        TextField(
                          controller: _feedbackController,
                          maxLines: 6,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: "شاركنا رأيك حول ما أعجبك أو ما يحتاج إلى تحسين...",
                            hintStyle: _appStyle(14, Colors.grey.shade400, FontWeight.normal),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none, // إزالة حدود الحقل الافتراضية
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: _kPrimaryColor, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // 4. زر الإرسال (Submit Button)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r), // زر مستدير
                      ),
                      elevation: 8,
                    ),
                    onPressed: _submitFeedback,
                    child: _reusableText(
                      "إرسال الملاحظات",
                      _appStyle(16, _kLightWhite, FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // دالة مساعدة للحصول على وصف التقييم
  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return "سيئ جداً";
      case 2:
        return "ضعيف";
      case 3:
        return "جيد";
      case 4:
        return "جيد جداً";
      case 5:
        return "ممتاز!";
      default:
        return "اضغط لتقييم التطبيق";
    }
  }

  // دالة معالجة الإرسال
  void _submitFeedback() {
    final String feedback = _feedbackController.text.trim();
    final int rating = _rating;
    
    // التحقق من الإدخال
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء تحديد تقييم بالنجوم أولاً.")),
      );
      return;
    }
    
    if (feedback.isEmpty && rating < 4) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("نقدر ملاحظاتك، يرجى كتابة تعليق لتحسين الخدمة.")),
      );
      // يمكن السماح بالتقييم المرتفع دون تعليق
    }
    
    // تنفيذ منطق الإرسال (API Call, Database Save, etc.)
    
    // عرض رسالة نجاح ومسح الحقول
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("شكراً لك! تم استلام ملاحظاتك بنجاح."),
        backgroundColor: Colors.green,
      ),
    );
    
    _feedbackController.clear();
    setState(() {
      _rating = 0;
    });
  }
}