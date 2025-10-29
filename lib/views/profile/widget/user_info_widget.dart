import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart'; // افترضنا أن appStyle يدعم الألوان الشفافة
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/login_response.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'dart:ui'; // لاستخدام ImageFilter (Glassmorphism)
// يجب عليك إضافة هذه الاستيرادات للتعامل مع تحديث البيانات والصورة في بيئة حقيقية:
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:foodly/controllers/login_controller.dart';

// تعريف ثوابت الألوان من ملف ProfilePage لتناسب التصميم
const Color kGradientStart = Color(0xFF1A237E);
const Color kGradientEnd = Color(0xFF42A5F5);
const Color kGlassColor = Colors.white24;
const Color kTileText = Colors.white;
const Color kIconColor = Colors.white70;
const Color kDarkBlueAccent = Color(0xFF1976D2); // لون أزرق داكن مميز للأزرار والخلفيات

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({
    super.key,
    this.user,
  });

  final LoginResponse? user;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  void _showEditProfileDialog() {
    Get.dialog(
      _EditProfileDialog(
        user: widget.user,
        onUpdate: () {
          setState(() {}); // لتحديث معلومات المستخدم بعد التعديل
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final defaultImage = "https://cdn-icons-png.flaticon.com/512/847/847969.png";
    final double width = MediaQuery.of(context).size.width; // إضافة تعريف width

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w), // تباعد أفقي
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r), // زوايا مستديرة لمظهر زجاجي
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), // تأثير ضبابية أقوى
          child: Container(
            height: 90.h, // ارتفاع أكبر لاستيعاب المحتوى بتنسيق أفضل
            width: width,
            decoration: BoxDecoration(
              color: kGlassColor, // لون زجاجي شفاف
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.white10), // حدود خفيفة
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h), // تباعد داخلي
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35.r, // حجم أكبر للصورة
                      backgroundColor: Colors.white30, // خلفية شفافة للصورة
                      backgroundImage: NetworkImage(
                        user?.profile ?? defaultImage,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReusableText(
                          text: user?.username ?? "اسم المستخدم",
                          style: appStyle(16, kTileText, FontWeight.bold), // نص أبيض
                          tex: "",
                        ),
                        SizedBox(height: 5.h), // تباعد أكبر
                        ReusableText(
                          text: user?.email ?? "البريد الإلكتروني",
                          style: appStyle(12, kIconColor, FontWeight.normal), // نص أبيض شفاف
                          tex: "",
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _showEditProfileDialog,
                  child: Container(
                    padding: EdgeInsets.all(10.w), // حجم أكبر للزر
                    decoration: BoxDecoration(
                      color: Colors.white12, // خلفية شفافة للزر
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Icon(
                      Feather.edit,
                      size: 22.sp, // حجم أكبر للأيقونة
                      color: kTileText, // أيقونة بيضاء
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

// ---------------------------------------------
// 2. الودجت المنبثق لتعديل البيانات (_EditProfileDialog)
// ---------------------------------------------
class _EditProfileDialog extends StatefulWidget {
  final LoginResponse? user;
  final VoidCallback onUpdate;

  const _EditProfileDialog({required this.user, required this.onUpdate});

  @override
  __EditProfileDialogState createState() => __EditProfileDialogState();
}

class __EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  // File? _newProfileImage; // يتم استخدامه لتخزين الصورة الجديدة في التطبيق الحقيقي

  void _changeProfilePicture() async {
    // **ملاحظة:** التنفيذ الحقيقي يتطلب إضافة مكتبة image_picker
    // ويمكنك هنا فتح منتقي الصور
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() { _newProfileImage = File(pickedFile.path); });
    //   Get.snackbar("تغيير الصورة", "تم اختيار صورة جديدة بنجاح (معاينة غير متوفرة هنا).", snackPosition: SnackPosition.TOP);
    // } else {
    //   Get.snackbar("تنبيه", "لم يتم اختيار صورة.", snackPosition: SnackPosition.BOTTOM);
    // }

    Get.snackbar(
      "تغيير الصورة",
      "تم فتح منتقي الصور بنجاح (وهمي).",
      snackPosition: SnackPosition.TOP,
      backgroundColor: kDarkBlueAccent, // لون متناسق
      colorText: kLightWhite,
    );
  }

  void _saveChanges() async {
    String newName = _nameController.text;
    String newPhone = "966" + _phoneController.text;
    String newAddress = _addressController.text;

    // **التطبيق الحقيقي:**
    // final loginController = Get.find<LoginController>();
    // bool success = await loginController.updateUserProfile(name: newName, phone: newPhone, address: newAddress, image: _newProfileImage);
    // if (success) {
    //   Get.snackbar("نجاح", "تم تحديث معلوماتك بنجاح.", snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: kLightWhite);
    //   widget.onUpdate();
    //   Navigator.pop(context);
    // } else {
    //   Get.snackbar("خطأ", "فشل تحديث المعلومات. حاول مرة أخرى.", snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: kLightWhite);
    // }

    // محاكاة النجاح والتحديث المحلي
    Get.snackbar(
      "نجاح",
      "تم تحديث معلوماتك بنجاح.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: kDarkBlueAccent, // لون متناسق
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      colorText: kLightWhite,
    );

    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    String currentPhone = widget.user?.phone ?? "";
    if (currentPhone.startsWith("+966")) {
      currentPhone = currentPhone.substring(4);
    } else if (currentPhone.startsWith("966")) {
      currentPhone = currentPhone.substring(3);
    }

    _nameController = TextEditingController(text: widget.user?.username ?? "");
    _phoneController = TextEditingController(text: currentPhone);
    _addressController = TextEditingController(text: widget.user?.address ?? "N/A");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter( // تطبيق تأثير الضبابية على الخلفية عند ظهور الحوار
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: kDarkBlueAccent.withOpacity(0.8), // لون خلفية شبه شفاف
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: const BorderSide(color: Colors.white24, width: 1.5), // حدود زجاجية
        ),
        title: Center(
          child: ReusableText(
            text: "تعديل الملف الشخصي",
            style: appStyle(19, kLightWhite, FontWeight.bold), // نص أبيض
            tex: "",
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // زر تعديل الصورة
              TextButton.icon(
                onPressed: _changeProfilePicture,
                icon: const Icon(Ionicons.camera_outline, color: kLightWhite), // أيقونة بيضاء
                label: Text("تعديل صورة البروفايل", style: TextStyle(color: kLightWhite)),
              ),
              SizedBox(height: 15.h),

              // حقل الاسم
              _buildTextField(
                controller: _nameController,
                label: "الاسم الكامل",
                icon: Ionicons.person_outline,
              ),
              SizedBox(height: 10.h),

              // حقل رقم الجوال
              _buildPhoneField(
                controller: _phoneController,
              ),
              SizedBox(height: 10.h),

              // حقل العنوان الشخصي
              _buildTextField(
                controller: _addressController,
                label: "العنوان الشخصي",
                icon: Ionicons.location_outline,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ReusableText(
              text: "إلغاء",
              style: appStyle(15, Colors.white70, FontWeight.normal), // نص أبيض خافت
              tex: "",
            ),
          ),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent, // لون زر مميز
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              elevation: 5, // ظل للزر
            ),
            child: ReusableText(
              text: "حفظ التغييرات",
              style: appStyle(15, kDarkBlueAccent, FontWeight.bold), // نص داكن على زر فاتح
              tex: "",
            ),
          ),
        ],
      ),
    );
  }

  // ودجت مساعد لحقل الهاتف الثابت
  Widget _buildPhoneField({
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: kLightWhite), // نص الحقل أبيض
      decoration: InputDecoration(
        labelText: "رقم الجوال",
        labelStyle: TextStyle(color: Colors.white70), // نص التسمية أبيض خافت
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10.w),
            Image.asset(
              'assets/images/saudi_flag.png', // **استبدل هذا بالمسار الصحيح لعلم السعودية في مشروعك**
              width: 25.w,
              height: 25.h,
              errorBuilder: (context, error, stackTrace) => const Icon(Ionicons.call_outline, color: kLightWhite),
            ),
            SizedBox(width: 5.w),
            ReusableText(
              text: "+966",
              style: appStyle(15, kLightWhite, FontWeight.bold),
              tex: "",
            ),
            SizedBox(width: 8.w),
            Container(width: 1.w, height: 30.h, color: Colors.white30), // فاصل شفاف
            SizedBox(width: 8.w),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.white30), // حدود شفافة
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2), // حدود مركزة مميزة
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      ),
    );
  }

  // ودجت مساعد لبناء حقول الإدخال العادية
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: kLightWhite), // نص الحقل أبيض
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70), // نص التسمية أبيض خافت
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: kLightWhite), // أيقونة بيضاء
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.white30), // حدود شفافة
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2), // حدود مركزة مميزة
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      ),
    );
  }
}