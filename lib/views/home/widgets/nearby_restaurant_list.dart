import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/shimmers/nearby_shimmer.dart';
import 'package:foodly/hooks/fetch_restaurants.dart';
import 'package:foodly/models/restaurants_model.dart';
import 'package:foodly/views/home/widgets/restaruant_widget.dart';
import 'package:foodly/views/restaurant/restaurant_page.dart';
import 'package:get/get.dart';

class NearbyRestaurant extends HookWidget {
  const NearbyRestaurant({super.key});


  
  @override
  Widget build(BuildContext context) {
     final hookResult = useFetchRestaurants("41007428");
    List<RestaurantsModel>? restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;
    // ignore: unused_local_variable
    final error = hookResult.error;

    
    return isLoading ? const NearbyShimmer() : Container(
      height: 190.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: isLoading ? const NearbyShimmer() : ListView(
        scrollDirection: Axis.horizontal,
        children:
        List.generate(restaurants!.length, (i) {
          RestaurantsModel restaurant = restaurants[i]; 
          // TODO: Return a widget for each restaurant here
          return RestaruantWidget(
            onTap: () {
              Get.to(() => RestaurantPage(restaurant: restaurant));
            },
            image: restaurant.imageUrl,
            logo: restaurant.logoUrl,
            title: restaurant.title,
            time: restaurant.time,
            rating: restaurant.ratingCount,
          ); // Placeholder, replace with your widget
        }
        ),
        
      ),
    );
  }
}