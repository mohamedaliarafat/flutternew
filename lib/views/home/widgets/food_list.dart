import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/shimmers/nearby_shimmer.dart';
import 'package:foodly/hooks/fetch_foods.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/views/home/widgets/food_tile.dart'; // ✅ استيراد البطاقة الجديدة
import 'package:foodly/constants/constants.dart';

class FoodsList extends HookWidget {
  const FoodsList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFoods("41007428");
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Directionality(
      textDirection: TextDirection.rtl, // ✅ دعم اللغة العربية
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: isLoading
            ? const NearbyShimmer() // ✅ عند التحميل
            : (foods == null || foods.isEmpty)
                ? Center(
                    child: Text(
                      "لا توجد منتجات حالياً",
                      style: TextStyle(
                        color: kGray,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: foods.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ كارتين في الصف الواحد
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 0.72, // ✅ تناسب العرض والطول
                    ),
                    itemBuilder: (context, i) {
                      final food = foods[i];
                      return FoodTile(food: food);
                    },
                  ),
      ),
    );
  }
}
