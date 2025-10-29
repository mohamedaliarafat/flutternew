
import 'dart:ffi';

import 'package:foodly/models/additive_obs.dart';
import 'package:foodly/models/foods_model.dart';
import 'package:get/get.dart';

class FoodsController extends GetxController {
  RxInt currentPage = 0.obs;
  bool initialCheckValue = false;
  var additiveList = <AdditiveObs>[].obs;
  

  void changePage(int index) {
    currentPage.value = index;

  }

  RxInt count = 1.obs;

  void increment() {
    count.value++;
  }

  void decrement() {
    if (count.value > 1) {
      count.value--;
    }
  }

 void loadAdditives(List<Additive> additives) {
  additiveList.clear();

  for(var additiveInfo in additives) {
    var additive = AdditiveObs(  
      id: additiveInfo.id, 
      title: additiveInfo.title, 
      price: additiveInfo.price,
      checked: initialCheckValue,
      );
      if(additives.length == additiveList.length) {

      } else {
        additiveList.add(additive);
      }
    }
  }


  List<String> getCartAdditive() {
    List<String> additives = [];

   for (var additive in additiveList) {
    if (additive.isChecked.value && !additives.contains(additive.title)) {
      additives.add(additive.title);
    }else if(
      !additive.isChecked.value && additives.contains(additive.title)
    ) {
      additives.remove(additive.title);
    }
     
   }
   return additives;

  }

 RxDouble _totalPrice = 0.0.obs;

  double get additivePrice => _totalPrice.value;

  set setTotalPrice(double newPrice) {
    _totalPrice.value = newPrice;
  }


double getTotalPrice() {
  double totalPrice = 0.0;

  for (var additive in additiveList) {
    if(additive.isChecked.value) {
      totalPrice += double.tryParse(additive.price) ?? 0.0;
    }
  }

  setTotalPrice = totalPrice;
  return totalPrice;
}

}