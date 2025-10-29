import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/views/restaurant/directions_page.dart';
import 'package:foodly/views/restaurant/restaurant_page.dart';
import 'package:get/get.dart';

class RestaurantTopBar extends StatelessWidget {
  const RestaurantTopBar({
    super.key,
    required this.widget,
  });

  final RestaurantPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
          Ionicons.chevron_back_circle, 
          size: 30,
          color: kBlueDark,
          ),
        ),
        ReusableText(
          text: widget.restaurant!.title, 
          style: appStyle(16, kDark, FontWeight.w600), tex: "tex"),
         GestureDetector(
          onTap: () {
            Get.to(() => const CompanyLocationPage());
          },
          child: const Icon(
          Ionicons.location, 
          size: 30,
          color: kBlueDark,
          ),
        )
      ],
    )
    );
  }
}
