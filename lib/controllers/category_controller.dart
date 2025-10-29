import 'package:get/get.dart';

class CategoryController extends GetxController {
 final RxString _category = ''.obs;

  String get categoryValue => _category.value;

  set updateCategory(String value) {
    _category.value = value;
    print(_category.value);
    }
     
   final RxString _title = ''.obs;
     String get titleValue => _title.value;

  get allCategories => null;
     set updateTitle(String value) {
       _title.value = value;
     }

  }