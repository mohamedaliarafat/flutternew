import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/cart_controller.dart';
import 'package:foodly/models/cart_response.dart';
import 'package:get/get.dart';

class CartTile extends StatelessWidget {
  const CartTile({
    super.key,
    required this.cartItem,   // الآن عنصر من items
    this.color,
    this.refetch, required CartData cart,
  });

  final CartItem cartItem;
  final Color? color;
  final Function()? refetch;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      height: 95.h,
      width: width,
      decoration: BoxDecoration(
        color: color ?? kOffWhite,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: kGray.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Row(
          children: [
            _buildProductImage(),
            SizedBox(width: 12.w),
            Expanded(child: _buildProductDetails()),
            _buildRightSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = cartItem.product.imageUrl.isNotEmpty
        ? cartItem.product.imageUrl.first
        : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        children: [
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey[200], child: const Icon(Icons.fastfood, color: kGray, size: 28)),
            ),
          ),
          if (cartItem.product.rating > 0)
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: RatingBarIndicator(
                    rating: cartItem.product.rating,
                    itemBuilder: (_, __) => const Icon(Icons.star, color: kPrimary),
                    itemSize: 12.h,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ReusableText(
          text: cartItem.product.title,
          style: appStyle(14, kDark, FontWeight.bold),
          tex: "",
        ),
        SizedBox(height: 4.h),
        if (cartItem.additives.isNotEmpty)
          _buildAdditivesList()
        else
          ReusableText(
            text: "بدون إضافات",
            style: appStyle(11, kGray, FontWeight.w400),
            tex: "",
          ),
        SizedBox(height: 5.h),
        ReusableText(
          text: "الكمية: ${cartItem.quantity}",
          style: appStyle(12, kGray, FontWeight.w500),
          tex: "",
        ),
        SizedBox(height: 5.h),
        if (cartItem.product.restaurant.name.isNotEmpty)
          ReusableText(
            text: "من ${cartItem.product.restaurant.name}",
            style: appStyle(11, kPrimary, FontWeight.w500),
            tex: "",
          ),
      ],
    );
  }

  Widget _buildAdditivesList() {
    return SizedBox(
      height: 22.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: 4.w),
        itemCount: cartItem.additives.length,
        itemBuilder: (_, i) {
          final additive = cartItem.additives[i];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.08),
              border: Border.all(color: kPrimary.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: ReusableText(
                text: additive,
                style: appStyle(10, kDark, FontWeight.w500),
                tex: "",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightSection(CartController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: kSecondary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ReusableText(
            text: "${cartItem.totalPrice.toStringAsFixed(2)} ر.س",
            style: appStyle(12, kLightWhite, FontWeight.bold),
            tex: "",
          ),
        ),
        GestureDetector(
          onTap: () => controller.removeFromCart(cartItem.id, refetch ?? () {}),
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: kRed,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Center(
              child: Icon(MaterialCommunityIcons.trash_can, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
