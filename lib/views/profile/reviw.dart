import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'dart:math'; // لاستخدام توليد أرقام عشوائية

class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

  // ------------------------------------------------------------------
  // دالة لتوليد 100 مراجعة وهمية (عربية لشركة نقل وقود)
  // ------------------------------------------------------------------

  List<Map<String, dynamic>> _generateReviews(int count) {
    final Random random = Random();
    final List<String> names = [
      "عبد الله السالم", "فيصل المحمد", "مؤسسة الأمان", "سعد خالد", "شركة البترول الوطنية",
      "علي بن راشد", "خالد العتيبي", "ناصر الهاجري", "فاطمة أحمد", "مروة علي",
      "محمد جاسم", "يوسف الدوسري", "شركة المستقبل", "مؤسسة النور", "ماجد الحربي",
      "هند القحطاني", "سارة العنزي", "أحمد العسيري", "سلطان المرزوق", "نورة الغامدي"
    ];

    final List<String> positiveComments = [
      "خدمة ممتازة واحترافية عالية. تم التوصيل في الموعد المحدد وبأقصى درجات الأمان.",
      "سرعة في الاستجابة وجودة في النقل. السائقون مدربون ولديهم خبرة كبيرة.",
      "أفضل شريك لوجستي في المنطقة. الالتزام بالمعايير البيئية والسلامة هو نقطة قوتهم.",
      "موثوقية عالية جداً، لم نواجه أي مشكلة في أكثر من عشر شحنات.",
      "تعامل راقي وخدمة عملاء ممتازة، حلوا مشكلتي بسرعة قياسية.",
    ];
    final List<String> mixedComments = [
      "تجربة جيدة جداً، لكن أسعار النقل ارتفعت قليلاً مؤخراً.",
      "كان هناك تأخير بسيط في إحدى الشحنات، لكن الخدمة بشكل عام مقبولة.",
      "التواصل ممتاز، لكن نتطلع إلى تحسين دقة تتبع الشحنات.",
      "التوصيل كان سريعاً، لكن الفاتورة كانت غير واضحة قليلاً.",
    ];
    final List<String> negativeComments = [
      "نتمنى تحسين دقة المواعيد، حدث تأخير غير مبرر.",
      "واجهت صعوبة في التواصل مع خدمة العملاء في وقت متأخر.",
      "كانت هناك مشكلة بسيطة في التسليم، نتمنى التركيز على التفاصيل.",
    ];
    
    final List<Map<String, dynamic>> generatedReviews = [];

    for (int i = 0; i < count; i++) {
      String name = names[random.nextInt(names.length)];
      int rating;
      String comment;
      String date;

      // توزيع التقييمات: أغلبها جيد/ممتاز (4 أو 5 نجوم)
      int score = random.nextInt(100);
      if (score < 70) { // 70% 4 أو 5 نجوم
        rating = random.nextInt(2) + 4; // 4 أو 5
        comment = positiveComments[random.nextInt(positiveComments.length)];
      } else if (score < 90) { // 20% 3 نجوم
        rating = 3;
        comment = mixedComments[random.nextInt(mixedComments.length)];
      } else { // 10% 1 أو 2 نجوم
        rating = random.nextInt(2) + 1; // 1 أو 2
        comment = negativeComments[random.nextInt(negativeComments.length)];
      }

      // تنويع وهمي للتاريخ
      if (i < 5) {
        date = "منذ يومين";
      } else if (i < 15) {
        date = "منذ أسبوع";
      } else if (i < 50) {
        date = "منذ شهر";
      } else {
        date = "منذ 3 أشهر";
      }

      generatedReviews.add({
        "name": name + (i > 0 ? " ($i)" : ""), // إضافة رقم لتمييز الأسماء المكررة
        "rating": rating,
        "comment": comment,
        "date": date,
      });
    }
    return generatedReviews;
  }

  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviews = _generateReviews(100);

    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        title: ReusableText(
          text: "مراجعات وتقييمات العملاء (100+)", 
          style: appStyle(20, kLightWhite, FontWeight.bold), 
          tex: "tex",
        ),
        backgroundColor: kBlueDark, 
        centerTitle: true,
        elevation: 0, 
        iconTheme: const IconThemeData(color: kLightWhite), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // ------------------------------------------------------------------
      // استخدام ListView.builder للتعامل بكفاءة مع 100 عنصر
      // ------------------------------------------------------------------
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: ListView.separated(
          itemCount: reviews.length,
          separatorBuilder: (context, index) => SizedBox(height: 18.h),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return _buildModernReviewCard(
              review['name'],
              review['rating'],
              review['comment'],
              review['date'],
            );
          },
        ),
      ),
    );
  }

  // ودجت بناء بطاقة المراجعة الحديثة (بدون تغيير في التصميم)
  Widget _buildModernReviewCard(String name, int rating, String comment, String date) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: kLightWhite,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: kBlueDark,
                child: Icon(Ionicons.person_outline, color: kLightWhite, size: 22),
              ),
              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: name,
                      style: appStyle(16, kDark, FontWeight.bold),
                      tex: "tex",
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      text: date,
                      style: appStyle(12, kGray, FontWeight.normal),
                      tex: "tex",
                    ),
                  ],
                ),
              ),
              
              _buildRatingStars(rating),
            ],
          ),
          
          SizedBox(height: 15.h),
          const Divider(height: 1, color: Colors.grey, thickness: 0.1),
          SizedBox(height: 15.h),

          Text(
            comment,
            style: appStyle(15, kDark, FontWeight.normal),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
  
  // ودجت مساعد لعرض النجوم
  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: 20.sp,
        );
      }),
    );
  }
}