// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/constants/constants.dart';

class CustomContainer extends StatelessWidget {
  final Widget containerContent;
  final Color color; // خليها نهائية (final)

  const CustomContainer({
    super.key,
    this.color = kOffWhite, // اجعل لها قيمة افتراضية
    required this.containerContent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.77,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        child: Container(
          width: width,
          color: color,
          child: SingleChildScrollView(
            child: containerContent,
          ),
        ),
      ),
    );
  }
}
