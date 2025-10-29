import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/shimmers/nearby_shimmer.dart';
import 'package:foodly/hooks/fetch_foods.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/views/food/food_page.dart';
import 'package:foodly/views/home/widgets/food_widget.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';

class FoodsList extends HookWidget {
  const FoodsList({super.key});


  
  @override
  Widget build(BuildContext context) {
     final hookResult = useFetchFoods("41007428");
    List<FoodsModel>?foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    // ignore: unused_local_variable
    final error = hookResult.error;

    
    return Container(
      height: 190.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: isLoading ? const NearbyShimmer() : ListView(
        scrollDirection: Axis.horizontal,
        children:
        List.generate(foods!.length, (i) {
          FoodsModel food = foods[i]; 
          // TODO: Return a widget for each restaurant here
          return FoodWidget(
            onTap: () {
              Get.to(() => FoodPage(food: food));
            },
            image: food.imageUrl[0],
            title: food.title,
            time: food.time, 
            price: food.price.toStringAsFixed(2),
          ); // Placeholder, replace with your widget
        }
        ),
        
      ),
    );
  }
}