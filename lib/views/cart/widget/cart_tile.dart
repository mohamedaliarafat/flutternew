import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/cart_controller.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:get/get.dart';

class CartTile extends StatelessWidget {
  const CartTile({super.key, required this.cart, this.color, this.refetch});

  final CartResponse cart;
  final Color? color;
  final Function()? refetch;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    // حجم ثابت ومناسب لعنصر السلة
    final tileHeight = 90.h;
    final imageSize = 80.w;

    return GestureDetector(
      onTap: () {
        // Get.to(() => FoodPage(cart: cart));
      },
      // ----------------------------------------------------
      // استخدام Container واحد كبطاقة جذابة
      // ----------------------------------------------------
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h), // مسافة أكبر بين العناصر
        height: tileHeight,
        width: width,
        decoration: BoxDecoration(
          color: color ?? kOffWhite,
          borderRadius: BorderRadius.circular(15.r), // زوايا دائرية أكبر وأكثر نعومة
          boxShadow: [
            BoxShadow(
              color: kGray.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        
        // ----------------------------------------------------
        // المحتوى الداخلي
        // ----------------------------------------------------
        child: Padding(
          padding: EdgeInsets.all(5.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // -------------------
              // 1. الصورة والتقييم
              // -------------------
              _buildImageAndRating(imageSize),

              SizedBox(width: 15.w),

              // -------------------
              // 2. تفاصيل المنتج
              // -------------------
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    ReusableText(
                      text: cart.productId.title,
                      style: appStyle(14, kDark, FontWeight.bold), // خط أثقل وأوضح
                      tex: "",
                    ),

                    SizedBox(height: 4.h),

                    // الإضافات (Additives)
                    _buildAdditivesSection(),

                    SizedBox(height: 4.h),

                    // سعر الوحدة والوقت (يمكن إضافة سعر الوحدة هنا إن وجد)
                    ReusableText(
                      // مثال على عرض سعر الوحدة أو وقت التوصيل بطريقة أنيقة
                      text: "الكمية: ${cart.quantity}",
                      style: appStyle(12, kGray, FontWeight.w500),
                      tex: "",
                    ),
                  ],
                ),
              ),

              // -------------------
              // 3. السعر وأزرار التحكم (الحذف)
              // -------------------
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // السعر الكلي للكمية
                    _buildTotalPriceBadge(),

                    // زر الحذف (أصبح جزءاً من التصميم بدلاً من Positioned)
                    _buildDeleteButton(controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // مكونات مساعدة
  // ----------------------------------------------------

  Widget _buildImageAndRating(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Image.network(
              cart.productId.imageUrl[0], 
              fit: BoxFit.cover,
              // Fallback for better UX
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Center(child: Icon(Icons.broken_image, size: 30.r, color: kGray)),
              ),
            ),
          ),
          
          // شريط التقييم الأنيق
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: kDark.withOpacity(0.7), // خلفية داكنة شفافة
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Center(
                child: RatingBarIndicator(
                  rating: cart.productId.rating.toDouble(), // يفترض وجود خاصية rating
                  itemCount: 5,
                  itemBuilder: (context, i) => const Icon(
                    Icons.star,
                    color: kPrimary, // لون مميز للنجوم
                  ),
                  itemSize: 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditivesSection() {
    return SizedBox(
      height: 20.h, // ارتفاع محدد للإضافات
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cart.additives.length,
        itemBuilder: (context, i) {
          var additive = cart.additives[i];
          return Container(
            margin: EdgeInsets.only(right: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.1), // لون خفيف وأنيق
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: kPrimary.withOpacity(0.5)) // حدود خفيفة
            ),
            child: Center(
              child: ReusableText(
                text: additive,
                style: appStyle(10, kDark, FontWeight.w500), // خط أوضح وأغمق
                tex: "",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalPriceBadge() {
    return Container(
      width: 70.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: kSecondary, // لون مميز للسعر
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: kSecondary.withOpacity(0.5),
            blurRadius: 5,
          )
        ]
      ),
      child: Center(
        child: ReusableText(
          text: "${cart.totalPrice.toStringAsFixed(2)} ر.س",
          style: appStyle(13, kLightWhite, FontWeight.bold),
          tex: "",
        ),
      ),
    );
  }

  Widget _buildDeleteButton(CartController controller) {
    return GestureDetector(
      onTap: () {
        // عملية الحذف الأصلية
        controller.removeFromCart(cart.id, refetch!);
      },
      child: Container(
        width: 35.w, // حجم مناسب
        height: 35.h,
        decoration: BoxDecoration(
          color: kRed,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Icon(
            MaterialCommunityIcons.trash_can,
            size: 20.h,
            color: kLightWhite,
          ),
        ),
      ),
    );
  }
}