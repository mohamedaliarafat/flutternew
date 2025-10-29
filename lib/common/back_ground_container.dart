import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/constants/constants.dart';

class BackGroundContainer extends StatelessWidget {
  const BackGroundContainer({super.key, required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: hieght,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.r),
          bottomRight: Radius.circular(5.r),
        ),
        image: DecorationImage(image: AssetImage('assets/images/restaurant_bk.png'), 
        
        fit: BoxFit.cover,
        opacity: .7,
        ),
      ),
      child: child,
    );
  }
}