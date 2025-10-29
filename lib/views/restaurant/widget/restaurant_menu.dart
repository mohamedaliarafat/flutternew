import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/hooks/fetch_foods.dart';
import 'package:foodly/views/home/widgets/food_tile.dart';

class RestaurantMenuWidget extends HookWidget {
  const RestaurantMenuWidget( {super.key, required this.restaurantId,});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFoods(restaurantId);
    final foods = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return Scaffold(
      backgroundColor: kLightWhite,
      body: isLoading
          ? const FoodsListShimmer()
          : SizedBox(
              height: hieght * 0.7,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return FoodTile(food: food);
                },
              ),
            ),
    );
  }
}
