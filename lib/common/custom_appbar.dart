// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/user_location_controller.dart';
import 'package:foodly/hooks/fetch_default.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAppbar extends StatefulHookWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {

  @override
  void initState() {
     super.initState();
     _determinePosition();
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserLocationController());
    final hookResults = useFetchDefault();
    final address = hookResults.data;

    print(address);
    return Container(
      
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      width: width,
      height: 110.h,
      color: kOffWhite,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
          
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: kOffWhite,
            backgroundImage: NetworkImage("https://b.top4top.io/p_35575874g1.png"),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 6.h, left: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(text: "توصيل إلى", style: appStyle(15, const Color.fromARGB(255, 14, 34, 65), FontWeight.bold), tex: '',),
               Obx(() =>
                SizedBox(
                  width: width * 0.65,
                  child: Text(
                    controller.address == ""
                     ?"حائل, المنطقة الصناعية , المملكة العربية السعودية" 
                     : controller.address,
                    overflow: TextOverflow.ellipsis,
                    style: appStyle(12, kGray, FontWeight.normal),
                  ),
                ),
               )
              ],
            ),
          ),
        ],
      ),
      Text(
        getTimeOfDay(),
        style: 
           const TextStyle(fontSize: 30, color: kDark),
      ),
    ]
  ),
  )
);
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return '⛅';
    } else if (hour >= 18) {
      return '🌙';
    } else {
      return '🌞';
    }
  }

 Future<void> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // التحقق من تشغيل خدمة الموقع
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services are disabled.");
  }

  // التحقق من الأذونات
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied.");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error("Location permissions are permanently denied.");
  }
  _getCurentLocation();

}

 Future<void> _getCurentLocation() async {
  final controller = Get.put(UserLocationController());
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best);
  LatLng curentLocation = LatLng(position.latitude, position.latitude);
  controller.setPosition(curentLocation);
  controller.getUserAddress(curentLocation);

 }
}

