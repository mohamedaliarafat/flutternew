import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/hooks/fetch_foods.dart';
import 'package:foodly/views/home/widgets/food_tile.dart';

class XploreWidget extends HookWidget {
  const XploreWidget({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFoods(code);
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
