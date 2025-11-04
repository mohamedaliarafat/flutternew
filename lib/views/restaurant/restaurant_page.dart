// ignore_for_file: prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/restaurants_model.dart';
import 'package:foodly/views/restaurant/widget/restaurant_bottom_bar.dart';
import 'package:foodly/views/restaurant/widget/restaurant_menu.dart';
import 'package:foodly/views/restaurant/widget/restaurant_top_bar.dart';
import 'package:foodly/views/restaurant/widget/row_text.dart';
import 'package:foodly/views/restaurant/widget/xplore_widget.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key, required this.restaurant});
  final RestaurantsModel? restaurant;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final tabHeight = screenHeight -
        230.h - // ارتفاع الصورة
        10.h - // SizedBox
        25.h - // ارتفاع TabBar
        50.h; // تقدير padding إضافي

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kLightWhite,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 230.h,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.restaurant!.imageUrl,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: RestaurantBottomBar(widget: widget),
                ),
                Positioned(
                  top: 40.h,
                  left: 0,
                  right: 0,
                  child: RestaurantTopBar(widget: widget),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  RowText(first: "Distance to Company", second: "50 km"),
                  SizedBox(height: 3.h),
                  RowText(first: "Estimated Price", second: "\uFDFC 120"),
                  RowText(first: "Estimated Time", second: "2 h"),
                  Divider(thickness: 0.7),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Container(
                height: 25.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kOffWhite,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: kBlueDark,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  labelPadding: EdgeInsets.zero,
                  labelColor: kLightWhite,
                  labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                  unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                  tabs: [
                    Tab(
                      child: SizedBox(
                        width: double.infinity,
                        height: 25.h,
                        child: const Center(child: Text("Menu")),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        width: double.infinity,
                        height: 25.h,
                        child: const Center(child: Text("Explore")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SizedBox(
                height: tabHeight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RestaurantMenuWidget(
                        restaurantId: widget.restaurant!.id),
                    XploreWidget(code: widget.restaurant!.code),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
