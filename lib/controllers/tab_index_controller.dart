import 'package:get/get.dart';

class TabIndexController extends GetxController {

  RxInt _tabInddex = 0.obs;

  int get tabIndex => _tabInddex.value;

  set setTabIndex(int newValue){
    _tabInddex.value = newValue;
  }
}