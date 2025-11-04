import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/controllers/user_location_controller.dart';
import 'package:foodly/views/auth/login_redirect.dart';
import 'package:foodly/views/profile/addresses_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAppbar extends StatefulHookWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    final userLocationController = Get.put(UserLocationController());

    // جلب بيانات المستخدم إذا كان مسجل
    final userInfo = authController.getUserInfo();
   final userImage = (userInfo != null && userInfo['profile'] != null && userInfo['profile']!.isNotEmpty)
    ? NetworkImage(userInfo['profile'])
    : const NetworkImage("https://b.top4top.io/p_35575874g1.png");

    return Container(
      width: double.infinity,
      height: 110.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: kBlueDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:  EdgeInsets.only(bottom: 10.h),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: userImage,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h, left: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (userInfo != null) {
                            Get.to(() => const AddressesPage());
                          } else {
                            Get.to(() => const LoginRedirect());
                          }
                        },
                        child: ReusableText(
                          text: "توصيل إلى",
                          style: appStyle(
                              15, kLightWhite,
                              FontWeight.bold),
                          tex: '',
                        ),
                      ),
                      Obx(
                        () => SizedBox(
                          width: Get.width * 0.65,
                          child: Text(
                            userLocationController.address == ""
                                ? "حائل, المنطقة الصناعية , المملكة العربية السعودية"
                                : userLocationController.address,
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(12, kGrayLight, FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                _getTimeOfDay(),
                style: const TextStyle(fontSize: 35, color: kDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final now = DateTime.now();
    final hour = now.hour;

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

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final controller = Get.put(UserLocationController());
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      controller.setPosition(currentLocation);
      controller.getUserAddress(currentLocation);
    } catch (e) {
      debugPrint("❌ Error getting location: $e");
    }
  }
}
