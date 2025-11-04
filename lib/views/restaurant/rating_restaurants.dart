import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:get/get.dart'; // **تم إضافة هذا الاستيراد لاستخدام Get.snackbar**

// ---------------------------------------------
// 1. شاشة التقييم
// ---------------------------------------------
class RatingPage extends StatefulWidget {
  // استقبال بيانات المطعم الممررة
  final Restaurant? restaurant;

  const RatingPage({super.key, this.restaurant});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class Restaurant {
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0.0; // التقييم الافتراضي
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // دالة وهمية لإرسال التقييم
  void _submitReview() {
    // هنا يتم بناء منطق إرسال البيانات إلى الخادم (مثل Firebase أو API)

    String reviewText = _reviewController.text;

    print('-----------------------------------------');
    print('تم إرسال التقييم بنجاح:');
    print('  اسم المطعم: ${widget.restaurant}');
    print('  التقييم: $_rating نجوم');
    print('  المراجعة: $reviewText');
    print('-----------------------------------------');

    // ----------------------------------------------------------
    // **** التعديل المطلوب: استخدام Get.snackbar لعرض رسالة في الأعلى ****
    // ----------------------------------------------------------
    Get.snackbar(
      'تم الإرسال بنجاح',
      'شكراً لك! تم إرسال تقييمك بنجاح.',
      snackPosition: SnackPosition.TOP, // **الرسالة ستظهر في أعلى الشاشة**
      backgroundColor: kBlueDark,
      colorText: kLightWhite,
      icon: const Icon(Icons.check_circle_outline, color: kLightWhite),
      margin: const EdgeInsets.all(10),
      borderRadius: 15,
      duration: const Duration(seconds: 3),
    );

    // العودة إلى الشاشة السابقة (تفاصيل المطعم)
    // نؤجل العودة قليلاً للسماح للمستخدم برؤية الرسالة
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // تنسيق المطعم لعرضه
    // String restaurantName = widget.restaurant as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'خروج',
          onPressed: () => Navigator.pop(context), // وظيفة الرجوع
        ),
        title: ReusableText(
            text: "التقييم", style: appStyle(20, kLightWhite, FontWeight.bold), tex: ""),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ************ معلومات المطعم ************
            Text(
              ' تقييمك للشركة: ',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // ************ ويدجت النجوم ************
            const Text(
              'كم تقييمك الإجمالي؟',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true, // للسماح بتقييم نصف نجمة
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            // ************ حقل المراجعة ************
            const Text(
              'اكتب مراجعتك (اختياري):',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'شاركنا رأيك حول الشركة والخدمة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 30),

            // ************ زر الإرسال ************
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: kBlueDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'إرسال التقييم',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}