import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';

class RestaruantWidget extends StatelessWidget {
  const RestaruantWidget({super.key, required this.image, required this.logo, required this.time, required this.rating, this.onTap, required String title});

  final String image;
  final String logo;
  final String time;
  final String rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: width* .75,
          height: 192.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: kLightWhite
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
            
              Padding(
                padding: EdgeInsets.all(8.w),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      height: 112.h,
                      width: width* 0.8,
                      child: Image.network(image, fit: BoxFit.fitWidth,),

                    ),
                  ),

                  Positioned(
                    
                    top: 10.w,
                    right: 10.w,
                    width: 10.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Container(
                        color: kLightWhite,
                        child: Padding(padding: EdgeInsets.all(2.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: Image.network(logo, fit: BoxFit.cover,   height: 20.h, width: 20.w,),
                        ),
                        ),
                      ),
                    ))

                ],
              ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(text: "شركة البحيرة العربية - Al-Buhaira Al-Arabia Co.", style: appStyle(12, kDark, FontWeight.w500), tex: ""),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         ReusableText(text: "وقت التوصيل", 
                         style: appStyle(9, kGray, FontWeight.w500), tex: ""),


                         ReusableText(text: time, 
                         style: appStyle(9, kDark, FontWeight.w500), tex: "time"),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          
                          rating: 5, 
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: const Color.fromARGB(255, 14, 34, 65),
                          ),
                          itemCount: 5,
                          itemSize: 15.h,
                        
                        ),
                        SizedBox(width: 10.w,),
                        ReusableText(text: "+ $rating reviews and ratings", style: 
                        appStyle(9, kGray, FontWeight.w500), tex: "")

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}