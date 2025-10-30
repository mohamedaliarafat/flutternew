import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/models/api_error.dart';
import 'package:foodly/models/login_response.dart';
import 'package:foodly/views/auth/verification_page.dart';
import 'package:foodly/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;


class LoginController extends GetxController {
  final box = GetStorage();
  
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  
  get data => null;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }


void loginFunction(String data) async {
  
  setLoading = true;

  Uri url = Uri.parse('$appBaseUrl/login');

  Map<String, String> headers ={'Content-Type' : 'application/json'};

  try {
    var response = await http.post(
      url,
      headers: headers, body: data);

      if(response.statusCode == 200) {
        var data = loginResponseFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);

        box.write(userId, userData);
        box.write("token", data.userToken);
        box.write("userId", data.id);
        box.write("verification", data.verification);

        setLoading = false;

        Get.snackbar("You are successfully logged in", "Enjoy your awesom experience",
        colorText: kLightWhite,
        backgroundColor: kPrimary,
        icon:  const Icon(Ionicons.train_outline)
        
        );
        if(data.verification == false) {
          Get.offAll(() => const VerificationPage(),
          transition: Transition.fade,
          duration: Duration(milliseconds: 900));
          }

          if(data.verification == false) {
          Get.offAll(() => const VerificationPage(),
          transition: Transition.fade,
          duration: Duration(milliseconds: 900));
          }

        Get.offAll(() => MainScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 900));
      } else {
        var error = apiErrorFromJson(response.body);


        Get.snackbar("Faild to login", error.message,




        
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon:  const Icon(Icons.error_outline));
      }
    
  } catch (e) {
    debugPrint(e.toString());
  }
}


void logout() {
  box.erase();
  Get.offAll(() => MainScreen(),
  transition: Transition.fade,
  duration: const Duration(milliseconds: 900)
  );
}

LoginResponse? getUserInfo() {
  String? userId = box.read("userId");
  String? data;

  if(userId != null) {
    data = box.read(userId.toString());
  }

  if(data != null) {
    return loginResponseFromJson(data);
  }

  return null;

  
}

  loginResponseFromJson(String body) {}

}