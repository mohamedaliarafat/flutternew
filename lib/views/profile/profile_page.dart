import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/logo_transition.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/constants/uidata.dart';
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final box = GetStorage();

    // التحقق من وجود التوكن
    final token = box.read('token');
    if (token == null) return const LoginRedirect();

    // جلب بيانات المستخدم
    final userMap = authController.getUserInfo();
    if (userMap == null) return const LoginRedirect();

    final userData = User(
      id: userMap['id'] ?? '',
      phone: userMap['phone'] ?? '',
      phoneVerification: userMap['verification'] ?? false,
      userType: userMap['userType'] ?? 'Client',
      profile: userMap['profile'] ?? '',
      addresses: [],
      defaultAddress: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),  
      profileCompleted: userMap['profileCompleted'] ?? false, notifications: [],
    );

    // إذا رقم الهاتف غير موثق
    if (!userData.phoneVerification) {
      return OtpVerificationScreen(phoneNumber: userData.phone);
    }

    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
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
                    Align(
                      alignment: Alignment.center,
                      child: UserInfoWidget(user: userData),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.h),
                _buildSectionTitle("إجراءات الحساب الرئيسية", Icons.dashboard),
                _buildGlassmorphicList(context, tiles: [
                  _GlassProfileTile(
                    onTap: () => Get.to(() => const OrdersList()),
                    title: "طلباتي",
                    icon: Icons.shopping_bag,
                  ),
                  _GlassProfileTile(
                    onTap: () {},
                    title: "المطاعم المفضلة",
                    icon: Icons.favorite,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(() => const ReviewPage()),
                    title: "مراجعاتي",
                    icon: Icons.star,
                  ),
                  _GlassProfileTile(
                    onTap: () {},
                    title: "كوبوناتي",
                    icon: Icons.confirmation_num,
                  ),
                ]),
                SizedBox(height: 10.h),
                _buildSectionTitle("المساعدة والإعدادات", Icons.settings),
                _buildGlassmorphicList(context, tiles: [
                  _GlassProfileTile(
                    onTap: () => Get.to(() => const AddressesPage()),
                    title: "عناوين الشحن",
                    icon: Icons.location_pin,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(() => const ServiceCenter()),
                    title: "مركز الخدمة والدعم",
                    icon: Icons.support_agent,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(() => const AppFeedback()),
                    title: "ملاحظات وتغذية راجعة",
                    icon: Icons.feedback,
                  ),
                  _GlassProfileTile(
                    onTap: () => Get.to(() => const SettingsPage()),
                    title: "الإعدادات",
                    icon: Icons.settings_applications,
                  ),
                ]),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomButton(
                    onTap: () {
                      authController.logout();
                      Get.offAll(() => const LoginRedirect());
                    },
                    btnColor: Colors.red,
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicList(BuildContext context, {required List<Widget> tiles}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
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
              Icon(icon, color: Colors.white70, size: 22.sp),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white70, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}
