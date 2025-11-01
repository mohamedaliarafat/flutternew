import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/logo_transition.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/models/login_response.dart';
import 'package:foodly/views/auth/OtpVerificationScreen.dart';
import 'package:foodly/views/auth/login_redirect.dart';
import 'package:foodly/views/orders/order_list.dart';
import 'package:foodly/views/profile/addresses_page.dart';
import 'package:foodly/views/profile/app_feedback.dart';
import 'package:foodly/views/profile/reviw.dart';
import 'package:foodly/views/profile/servec_center.dart';
import 'package:foodly/views/profile/settings_page.dart';
import 'package:foodly/views/profile/widget/user_info_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// 🎨 ثيم متدرج بتأثير زجاجي
const Color kGradientStart = Color(0xFF1A237E);
const Color kGradientEnd = Color(0xFF42A5F5);
const Color kGlassColor = Colors.white24;
const Color kTileText = Colors.white;
const Color kIconColor = Colors.white70;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final box = GetStorage();

    // ✅ تحقق من وجود التوكن
    String? token = box.read('token');
    if (token == null) {
      return const LoginRedirect();
    }

    // ✅ جلب بيانات المستخدم من AuthController
    User? userData = authController.getUserInfo() as User?;

    // ✅ لو المستخدم لم يتحقق رقم جواله نرسله لصفحة التحقق
    if (userData != null && userData.phoneVerification == false) {
      return OtpVerificationScreen(phoneNumber: userData.phone);
    }

    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kGradientStart, kGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // 🔹 رأس الصفحة مع صورة المستخدم
            SliverAppBar(
              expandedHeight: 220.h,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(color: Colors.black26),
                      ),
                    ),
                    if (userData != null)
                      Align(
                        alignment: Alignment.center,
                        child: UserInfoWidget(user: userData),
                      ),
                  ],
                ),
              ),
            ),

            // 🔹 محتوى الصفحة
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.h),

                // 🧭 القسم الرئيسي
                _buildSectionTitle("إجراءات الحساب الرئيسية", AntDesign.dashboard),
                _buildGlassmorphicList(context, tiles: [
                  _GlassProfileTile(
                    onTap: () => Get.to(
                      () => const OrdersList(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    ),
                    title: "طلباتي",
                    icon: FontAwesome.shopping_bag,
                  ),
                  _GlassProfileTile(
                    onTap: () {},
                    title: "المطاعم المفضلة",
                    icon: Ionicons.heart_sharp,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(
                      () => ReviewPage(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    ),
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

                // ⚙️ المساعدة والإعدادات
                _buildSectionTitle("المساعدة والإعدادات", Icons.settings_applications),
                _buildGlassmorphicList(context, tiles: [
                  _GlassProfileTile(
                    onTap: () => Get.to(
                      () => LogoTransition(nextPage: const AddressesPage()),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    ),
                    title: "عناوين الشحن",
                    icon: SimpleLineIcons.location_pin,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(
                      () => LogoTransition(nextPage: const ServiceCenter()),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    ),
                    title: "مركز الخدمة والدعم",
                    icon: AntDesign.customerservice,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(
                      () => LogoTransition(nextPage: const AppFeedback()),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    ),
                    title: "ملاحظات وتغذية راجعة",
                    icon: MaterialIcons.feedback,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(
                      () => LogoTransition(nextPage: const SettingsPage()),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 400),
                    ),
                    title: "الإعدادات",
                    icon: AntDesign.setting,
                  ),
                ]),

                SizedBox(height: 20.h),

                // 🚪 زر تسجيل الخروج
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomButton(
                    onTap: () {
                      authController.logout();
                      Get.offAll(() => const LoginRedirect());
                    },
                    btnColor: kRed,
                    text: "تسجيل الخروج",
                    radius: 12,
                    btnHeight: 45.h,
                    btnWidth: width,
                  ),
                ),
                SizedBox(height: 60.h),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧩 بناء عنوان القسم
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: kIconColor, size: 22.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: kTileText,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              shadows: const [
                Shadow(offset: Offset(0.5, 0.5), blurRadius: 1.0, color: Colors.black26),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🧊 قائمة زجاجية أنيقة
  Widget _buildGlassmorphicList(BuildContext context, {required List<Widget> tiles}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: kGlassColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white10),
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => tiles[index],
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: Colors.white12,
                indent: 20.w,
                endIndent: 20.w,
              ),
              itemCount: tiles.length,
            ),
          ),
        ),
      ),
    );
  }
  
}

// ----------------------------------------------------
// * عنصر زجاجي لكل اختيار في الصفحة *
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(icon, color: kIconColor, size: 22.sp),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: kTileText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Ionicons.chevron_forward, color: kIconColor, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}
