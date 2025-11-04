import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/custom_container.dart';
import 'package:foodly/common/custom_text_field.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/search_controller.dart';
import 'package:foodly/views/search/loading_widget.dart';
import 'package:foodly/views/search/search_result.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchFoodController());
     return Scaffold(
      backgroundColor: Color(0xFF070B35),
      appBar: AppBar(
        toolbarHeight: 74.h,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        title: Padding(padding: EdgeInsets.only(top: 12.h),
        child: CustomTextWidget(
            controller: _searchController,
            keyboardType: TextInputType.text,
            hintText: "البحيرة العربية - Al-Buhaira Al-Arabia", obscureText: false,
            suffixIcon: GestureDetector(
              onTap: () {
                if (controller.isTriggered == false ) {
                  controller.searchFoods(_searchController.text);
                  controller.setTrigger = true;
                } else {
                  controller.searchResults = null;
                  controller.setTrigger = false;
                  _searchController.clear();
                }
              },
              child: controller.searchResults == null 
              ?  Icon(  Ionicons.search_circle, 
              size: 35, color: const Color.fromARGB(255, 14, 34, 65))
              :  Icon(Ionicons.close_circle,
              size: 30.h, color: kRed
              ) 
              ),
          
         ),
        ),

      ),
      body: SafeArea(
        child: CustomContainer(
          color: Colors.white,
          containerContent: controller.isLoading 
          ? const FoodsListShimmer()  
          : controller.searchResults == null ? const LoadingWidget() 
          : const SearchResult()
          ),
      ), );
  }
}