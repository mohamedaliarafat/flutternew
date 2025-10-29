import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';

import 'package:foodly/hooks/fetch_all_categories.dart';
import 'package:foodly/models/categories.dart';
import 'package:foodly/views/categories/widget/category_tile.dart';


class AllCategores extends HookWidget {
  const AllCategores({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllCategories();
    List<CategoriesModel> ?categories = hookResults.data;
    final isLoading = hookResults.isLoading;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        title: ReusableText(
          text: "مزيد من الخدمات",
          style: appStyle(20, kGray, FontWeight.w600), tex: '',
        ),
      ),

      body: BackGroundContainer(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: hieght,
          child: isLoading 
          ? FoodsListShimmer() 
          : ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(categories!.length, (i) {
            CategoriesModel category = categories[i];
              return CategoryTile(category: category);
            }),
          ),
        ),
      ),
    );
  }
}
