import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/custom_appbar.dart';
import 'package:foodly/common/heading.dart';
import 'package:foodly/controllers/category_controller.dart';
import 'package:foodly/views/home/all_nerby_restaurants.dart';
import 'package:foodly/views/home/recommendations.dart';
import 'package:foodly/views/home/widgets/food_tile.dart';
import 'package:foodly/hooks/fetch_all_foods.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/views/poster/poster.dart';
import 'package:get/get.dart';


class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final hookResult = useFetchAllFoods("41007428");
    List<FoodsModel>? foods = hookResult.data;
    final isLoading = hookResult.isLoading;

    // ✅ قائمة صور البوسترات (تقدر تغيرها)
    final List<String> bannerImages = [
      "assets/images/122.jpg",
      "assets/images/122.jpg",
      "assets/images/122.jpg",
    ];

    return Scaffold(
      
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.h),
        child: const CustomAppbar(),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo2.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Heading(
                    text: controller.categoryValue == ''
                        ? "أكتشف جديدنا"
                        : " ${controller.titleValue} ",
                    onTap: () {
                      if (controller.categoryValue == '') {
                        Get.to(
                          () => const Recommendations(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 200),
                        );
                      } else {
                        Get.to(
                          () => const AllNerbyRestaurants(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 200),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 5.h),

                  // ✅ بوستر الإعلانات المتحرك (Carousel)
                 Directionality(
                        textDirection: TextDirection.rtl, // الحركة من اليمين لليسار
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 150.h,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            reverse: true, // ✅ يمشي من اليمين لليسار
                          ),
                          items: bannerImages.map((imgPath) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.r),
                                        image: DecorationImage(
                                          image: AssetImage(imgPath),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26.withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 🔹 زرار شفاف فوق الصورة بالكامل
                                    Positioned.fill(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16.r),
                                          onTap: () {
                                            Get.to(() => OffersScreen());
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),

                  SizedBox(height: 15.h),

                  // ✅ قائمة الكروت (الأطعمة)
                  Expanded(
                    child: isLoading
                        ? const FoodsListShimmer()
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 12.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 🟩 كارتين جنب بعض
                              mainAxisSpacing: 10.h,
                              crossAxisSpacing: 5.w,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: foods?.length ?? 0,
                            itemBuilder: (context, index) {
                              final food = foods![index];
                              return FoodTile(food: food);
                            },
                          ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
