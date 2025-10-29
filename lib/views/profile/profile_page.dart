import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/custom_button.dart';
// import 'package:foodly/common/custom_container.dart'; // لم نعد نستخدمها مباشرة بهذا الشكل
import 'package:foodly/common/logo_transition.dart';
import 'package:foodly/controllers/login_controller.dart';
import 'package:foodly/models/login_response.dart';
import 'package:foodly/views/auth/login_redirect.dart';
import 'package:foodly/views/auth/verification_page.dart';
import 'package:foodly/views/orders/order_list.dart';
import 'package:foodly/views/profile/addresses_page.dart';
import 'package:foodly/views/profile/app_feedback.dart';
import 'package:foodly/views/profile/reviw.dart';
import 'package:foodly/views/profile/servec_center.dart';
import 'package:foodly/views/profile/settings_page.dart';
// import 'package:foodly/views/profile/widget/profile_app_bar.dart'; // لم نعد نستخدمه
import 'package:foodly/constants/constants.dart';
// import 'package:foodly/views/profile/widget/profile_tile.dart'; // سيتم إعادة تعريفه هنا
import 'package:foodly/views/profile/widget/user_info_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:ui'; // لاستخدام ImageFilter (Glassmorphism)

// تعريف ثوابت الألوان الجديدة
const Color kGradientStart = Color(0xFF1A237E); // أزرق داكن عميق
const Color kGradientEnd = Color(0xFF42A5F5);   // أزرق فاتح جذاب
const Color kGlassColor = Colors.white24;      // لون زجاجي شفاف
const Color kTileText = Colors.white;          // لون النص في التايل
const Color kIconColor = Colors.white70;       // لون الأيقونات

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginResponse? user;
    final controller = Get.put(LoginController());
    final box = GetStorage();
    String? token = box.read('token');

    if (token != null) {
      user = controller.getUserInfo();
    }

    if (token == null) {
      return const LoginRedirect();
    }

    if (user != null && user.verification == false) {
      return const VerificationPage();
    }

    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent, // لجعل الخلفية المتدرجة مرئية
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kGradientStart, kGradientEnd],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.h, // ارتفاع أكبر لعرض معلومات المستخدم
              pinned: true,
              backgroundColor: Colors.transparent, // لجعل الخلفية المتدرجة تظهر
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                
                background: Stack(
                  children: [
                    // تأثير الزجاج في الخلفية العلوية
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.black26), // طبقة شبه شفافة
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.h), // مسافة من الـ app bar
                          UserInfoWidget(user: user),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10.h),

                  // 1. قسم الإجراءات الرئيسية
                  _buildSectionTitle("إجراءات الحساب الرئيسية", AntDesign.dashboard),
                  _buildGlassmorphicList(context, tiles: [
                    _GlassProfileTile(
                      onTap: () {
                        Get.to(() => const OrdersList(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 400));
                      },
                      title: "طلباتي",
                      icon: FontAwesome.shopping_bag,
                    ),
                    _GlassProfileTile(
                      onTap: () {},
                      title: "المطاعم المفضلة",
                      icon: Ionicons.heart_sharp,
                    ),
                    _GlassProfileTile(
                      onTap: () {
                        Get.to(() => ReviewPage(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 400));
                      },
                      title: "مراجعاتي",
                      icon: Ionicons.star_half_sharp,
                    ),
                    _GlassProfileTile(
                      onTap: () {},
                      title: "كوبوناتي",
                      icon: MaterialCommunityIcons.ticket_percent_outline,
                    ),
                  ]),

                  SizedBox(height: 10.h),

                  // 2. قسم الإعدادات والمساعدة
                  _buildSectionTitle("المساعدة والإعدادات", Icons.settings_applications),
                  _buildGlassmorphicList(context, tiles: [
                    _GlassProfileTile(
                      onTap: () {
                        Get.to(() => LogoTransition(nextPage: const AddressesPage()), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 400));
                      },
                      title: "عناوين الشحن",
                      icon: SimpleLineIcons.location_pin,
                    ),
                    _GlassProfileTile(
                      onTap: () {
                        Get.to(() => LogoTransition(nextPage: const ServiceCenter()), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 400));
                      },
                      title: "مركز الخدمة والدعم",
                      icon: AntDesign.customerservice,
                    ),
                    _GlassProfileTile(
                      onTap: () {
                        Get.to(() => LogoTransition(nextPage: const AppFeedback()), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 400));
                      },
                      title: "ملاحظات وتغذية راجعة",
                      icon: MaterialIcons.feedback,
                    ),
                    _GlassProfileTile(
                      onTap: () {
                        Get.to(() => LogoTransition(nextPage: const SettingsPage()), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 400));
                      },
                      title: "الإعدادات",
                      icon: AntDesign.setting,
                    ),
                  ]),

                  SizedBox(height: 10.h),

                  // زر تسجيل الخروج
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      onTap: () {
                        controller.logout();
                        Get.offAll(() => const LoginRedirect());
                      },
                      btnColor: kRed, // اللون الأحمر يظل جيدًا لزر الخروج
                      text: "تسجيل الخروج",
                      radius: 12,
                      btnHeight: 45.h,
                      btnWidth: width,
                      // إضافة ظل للزر
                     
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(),
                    child: SizedBox(height: 50.h),
                  ), // مسافة في الأسفل
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء عنوان القسم
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 15.h, top: 10.h),
      child: Row(
        children: [
          Icon(icon, color: kIconColor, size: 24.sp),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: kTileText,
              shadows: const [
                Shadow(offset: Offset(0.5, 0.5), blurRadius: 1.0, color: Colors.black26),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء قائمة Tiles بتأثير الزجاج
  Widget _buildGlassmorphicList(BuildContext context, {required List<Widget> tiles}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: kGlassColor, // لون الزجاج الشفاف
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white10), // حدود خفيفة
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: Colors.white12, // فاصل بلون شفاف
                indent: 20.w,
                endIndent: 20.w,
              ),
              itemBuilder: (context, index) {
                return tiles[index];
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// *Glassmorphic Profile Tile* (يجب تعريفها في ملف منفصل أو هنا)
// ----------------------------------------------------
class _GlassProfileTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;

  const _GlassProfileTile({
    required this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // لجعل تأثير الزجاج يظهر
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white30, // تأثير لمس فاتح
        highlightColor: Colors.white10, // تأثير ضغط فاتح
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: kIconColor,
                size: 24.sp,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: kTileText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Ionicons.chevron_forward,
                size: 18.sp,
                color: kIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}