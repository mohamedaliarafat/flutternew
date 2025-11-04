import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/custom_text_field.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/common/logo_transition.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/cart_controller.dart';
import 'package:foodly/controllers/foods_controller.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/hooks/fetch_restaurant.dart';
import 'package:foodly/models/cart_request.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/models/login_response.dart';
import 'package:foodly/models/order_request.dart';
import 'package:foodly/models/restaurants_model.dart';
import 'package:foodly/views/auth/OtpVerificationScreen.dart';
import 'package:foodly/views/auth/PhoneInputScreen.dart';
import 'package:foodly/views/orders/order_page.dart';
import 'package:foodly/views/restaurant/restaurant_page.dart';

class FoodPage extends StatefulHookWidget {
  const FoodPage({super.key, required this.food});
  final FoodsModel food;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController _preferences = TextEditingController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // final cartController = Get.put(CartController());
    // يجب أن يتم تعريف AuthController هنا، بافتراض أنه موجود كجزء من الكود الأصلي.
    // تم الافتراض أنه تم إحضاره بشكل صحيح في الكود الأصلي (كما هو موضح في الـ imports)
    final authController = Get.put(AuthController()); 
    final controller = Get.put(FoodsController());

    final hookResult = useFetchRestaurant(widget.food.restaurant);
    RestaurantsModel? restaurant = hookResult.data;
    User? user = authController.getUserInfo() as User?;

    return Directionality(
      textDirection: TextDirection.rtl, // الاتجاه العربي (RTL)
      child: Scaffold(
        backgroundColor: kOffWhite,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ===== صورة المنتج (مع التعديلات الأنيقة) =====
            Stack(
              children: [
                SizedBox(
                  height: 350.h, // زيادة الارتفاع قليلاً
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => controller.changePage(i),
                    itemCount: widget.food.imageUrl.length,
                    itemBuilder: (context, i) => CachedNetworkImage(
                      imageUrl: widget.food.imageUrl[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                // مؤشر الصفحات
                Positioned(
                  bottom: 15.h,
                  right: 0,
                  left: 0,
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.food.imageUrl.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: controller.currentPage == index ? 12.w : 8.w,
                            height:
                                controller.currentPage == index ? 12.h : 8.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.currentPage == index
                                  ? kPrimary // لون بارز
                                  : Colors.white.withOpacity(0.7), // لون فاتح وأنيق
                            ),
                          ),
                        ),
                      )),
                ),

                // زر الرجوع بتصميم راقي
                Positioned(
                  top: 50.h, // إبعاد أكثر عن الحافة
                  right: 20.w, // يمين للـ RTL
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 45.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95), // خلفية شبه بيضاء صلبة
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kDark.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Ionicons.chevron_back,
                        color: kBlueDark, // استخدام الكحلي الداكن
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // زر صفحة المتجر
                Positioned(
                  bottom: 30.h, // تعديل الموضع
                  left: 20.w, // الجهة المعاكسة
                  child: CustomButton(
                    onTap: () {
                      Get.to(() => RestaurantPage(restaurant: restaurant));
                    },
                    btnWidth: 130.w, // عرض أوسع
                    text: 'صفحة المتجر',
                    // التأكد من أن الزر يظهر بوضوح فوق الصورة
                                      ),
                ),
              ],
            ),

            // ===== تفاصيل المنتج =====
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h), // زيادة Padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: widget.food.title,
                    style: appStyle(20, kDark, FontWeight.bold), // خط أكبر للعنوان
                    tex: "",
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.food.description,
                    style: appStyle(14, kGray, FontWeight.w400),
                    textAlign: TextAlign.justify,
                  ),

                  SizedBox(height: 20.h),

                  // ===== السعر =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "السعر",
                        style: appStyle(16, kDark, FontWeight.bold),
                        tex: "",
                      ),
                      ReusableText(
                        text:
                            "﷼ ${widget.food.price.toStringAsFixed(2)}",
                        style: appStyle(16, kBlueDark, FontWeight.w700), // سعر بارز باللون الكحلي
                        tex: "",
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h), // مسافة أكبر قبل الكمية

                  // ===== التحكم بالكمية (أيقونات ممتلئة وعصرية) =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "الكمية",
                        style: appStyle(16, kDark, FontWeight.bold),
                        tex: "",
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: controller.increment,
                            child: Icon(
                              AntDesign.pluscircle, // أيقونة ممتلئة
                              color: kBlueDark, // لون كحلي
                              size: 30.h,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            child: Obx(() => Text(
                                  "${controller.count.value}",
                                  style: appStyle(17, kDark, FontWeight.w600),
                                )),
                          ),
                          GestureDetector(
                            onTap: controller.decrement,
                            child: Icon(
                              AntDesign.minuscircle, // أيقونة ممتلئة
                              color: kRed,
                              size: 30.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // ===== الملاحظات =====
                  ReusableText(
                    text: "ملاحظات الطلب (اختياري)",
                    style: appStyle(16, kDark, FontWeight.w600),
                    tex: "",
                  ),
                  SizedBox(height: 10.h),
                  CustomTextWidget(
                    controller: _preferences,
                    hintText: "أضف ملاحظة أو تفضيل خاص...",
                    maxLines: 3,
                  ),

                  SizedBox(height: 40.h), // مسافة كبيرة قبل الأزرار النهائية

                  // ===== أزرار الطلب والسلة =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // زر "اطلب الآن" الرئيسي
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBlueDark, // اللون الكحلي الداكن
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r), // حواف أكثر استدارة
                            ),
                            padding: EdgeInsets.symmetric(vertical: 18.h), // ارتفاع أكبر للزر
                            elevation: 5, // إضافة ظل بسيط
                          ),
                          onPressed: () {
                            if (user == null || user.phoneVerification == false) {
                              Get.to(() => user == null
                                  ? const PhoneInputScreen()
                                  : OtpVerificationScreen(phoneNumber: user.phone));
                              return;
                            }

                            final price = widget.food.price * controller.count.value;

                            final item = OrderItem(
                              foodId: widget.food.id,
                              quantity: controller.count.value,
                              price: price,
                              additives: [],
                              instructions: _preferences.text,
                            );

                            Get.to(
                              () => LogoTransition(
                                nextPage: OrderPage(
                                  item: item,
                                  restaurant: restaurant,
                                  food: widget.food,
                                ),
                              ),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          child: Text(
                            "اطلب الآن",
                            style: appStyle(18, kLightWhite, FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),

                      // زر السلة الثانوي
                      GestureDetector(
                        onTap: () {
                          if (user == null) {
                            Get.to(() => const PhoneInputScreen());
                            return;
                          }

                          final price = widget.food.price * controller.count.value;

                          // final data = CartRequest(
                          //   productId: widget.food.id,
                          //   additives: [],
                          //   quantity: controller.count.value,
                          //   totalPrice: price,
                          // );

                          // cartController.addToCart(data);
                        },
                        child: Container(
                          width: 55.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: kSecondary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kSecondary.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Ionicons.cart,
                            color: kLightWhite,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
