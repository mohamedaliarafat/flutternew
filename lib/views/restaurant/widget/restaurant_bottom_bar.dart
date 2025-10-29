import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/constants/uidata.dart';
import 'package:foodly/views/restaurant/rating_restaurants.dart';
import 'package:foodly/views/restaurant/restaurant_page.dart';
import 'package:get/get.dart';

class RestaurantBottomBar extends StatelessWidget {
  const RestaurantBottomBar({
    super.key,
    required this.widget,
  });

  final RestaurantPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      width: width,
      height: 40.h,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: kPrimary.withOpacity(0.4),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.r),
          topLeft: Radius.circular(8.r) 
        )
      ),
    
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RatingBarIndicator(
            itemCount: 5,
            itemSize: 30,
            rating: widget.restaurant!.rating.toDouble(),
            itemBuilder: (context, i) => const Icon(
              Icons.star, color: Colors.yellow,)),
    
              CustomButton(
                onTap: () {
                   Get.to(() => RatingPage()); 
                },
                btnColor: kBlueDark,
                btnWidth: width/2.5,
                text: "Rating Company")
        ],
      ),
    );
  }
}