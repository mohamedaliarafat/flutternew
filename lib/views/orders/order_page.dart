import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/logo_transition.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:foodly/models/order_request.dart';
import 'package:foodly/models/restaurants_model.dart';
import 'package:foodly/views/orders/widget/order_tile.dart';
import 'package:foodly/views/payment/payment_screen.dart';
import 'package:foodly/views/restaurant/widget/row_text.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
    this.restaurant,
    required this.food,
    this.item,
  });

  final RestaurantsModel? restaurant;
  final FoodsModel food;
  final OrderItem? item;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kLightWhite, size: 20),
          tooltip: 'رجوع',
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kBlueDark,
        title: ReusableText(
          text: "Complete Ordering",
          style: appStyle(15, kGray, FontWeight.bold),
          tex: "",
        ),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              OrderTile(food: widget.food),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: width,
                height: hieght / 3.8,
                decoration: BoxDecoration(
                  color: kOffWhite,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (restaurant != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                            text: restaurant.title,
                            style: appStyle(20, kGray, FontWeight.bold),
                            tex: "",
                          ),
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: kOffWhite,
                            backgroundImage: NetworkImage(restaurant.logoUrl),
                          ),
                        ],
                      ),
                    SizedBox(height: 5.h),

                    if (restaurant != null)
                      RowText(first: "Business Hours", second: restaurant.time),

                    const RowText(first: "Distance from Company", second: "250 km"),
                    const RowText(first: "Price from Company", second: "SAR"),
                    RowText(
                      first: "Order Total",
                      second: "SAR ${item?.price.toString() ?? '0.00'}",
                    ),

                    SizedBox(height: 20.h),
                    ReusableText(
                      text: "Additives",
                      style: appStyle(20, kGray, FontWeight.bold),
                      tex: "",
                    ),
                    SizedBox(height: 5.h),

                    if (item != null)
                      SizedBox(
                        height: 15.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: item.additives.length,
                          itemBuilder: (context, i) {
                            final additive = item.additives[i];
                            return Container(
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                color: kBlueDark,
                                borderRadius: BorderRadius.all(Radius.circular(9.r)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(2.h),
                                  child: ReusableText(
                                    text: additive,
                                    style: appStyle(8, kWhite, FontWeight.w400),
                                    tex: "",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              CustomButton(
                text: "Proceed to Payment",
                btnWidth: width,
                btnHeight: 45,
                onTap: () {
                  if (item == null || restaurant == null) return;

                  // توليد orderId فريد
                  final orderId =
                      "ORD-${restaurant.title.substring(0, 3).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}";

                  Get.to(() => LogoTransition(
                        nextPage: PaymentScreen(
                          orderId: orderId,
                          totalAmount: item.price,
                          currency: "SAR",
                          restaurantName: restaurant.title,
                        ),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
