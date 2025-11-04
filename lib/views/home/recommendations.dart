import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/hooks/fetch_all_foods.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/views/home/widgets/food_tile.dart';

class Recommendations extends HookWidget {
  const Recommendations({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllFoods("41007428");
    List<FoodsModel>? foods = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'خروج',
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.3,
        backgroundColor: kBlueDark,
        title: ReusableText(
          text: "جديدنا",
          style: appStyle(17, kWhite, FontWeight.bold),
          tex: "",
        ),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: isLoading
              ? const FoodsListShimmer()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: foods!.length,
                  itemBuilder: (context, i) {
                    FoodsModel food = foods[i];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ الصورة في الأعلى
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  food.imageUrl as String,
                                  height: 160.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: 160.h,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.broken_image, size: 40),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.h),

                              // ✅ الاسم
                              Text(
                                food.title ?? "بدون اسم",
                                style: appStyle(16, kBlueDark, FontWeight.w600),
                              ),

                              SizedBox(height: 5.h),

                              // ✅ الوصف
                              Text(
                                food.description ?? "لا يوجد وصف",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: appStyle(13, Colors.grey, FontWeight.normal),
                              ),

                              SizedBox(height: 8.h),

                              // ✅ السعر
                              Text(
                                "${food.price ?? 0} ر.س",
                                style: appStyle(15, Colors.green.shade700, FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
