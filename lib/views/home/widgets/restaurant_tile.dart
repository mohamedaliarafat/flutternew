import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/restaurants_model.dart';
import 'package:foodly/views/restaurant/restaurant_page.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurant});

  final RestaurantsModel restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       Get.to(() => RestaurantPage(restaurant: restaurant));
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kOffWhite,
              borderRadius: BorderRadius.circular(9.r),
            ),
            padding: EdgeInsets.all(6.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// صورة المطعم
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    children: [
                      Image.network(
                        restaurant.imageUrl,
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.only(left: 4.w),
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.5),
                          height: 16.h,
                          width: 70.w,
                          child: RatingBarIndicator(
                            rating: restaurant.rating.toDouble(),
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: kSecondary,
                            ),
                            itemSize: 12.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                /// النصوص
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: restaurant.title,
                        style: appStyle(12, kDark, FontWeight.w600),
                        tex: 'title',
                      ),
                      ReusableText(
                        text: "${restaurant.time} : وقت التوصيل",
                        style: appStyle(11, kGray, FontWeight.w400),
                        tex: 'time',
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        restaurant.coords.address,
                        overflow: TextOverflow.ellipsis,
                        style: appStyle(10, kDark, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// حالة التوفر (مفتوح/مغلق)
          Positioned(
            right: 10.w,
            top: 6.h,
            child: Container(
              width: 60.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: (restaurant.isAvailable == true)
                    ? kBlueDark
                    : kGray,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: ReusableText(
                  text: (restaurant.isAvailable == true) ? "متاح" : "غير متاح",
                  style: appStyle(11, kLightWhite, FontWeight.w600),
                  tex: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
