import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final IconData icon;
  final Color? iconColor; // لتلوين الأيقونة
  final bool isFirst; // إذا كان العنصر الأول في البطاقة
  final bool isLast;  // إذا كان العنصر الأخير في البطاقة

  const ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(15.r) : Radius.zero,
          bottom: isLast ? Radius.circular(15.r) : Radius.zero,
        ),
        color: kLightWhite,
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        minLeadingWidth: 0,
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? kBlueDark,
          size: 24.sp,
        ),
        title: ReusableText(
          text: title,
          style: appStyle(15, Colors.black87, FontWeight.normal),
          tex: "",
        ),
        trailing: title != "الإعدادات" // حسب اللغة العربية
            ? Icon(
                Ionicons.chevron_forward,
                size: 18.sp,
                color: Colors.grey,
              )
            : SvgPicture.asset(
                "assets/icons/sa.svg",
                width: 15.w,
                height: 20.h,
              ),
      ),
    );
  }
}
