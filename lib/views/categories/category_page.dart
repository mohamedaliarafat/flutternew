import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/category_controller.dart';
import 'package:foodly/hooks/fetch_category_foods.dart';
import 'package:foodly/models/categories.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({super.key, required CategoriesModel category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final hookResult = useFetchFoodsByCategory("41007428");
    List<FoodsModel>? foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    return  Scaffold(
      
      appBar: AppBar(
        backgroundColor: kGray,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            controller.updateCategory = "";
            controller.updateCategory = "";
          Get.back();
        },
        icon:  const Icon(Icons.arrow_back_ios, color: kDark),
        ),
        title: ReusableText(text: "${controller.titleValue} Category", style: appStyle(13, kGray, FontWeight.w600), tex: ""),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: SizedBox(
          height: hieght,
          child: isLoading 
          ? FoodsListShimmer() 
          : Padding(
          padding: EdgeInsets.all(12.h),
          child:  ListView(
          children:
          List.generate(foods!.length, (i) {
            // ignore: unused_local_variable
            FoodsModel food = foods[i];
            return FoodTile(
              food: food,
            
             
            );
            }),
          
                ),
        ),     
        ),
      ),
    );
  }
}

class Kgray {
}