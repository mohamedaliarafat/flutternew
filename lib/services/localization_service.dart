// في ملف services/localization_service.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // اللغة الافتراضية
  static final locale = const Locale('ar', 'SA'); 
  static final fallbackLocale = const Locale('en', 'US');

  // اللغات المدعومة
  static final langs = [
    'العربية',
    'English',
  ];
  static final locales = [
    const Locale('ar', 'SA'),
    const Locale('en', 'US'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'choose_language': 'Choose Language',
          'cancel': 'Cancel',
          'dark_mode': 'Dark Mode',
          'light_mode': 'Light Mode',
          // ... يمكنك إضافة المزيد من الكلمات هنا
        },
        'ar_SA': {
          'choose_language': 'اختيار اللغة',
          'cancel': 'إلغاء',
          'dark_mode': 'الوضع الداكن',
          'light_mode': 'الوضع الفاتح',
          // ... يمكنك إضافة المزيد من الكلمات هنا
        }
      };
}