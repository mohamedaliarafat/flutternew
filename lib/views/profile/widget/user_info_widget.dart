import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/login_response.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

const Color kGradientStart = Color(0xFF1A237E);
const Color kGradientEnd = Color(0xFF42A5F5);
const Color kGlassColor = Colors.white24;
const Color kTileText = Colors.white;
const Color kIconColor = Colors.white70;
const Color kDarkBlueAccent = Color(0xFF1976D2);
const Color kLightWhite = Colors.white;

class UserInfoWidget extends StatefulWidget {
  final User user;

  const UserInfoWidget({super.key, required this.user});

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  void _showEditProfileDialog() {
    Get.dialog(
      _EditProfileDialog(
        user: widget.user,
        onUpdate: () {
          setState(() {});
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final defaultImage = "https://cdn-icons-png.flaticon.com/512/847/847969.png";
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 90.h,
            width: width,
            decoration: BoxDecoration(
              color: kGlassColor,
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.white10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: Colors.white30,
                      backgroundImage: NetworkImage(user.profile.isNotEmpty ? user.profile : defaultImage),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReusableText(
                          text: user.userType,
                          style: appStyle(16, kTileText, FontWeight.bold),
                          tex: "",
                        ),
                        SizedBox(height: 5.h),
                        ReusableText(
                          text: user.phone,
                          style: appStyle(12, kIconColor, FontWeight.normal),
                          tex: "",
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _showEditProfileDialog,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Icon(
                      Feather.edit,
                      size: 22.sp,
                      color: kTileText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// * نافذة تعديل الملف الشخصي *
// ----------------------------------------------------
class _EditProfileDialog extends StatefulWidget {
  final User user;
  final VoidCallback onUpdate;

  const _EditProfileDialog({required this.user, required this.onUpdate});

  @override
  __EditProfileDialogState createState() => __EditProfileDialogState();
}

class __EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _phoneController;
  late TextEditingController _userTypeController;

  void _changeProfilePicture() {
    Get.snackbar(
      "تغيير الصورة",
      "تم فتح منتقي الصور (وهمي).",
      snackPosition: SnackPosition.TOP,
      backgroundColor: kDarkBlueAccent,
      colorText: kLightWhite,
    );
  }

  void _saveChanges() {
    // هنا يمكنك إضافة عملية حفظ حقيقية إلى API إذا أردت
    Get.snackbar(
      "نجاح",
      "تم حفظ التغييرات بنجاح.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: kDarkBlueAccent,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      colorText: kLightWhite,
    );

    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    String currentPhone = widget.user.phone;
    if (currentPhone.startsWith("+966")) {
      currentPhone = currentPhone.substring(4);
    } else if (currentPhone.startsWith("966")) {
      currentPhone = currentPhone.substring(3);
    }

    _phoneController = TextEditingController(text: currentPhone);
    _userTypeController = TextEditingController(text: widget.user.userType);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _userTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: kDarkBlueAccent.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: Colors.white24, width: 1.5),
        ),
        title: Center(
          child: ReusableText(
            text: "تعديل الملف الشخصي",
            style: appStyle(19, kLightWhite, FontWeight.bold),
            tex: "",
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                onPressed: _changeProfilePicture,
                icon: const Icon(Ionicons.camera_outline, color: kLightWhite),
                label: Text("تغيير صورة البروفايل", style: TextStyle(color: kLightWhite)),
              ),
              SizedBox(height: 15.h),
              _buildPhoneField(controller: _phoneController),
              SizedBox(height: 10.h),
              _buildTextField(
                controller: _userTypeController,
                label: "نوع المستخدم",
                icon: Ionicons.person_outline,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ReusableText(
              text: "إلغاء",
              style: appStyle(15, Colors.white70, FontWeight.normal),
              tex: "",
            ),
          ),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              elevation: 5,
            ),
            child: ReusableText(
              text: "حفظ التغييرات",
              style: appStyle(15, kDarkBlueAccent, FontWeight.bold),
              tex: "",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: kLightWhite),
      decoration: InputDecoration(
        labelText: "رقم الجوال",
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10.w),
            Image.asset(
              'assets/images/saudi_flag.png',
              width: 25.w,
              height: 25.h,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Ionicons.call_outline, color: kLightWhite),
            ),
            SizedBox(width: 5.w),
            ReusableText(
              text: "+966",
              style: appStyle(15, kLightWhite, FontWeight.bold),
              tex: "",
            ),
            SizedBox(width: 8.w),
            Container(width: 1.w, height: 30.h, color: Colors.white30),
            SizedBox(width: 8.w),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: kLightWhite),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: kLightWhite),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
        ),
      ),
    );
  }
}
