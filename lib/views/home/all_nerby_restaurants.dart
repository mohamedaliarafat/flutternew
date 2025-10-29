import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/hooks/fetch_all_restaurant.dart';
import 'package:foodly/models/restaurants_model.dart';
import 'package:foodly/views/home/widgets/restaurant_tile.dart';

import '../../common/reusable_text.dart';

class AllNerbyRestaurants extends HookWidget {
  const AllNerbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {

    final hookResult = useFetchAllRestaurants("41007428");
    List<RestaurantsModel>? restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Scaffold(
      
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'خروج',
          onPressed: () => Navigator.pop(context), // وظيفة الرجوع
        ),
        elevation: 0,
        backgroundColor: kBlueDark,
        title: ReusableText(text: "شركائنا", style: appStyle(17, kWhite, FontWeight.bold), tex: "")
      ),
      body:  BackGroundContainer(
        color: Colors.white,
        child: isLoading 
          ? FoodsListShimmer() 
          :
        
         Padding(
          padding: EdgeInsets.all(12.h),
          child:  ListView(
          children:
          List.generate(restaurants!.length, (i) {
            // ignore: unused_local_variable
            RestaurantsModel restaurant = restaurants[i];
            return RestaurantTile(
              restaurant: restaurant,
            );
            }),
          
                ),
        ), 
        ),
        );
    
  }
}