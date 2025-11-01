import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/custom_container.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/cart_controller.dart';
import 'package:foodly/controllers/login_phone_controller.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:foodly/models/login_response.dart';
import 'package:foodly/views/auth/login_redirect.dart';
import 'package:foodly/views/cart/widget/cart_tile.dart';
import 'package:foodly/views/payment/payment_screen.dart';
import 'package:get/get.dart';

class CartPage extends HookWidget {
  const CartPage({super.key});

  /// 🧮 حساب المجموع الكلي وعدد المنتجات داخل السلة
  Map<String, dynamic> calculateTotal(CartData? cart) {
    if (cart == null || cart.items.isEmpty) {
      return {'total': 0.0, 'count': 0, 'subTotal': 0.0, 'shipping': 0.0};
    }

    double subTotal = 0.0;
    int itemCount = 0;
    const double shippingFee = 0.0;

    for (var item in cart.items) {
      subTotal += item.totalPrice;
      itemCount += item.quantity;
    }

    double total = subTotal + shippingFee;

    return {
      'total': total,
      'count': itemCount,
      'subTotal': subTotal,
      'shipping': shippingFee
    };
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final cartController = Get.put(CartController());

    final User? user = authController.getUserInfo() as User?;

    // ✅ تحقق من تسجيل الدخول والتحقق من رقم الجوال
    if (user == null || user.phoneVerification == false) {
      return const LoginRedirect();
    }

    // ✅ تحميل السلة عند فتح الصفحة
    useEffect(() {
      cartController.fetchCart();
      return null;
    }, []);

    return Obx(() {
      final isLoading = cartController.isLoading;
      final CartData? cart = cartController.cart.value?.data;
      final isCartEmpty = cart == null || cart.items.isEmpty;

      final totals = calculateTotal(cart);
      final cartTotal = totals['total'] as double;
      final subTotal = totals['subTotal'] as double;
      final shippingFee = totals['shipping'] as double;
      final itemCount = totals['count'] as int;

      return Scaffold(
        backgroundColor: kOffWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kOffWhite,
          title: ReusableText(
            text: "سلة التسوق ($itemCount)",
            style: appStyle(20, kDark, FontWeight.bold),
            tex: "",
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              CustomContainer(
                color: kOffWhite,
                containerContent: isLoading
                    ? const FoodsListShimmer()
                    : isCartEmpty
                        ? _buildEmptyCart()
                        : Padding(
                            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 200.h),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: cart!.items.length,
                                    itemBuilder: (context, i) {
                                      final item = cart.items[i];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: CartTile(
                                          cartItem: item,
                                          refetch: cartController.fetchCart,
                                          cart: cart,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                _buildOrderSummary(subTotal, shippingFee),
                              ],
                            ),
                          ),
              ),
              if (!isLoading && !isCartEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildCheckoutBar(context, cartTotal, cart!),
                ),
            ],
          ),
        ),
      );
    });
  }

  /// 🛒 شاشة السلة الفارغة
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100.r, color: kGray.withOpacity(0.5)),
          SizedBox(height: 10.h),
          ReusableText(text: "سلتك فارغة!", style: appStyle(20, kDark, FontWeight.bold), tex: ""),
          SizedBox(height: 5.h),
          ReusableText(
            text: "ابدأ بإضافة منتجاتك المفضلة الآن.",
            style: appStyle(14, kGray, FontWeight.normal),
            tex: "",
          ),
          SizedBox(height: 20.h),
          TextButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, size: 18.r, color: kPrimary),
            label: ReusableText(
              text: "تصفح الخدمات",
              style: appStyle(16, kPrimary, FontWeight.w600),
              tex: "",
            ),
          ),
        ],
      ),
    );
  }

  /// 💰 ملخص الطلب
  Widget _buildOrderSummary(double subTotal, double shippingFee) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: kLightWhite,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: kGray.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            _summaryRow("المجموع الفرعي:", subTotal),
            SizedBox(height: 8.h),
            _summaryRow("رسوم التوصيل:", shippingFee, color: kPrimary),
            SizedBox(height: 8.h),
            Divider(color: kGray.withOpacity(0.3), thickness: 1.h),
            _summaryRow("المجموع الكلي النهائي:", subTotal + shippingFee, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String title, double amount, {Color? color, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(
          text: title,
          style: appStyle(isTotal ? 16 : 14, kDark, isTotal ? FontWeight.bold : FontWeight.w500),
          tex: "",
        ),
        ReusableText(
          text: "SAR ${amount.toStringAsFixed(2)}",
          style: appStyle(isTotal ? 18 : 14, color ?? kDark, isTotal ? FontWeight.bold : FontWeight.w600),
          tex: "",
        ),
      ],
    );
  }

  /// ✅ شريط الدفع السفلي
  Widget _buildCheckoutBar(BuildContext context, double total, CartData cart) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: kBlueDark,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        boxShadow: [BoxShadow(color: kGray.withOpacity(0.4), spreadRadius: 3, blurRadius: 15, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(text: "المبلغ المطلوب:", style: appStyle(14, kOffWhite, FontWeight.w500), tex: ""),
              ReusableText(text: "SAR ${total.toStringAsFixed(2)}", style: appStyle(22, kPrimary, FontWeight.bold), tex: ""),
            ],
          ),
          SizedBox(
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () {
                if (cart.items.isEmpty) return;
                Get.to(() => PaymentScreen(
                      orderId: "ORD-${DateTime.now().millisecondsSinceEpoch}",
                      totalAmount: total,
                      currency: "ر.س",
                      restaurantName: cart.items.first.product.restaurant.id,
                    ));
              },
              icon: Icon(Icons.arrow_forward_ios, size: 20.r, color: kDark),
              label: ReusableText(text: "إتمام الشراء", style: appStyle(16, kDark, FontWeight.bold), tex: ""),
              style: ElevatedButton.styleFrom(
                backgroundColor: kLightWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
