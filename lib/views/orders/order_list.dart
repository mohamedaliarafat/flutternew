import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/hooks/fetch_order.dart';
import 'package:foodly/models/order_model.dart';
import 'package:foodly/models/hook_models/hook_result.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/views/orders/order_detilse.dart' hide OrderItem;
import 'package:intl/intl.dart';

// **ثوابت ألوان وتصميم جديدة للصفحة**
const Color kPrimaryColor = Color(0xFF6200EE);
const Color kAccentColor = Color(0xFF03DAC6);
const Color kBackgroundColor = Color(0xFFF0F2F5);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF333333);
const Color kLightTextColor = Color(0xFF666666);
const Color kDividerColor = Color(0xFFE0E0E0);

class OrdersList extends HookWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    // دالة لحساب السعر الإجمالي لكل عنصر مع الإضافات
    double totalItemPrice(OrderItem item) {
      double additivesCost = item.additives.length * 5.0; // كل إضافة 5 ر.س
      return (item.price + additivesCost) * item.quantity;
    }

    final tabController = useTabController(initialLength: 2);
    final currentOrdersHook = useFetchOrders(currentOrders: true);
    final pastOrdersHook = useFetchOrders(currentOrders: false);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          'سجل الطلبات',
          style: TextStyle(
              color: kCardColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kBlueDark,
        elevation: 4,
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          labelColor: kCardColor,
          unselectedLabelColor: kCardColor.withOpacity(0.7),
          indicatorColor: kAccentColor,
          indicatorWeight: 4,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 14.sp),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          tabs: const [
            Tab(text: 'الطلبات الحالية'),
            Tab(text: 'الطلبات السابقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildOrderTab(currentOrdersHook),
          _buildOrderTab(pastOrdersHook),
        ],
      ),
    );
  }

  Widget _buildOrderTab(FetchHook hook) {
    if (hook.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
      );
    }

    if (hook.error != null) {
      return Center(
        child: Text(
          'خطأ في تحميل الطلبات: ${hook.error.toString()}',
          style: TextStyle(color: Colors.red.shade700, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      );
    }

    final orders = hook.data ?? [];

    if (orders.isEmpty) {
      return Center(
        child: Text(
          'لا توجد طلبات لعرضها في هذا التبويب.',
          style: TextStyle(color: kLightTextColor, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
      );
    }

    // إجمالي الطلبات وعددها
    final totalOrders = orders.length;

    // حساب السعر الإجمالي لكل الطلبات مع الإضافات
    final totalPrice = orders.fold<double>(
      0.0,
      (double sum, OrdersModel order) {
        double orderTotal = order.orderItems.fold<double>(
          0.0,
          (double itemSum, OrderItem item) {
            double additivesCost = item.additives.length * 5.0;
            return itemSum + (item.price + additivesCost) * item.quantity;
          },
        );
        return sum + orderTotal;
      },
    );

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildStatsCard('مجموع الطلبات', totalOrders.toString())),
           ],
        ),
        SizedBox(height: 20.h),
        ...orders.map((order) => OrderListItem(order: order)).toList(),
      ],
    );
  }

  // بطاقة إحصائيات
  Widget _buildStatsCard(String title, String value) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      color: kCardColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: kLightTextColor,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                  fontSize: 22.sp, fontWeight: FontWeight.bold, color: kBlueDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final OrdersModel order;
  const OrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
      color: kBlueDark,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderTrackingPage(
                orderNumber: order.id,
                date: order.orderDate != null
                    ? DateFormat('yyyy-MM-dd – HH:mm').format(order.orderDate)
                    : '',
                total: order.grandTotal.toDouble(),
                paymentMethod: 'بطاقة مدى',
                shippingAddress: 'عنوان العميل',
                orderStatus: order.orderStatus,
                items: [], // يمكن تعديل لإرسال المنتجات الفعلية
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.orderStatus).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(order.orderStatus),
                  color: kLightWhite,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب رقم: #${order.id}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                          color: kLightWhite),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'الحالة: ${_getArabicStatus(order.orderStatus)}',
                      style: TextStyle(fontSize: 15.sp, color: kWhite),
                    ),
                  ],
                ),
              ),
              Icon(Ionicons.chevron_forward,
                  size: 22.sp, color: kLightWhite.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }

  String _getArabicStatus(String status) {
    switch (status) {
      case 'Delivered':
        return 'مكتملة';
      case 'In-Review':
        return 'قيد المراجعة';
      case 'Placed':
        return 'تم الطلب';
      case 'Accepted':
        return 'مقبولة';
      case 'Preparing':
        return 'قيد التحضير';
      case 'Out_for_Delivery':
        return 'قيد التوصيل';
      case 'Cancelled':
        return 'ملغاة';
      default:
        return 'غير معروف';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Delivered':
        return Ionicons.checkmark_circle_sharp;
      case 'In-Review':
        return Ionicons.time_outline;
      case 'Placed':
        return Ionicons.clipboard_outline;
      case 'Accepted':
        return Ionicons.restaurant_outline;
      case 'Preparing':
        return Ionicons.pizza_outline;
      case 'Out_for_Delivery':
        return Ionicons.bicycle_outline;
      case 'Cancelled':
        return Ionicons.close_circle_sharp;
      default:
        return Ionicons.information_circle_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green.shade600;
      case 'In-Review':
        return Colors.blue.shade600;
      case 'Placed':
      case 'Accepted':
      case 'Preparing':
        return Colors.orange.shade600;
      case 'Out_for_Delivery':
        return Colors.teal.shade600;
      case 'Cancelled':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
