import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly/models/notification_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

const String appBaseUrl = "http://192.168.8.11:6013";

class NotificationController extends GetxController {
  List<NotificationModel> notifications = [];
  bool isLoading = false;

  /// 🔹 جلب الإشعارات من السيرفر (MongoDB)
  Future<void> fetchNotifications(String userId, String token ) async {
    isLoading = true;
    update();

    try {
      final response = await http.get(
        Uri.parse('$appBaseUrl/api/notifications/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        notifications = (body['notifications'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        debugPrint("✅ Notifications fetched: ${notifications.length}");
      } else {
        debugPrint("❌ Failed to fetch notifications: ${response.body}");
      }
    } catch (e) {
      debugPrint('❌ fetchNotifications Exception: $e');
    }

    isLoading = false;
    update();
  }

  /// 🔹 تعليم جميع الإشعارات كمقروءة في MongoDB
  Future<void> markAllAsRead(String userId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$appBaseUrl/api/notifications/mark-as-read'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        // تحديث الحالة محلياً بعد MongoDB
        for (var n in notifications) n.isRead = true;
        update();
        debugPrint("✅ All notifications marked as read in MongoDB");
      } else {
        debugPrint('❌ markAllAsRead failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ markAllAsRead Exception: $e');
    }
  }

  /// 🔹 تعليم إشعار واحد كمقروء في MongoDB
  Future<void> markSingleAsRead(int index, String token) async {
    if (index < 0 || index >= notifications.length) return;
    final n = notifications[index];

    if (n.isRead) return;

    try {
      final response = await http.post(
        Uri.parse('$appBaseUrl/api/notifications/mark-single-as-read'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"notificationId": n.id}),
      );

      if (response.statusCode == 200) {
        n.isRead = true;
        update();
        debugPrint("✅ Notification ${n.id} marked as read in MongoDB");
      } else {
        debugPrint('❌ markSingleAsRead failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ markSingleAsRead Exception: $e');
    }
  }
}
