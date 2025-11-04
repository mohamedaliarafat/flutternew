import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/complete_profile_controller.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/views/auth/login_redirect.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';


class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  Map<String, PlatformFile?> documents = {
    "licenseBusiness": null,
    "licenseEnergy": null,
    "commercialRecord": null,
    "taxNumber": null,
    "nationalAddress": null,
    "civilDefense": null,
  };

  late final CompleteProfileController _controller;
  late final AuthController _authController;
  String? _userId;
  String? _token;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController());
    _controller = Get.put(CompleteProfileController());

    final user = _authController.getUserInfo();
    if (user == null || user['id'] == null || user['id'].isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginRedirect()),
        );
      });
      return;
    }
    _userId = user['id'];
    final headers = _authController.getUserAuthHeaders();
    _token = headers?['Authorization'];
  }

  Future<void> _pickFile(String key) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        documents[key] = result.files.first;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_userId == null || _token == null) {
        Get.snackbar(
          "خطأ ❌",
          "لم يتم التعرف على المستخدم. يرجى تسجيل الدخول.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      bool allUploaded = documents.values.every((file) => file != null);
      if (!allUploaded) {
        Get.snackbar(
          "تنبيه ⚠️",
          "يرجى رفع جميع المستندات المطلوبة",
          colorText: Colors.white,
          backgroundColor: Colors.orange.shade700,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(10.w),
          borderRadius: 15.r,
        );
        return;
      }

      final Map<String, File> filesToUpload = {};
      documents.forEach((key, value) {
        if (value != null && value.path != null) {
          filesToUpload[key] = File(value.path!);
        }
      });

      bool success = await _controller.uploadDocuments(
        userId: _userId!,
        token: _token!,
        email: _emailController.text.trim(),
        documents: filesToUpload,
      );

      if (success) {
        _authController.setProfileCompleted(true);

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(
            () => MainScreen(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 900),
          );
        });
      }
    }
  }

  Widget _buildUploadField({
    required String label,
    required IconData icon,
  }) {
    final file = documents[label];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: GestureDetector(
        onTap: () => _pickFile(label),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: kLightWhite,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: kGray.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF1A759F), size: 22.w),
                  SizedBox(width: 10.w),
                  Text(
                    label,
                    style: TextStyle(
                      color: kDark,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                file != null ? Icons.check_circle : Icons.upload_file,
                color: file != null ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: kLightWhite,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: kGray.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: _emailController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: kDark, fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: "البريد الإلكتروني",
            labelStyle: TextStyle(color: kGray, fontSize: 14.sp),
            prefixIcon: Icon(MaterialCommunityIcons.email_outline,
                color: Color(0xFF1A759F), size: 20.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "يرجى إدخال البريد الإلكتروني";
            }
            if (!value.contains('@')) {
              return "يرجى إدخال بريد إلكتروني صالح";
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<Color> gradientColors = [
      Color(0xFF0F144D),
      Color(0xFF0F144D),
      Color(0xFF1A759F),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "إكمال ملف المنشأة",
            style: TextStyle(color: kLightWhite, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        "يرجى رفع جميع المستندات المطلوبة بصيغة PDF أو صورة",
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: kLightWhite.withOpacity(0.9)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25.h),
                      ...documents.keys.map((key) {
                        IconData icon;
                        switch (key) {
                          case "licenseBusiness":
                            icon = MaterialCommunityIcons.file_document_outline;
                            break;
                          case "licenseEnergy":
                            icon = MaterialCommunityIcons.lightning_bolt;
                            break;
                          case "commercialRecord":
                            icon = MaterialCommunityIcons.note_text_outline;
                            break;
                          case "taxNumber":
                            icon = MaterialCommunityIcons.cash_marker;
                            break;
                          case "nationalAddress":
                            icon = MaterialCommunityIcons.map_marker_radius_outline;
                            break;
                          case "civilDefense":
                            icon = MaterialCommunityIcons.fire_truck;
                            break;
                          default:
                            icon = Icons.upload_file;
                        }
                        return _buildUploadField(label: key, icon: icon);
                      }).toList(),
                      _buildEmailField(),
                      SizedBox(height: 35.h),
                      Container(
                        width: double.infinity,
                        height: 55.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Obx(() => ElevatedButton(
                              onPressed: _controller.isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBlueDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                elevation: 0,
                              ),
                              child: _controller.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "حفظ ومتابعة",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: kLightWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ))),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
