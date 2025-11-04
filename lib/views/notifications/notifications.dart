import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/controllers/notificationsController.dart';
import 'package:foodly/models/notification_model.dart';
import 'package:foodly/views/auth/login_redirect.dart';


const Color _navyStart = Color(0xFF070B35);
const Color _navyEnd = Color(0xFF191382);
const Color kLightBlue = Color(0xFF42A5F5);
const Color kRed = Color(0xFFEF5350);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _controller = NotificationController();
  final AuthController _authController = AuthController();
  late Future<void> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _checkUserAndLoad();
  }

  void _checkUserAndLoad() {
    final user = _authController.getUserInfo();

    if (user == null || user['id'] == null || user['id'].isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginRedirect()),
        );
      });
      _futureNotifications = Future.value();
      return;
    }

    final headers = _authController.getUserAuthHeaders();
    if (headers == null) {
      debugPrint("❌ Token not found or invalid!");
      _futureNotifications = Future.value();
      return;
    }

    _futureNotifications =
        _controller.fetchNotifications(user['id'], headers['Authorization']!);
  }

  Future<void> _refreshNotifications() async {
    final user = _authController.getUserInfo();
    final headers = _authController.getUserAuthHeaders();
    if (user == null || headers == null) return;

    await _controller.fetchNotifications(user['id'], headers['Authorization']!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: _navyStart,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
          ),
          title: Text(
            "الإشعارات",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _refreshNotifications,
              child: Text(
                "قراءة الكل",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _futureNotifications,
          builder: (context, snapshot) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (_controller.notifications.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد إشعارات حالياً.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                ),
              );
            }

            final notifications = _controller.notifications;
            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return _buildNotificationItem(n);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel n) {
    final headers = _authController.getUserAuthHeaders();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: n.isRead ? Colors.white : _navyEnd.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: n.isRead ? Colors.grey.shade200 : _navyEnd.withOpacity(0.3),
          width: 0.6,
        ),
        boxShadow: n.isRead
            ? []
            : [
                BoxShadow(
                  color: _navyEnd.withOpacity(0.08),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: ListTile(
        onTap: () async {
          if (!n.isRead && headers != null) {
            await _controller.markSingleAsRead(
                _controller.notifications.indexOf(n), headers['Authorization']!);
            await _refreshNotifications();
          }
        },
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: kLightBlue.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_active,
            color: kLightBlue,
            size: 22.w,
          ),
        ),
        title: Text(
          n.title,
          style: TextStyle(
            color: _navyStart,
            fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 16.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              n.body,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              n.createdAt,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        trailing: n.isRead
            ? Icon(Icons.done_all, color: Colors.grey[400], size: 18.w)
            : Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  color: kRed,
                  shape: BoxShape.circle,
                ),
              ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      ),
    );
  }
}
