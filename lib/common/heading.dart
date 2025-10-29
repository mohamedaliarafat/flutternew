import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.text, this.onTap, this.more});

  final String text;
  final void Function()? onTap;
  final bool? more;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: EdgeInsets.only(top: 10.h),
          child: ReusableText(text: text, style: appStyle(16, kDark, FontWeight.bold), tex: text),
          ),

          more == null ?GestureDetector(
            onTap: onTap,
            child: Icon(
              AntDesign.appstore1,
            color: const Color.fromARGB(255, 14, 34, 65),
            size: 20.sp,
            ),
          ): const SizedBox.shrink()

        ],
      ),
    );
  }
}