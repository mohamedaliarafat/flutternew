import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/custom_appbar.dart';
import 'package:foodly/common/custom_container.dart';
import 'package:foodly/common/heading.dart';
import 'package:foodly/controllers/category_controller.dart';
import 'package:foodly/views/home/all_fast_test.dart';
import 'package:foodly/views/home/all_nerby_restaurants.dart';
import 'package:foodly/views/home/recommendations.dart';
import 'package:foodly/views/home/widgets/category_foods_list.dart';
import 'package:foodly/views/home/widgets/category_list.dart';
import 'package:foodly/views/home/widgets/food_list.dart';
import 'package:foodly/views/home/widgets/nearby_restaurant_list.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 34, 65),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.h), 
        child: const CustomAppbar(),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: Column(
            children: [
              const CategoryList(),  

              Obx(() => controller.categoryValue == ''? Column(
                children: [
                  Heading(
                    text: "شركائنا", 
                    onTap: (){
                      Get.to(
                        () => const AllNerbyRestaurants(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                  ),
                  
                  const NearbyRestaurant(),
                  
                  Heading(
                    text: "أكتشف جديدنا", 
                    onTap: (){
                      Get.to(
                        () => const Recommendations(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                  ),
                  
                  const FoodsList(),
                  
                  Heading(
                    text: "أكتشف الأحدث", 
                    onTap: (){
                      Get.to(
                        () => const AllFastTest(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                  ),
                  
                  const FoodsList(),
                ],
              ): CustomContainer(
                containerContent: Column(
                  children: [
                     Heading(
                        more: true,
                        text: " ${controller.titleValue} ", 
                        onTap: (){
                        Get.to(
                        () => const AllNerbyRestaurants(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 200),
                      );
                    },
                  ),

                  const CategoryFoodsList()
                  ],
                )),
            )   
              ],
          ),
        ),
      ),
    );
  }
}
