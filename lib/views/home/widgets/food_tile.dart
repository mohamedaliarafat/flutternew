import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/cart_controller.dart';
import 'package:foodly/models/cart_request.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/views/food/food_page.dart';
import 'package:foodly/views/request_order.dart/request_page.dart' hide kGrayLight;
import 'package:foodly/views/screens/order_water_page.dart';
import 'package:get/get.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({super.key, required this.food, this.color});

  final FoodsModel food;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.isRegistered<CartController>()
    //     ? Get.find<CartController>()
    //     : Get.put(CartController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        // onTap: () => Get.to(() => FoodPage(food: food)),
        child: Container(
          width: (Get.width / 2) - 20, // ✅ عرض متناسق مع GridView
          height: 240.h, // ✅ ارتفاع مضبوط
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🖼 صورة المنتج
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: Image.network(
                  food.imageUrl.isNotEmpty ? food.imageUrl[0] : '',
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120.h,
                    color: kGrayLight,
                    child: Center(
                      child: Icon(Ionicons.fast_food_outline,
                          color: kGray, size: 35.w),
                    ),
                  ),
                ),
              ),

              // 🧾 العنوان والسعر
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ReusableText(
                            text: food.title,
                            style: appStyle(13, kDark, FontWeight.bold),
                            tex: "",
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ReusableText(
                          //   text: "السعر",
                          //   style: appStyle(11, kGray, FontWeight.w500),
                          //   tex: "",
                          // ),
                          // ReusableText(
                          //   text: "﷼ ${food.price.toStringAsFixed(2)}",
                          //   style: appStyle(12, kBlueDark, FontWeight.bold),
                          //   tex: "",
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 🛒 زر أضف للسلة
              Padding(
                padding:
                    EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h, top: 4.h),
                child: ElevatedButton.icon(
                  icon: const Icon(Ionicons.cash,
                      color: kLightWhite, size: 16),
                  label: ReusableText(
                    text: "أطلب الأن",
                    style: appStyle(12, kLightWhite, FontWeight.w600),
                    tex: "",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBlueDark,
                    minimumSize: Size(double.infinity, 34.h), // ✅ زر بحجم متناسق
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                 onPressed: () {
                        Get.to(() => OrderWaterPage());
                        
                        // إذا أردت إضافة المنتج إلى العربة لاحقاً، يمكنك تفعيل هذا الجزء
                        // final data = CartRequest(
                        //   productId: food.id,
                        //   additives: [],
                        //   quantity: 1,
                        //   totalPrice: food.price,
                        // );
                        // controller.addToCart(data);
                      },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
