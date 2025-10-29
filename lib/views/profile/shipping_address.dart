// ignore_for_file: prefer_collection_literals, prefer_final_fields, unused_local_variable
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly/common/app_style.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/user_location_controller.dart';
import 'package:foodly/models/address_model.dart';
import 'package:foodly/models/address_response.dart';
import 'package:foodly/views/auth/widget/email_textField.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ShippingAddress extends StatefulWidget {
  final AddressResponse? editAddress; // ✅ لدعم التعديل

  const ShippingAddress({super.key, this.editAddress});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  late final PageController _pageController = PageController(initialPage: 0);
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  final TextEditingController _instructions = TextEditingController();

  LatLng? _selectedPosition;
  List<dynamic> _placeList = [];
  List<dynamic> _selectedPlace = [];
  final storage = GetStorage();

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {});
    });
    super.initState();

    // ✅ تعبئة القيم إذا كنا في وضع التعديل
    if (widget.editAddress != null) {
      _searchController.text = widget.editAddress!.addressLine1;
      _postalCode.text = widget.editAddress!.postalCode;
      _instructions.text = widget.editAddress!.deliveryInstructions ?? "";
      _selectedPosition = LatLng(
        widget.editAddress!.latitude ?? 27.5200719,
        widget.editAddress!.longitude ?? 41.7017641,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&key=$googleApiKey");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)["predictions"];
        });
      }
    } else {
      _placeList = [];
    }
  }

  void _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final location = json.decode(response.body);
      final lat = location['result']['geometry']['location']['lat'] as double;
      final lng = location['result']['geometry']['location']['lng'] as double;

      final address = location['result']['formatted_address'];
      String postalCode = "";

      final addressComponents = location['result']['address_components'];
      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _selectedPosition = LatLng(lat, lng);
        _searchController.text = address;
        _postalCode.text = postalCode;
        moveToSelectedPosition();
        _placeList = [];
      });
    }
  }

  void moveToSelectedPosition() {
    if (_selectedPosition != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _selectedPosition!, zoom: 15),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(UserLocationController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        elevation: 0,
        title: Center(
          child: Text(
            widget.editAddress != null
                ? "Edit Shipping Address"
                : "Shipping Address",
          ),
        ),
        leading: Obx(
          () => Padding(
            padding: EdgeInsets.only(right: 0.w),
            child: locationController.tabIndex == 0
                ? IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      AntDesign.closecircleo,
                      color: kRed,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      locationController.setTabIndex = 0;
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    },
                    icon: const Icon(
                      AntDesign.leftcircleo,
                      color: kDark,
                    ),
                  ),
          ),
        ),
        actions: [
          Obx(() => locationController.tabIndex == 1
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: IconButton(
                    onPressed: () {
                      locationController.setTabIndex = 1;
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    },
                    icon: const Icon(AntDesign.rightcircleo),
                  ),
                ))
        ],
      ),
      body: SizedBox(
        height: hieght,
        width: width,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: false,
          onPageChanged: (index) {
            _pageController.jumpToPage(index);
          },
          children: [
            Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                      target:
                          _selectedPosition ?? const LatLng(27.5200719, 41.7017641),
                      zoom: 15),
                  onTap: (LatLng position) async {
                    setState(() {
                      _selectedPosition = position;
                    });
                    // تعبئة الحقول بناءً على الموقع
                    final url = Uri.parse(
                        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey");
                    final res = await http.get(url);
                    if (res.statusCode == 200) {
                      final data = jsonDecode(res.body);
                      if (data['results'].isNotEmpty) {
                        final address = data['results'][0]['formatted_address'];
                        String postal = "";
                        for (var comp
                            in data['results'][0]['address_components']) {
                          if (comp['types'].contains('postal_code')) {
                            postal = comp['long_name'];
                          }
                        }
                        setState(() {
                          _searchController.text = address;
                          _postalCode.text = postal;
                        });
                      }
                    }
                  },
                  markers: {
                    if (_selectedPosition != null)
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: _selectedPosition!,
                      ),
                  },
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      color: kOffWhite,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: "Search for your address ...",
                        ),
                      ),
                    ),
                    _placeList.isEmpty
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _placeList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    visualDensity: VisualDensity.compact,
                                    title: Text(
                                      _placeList[index]['description'],
                                    ),
                                    onTap: () {
                                      _getPlaceDetails(
                                          _placeList[index]['place_id']);
                                      _selectedPlace.add(_placeList[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ],
            ),
            BackGroundContainer(
              color: kOffWhite,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  SizedBox(height: 30.h),
                  EmailTextfield(
                    controller: _searchController,
                    hinText: "Address",
                    prefixIcon: const Icon(Ionicons.location_sharp),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15.h),
                  EmailTextfield(
                    controller: _postalCode,
                    hinText: "Postal Code",
                    prefixIcon: const Icon(Ionicons.location_sharp),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15.h),
                  EmailTextfield(
                    controller: _instructions,
                    hinText: "Delivery Instructions",
                    prefixIcon: const Icon(Ionicons.add_circle),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                          text: "Set address as default",
                          style: appStyle(12, kDark, FontWeight.w600),
                          tex: "",
                        ),
                        Obx(() => CupertinoSwitch(
                              thumbColor: kSecondary,
                              trackColor: kPrimary,
                              value: locationController.isDefault,
                              onChanged: (value) {
                                locationController.setIsDefault = value;
                              },
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    onTap: () async {
                      if (_searchController.text.isNotEmpty &&
                          _postalCode.text.isNotEmpty &&
                          _instructions.text.isNotEmpty &&
                          _selectedPosition != null) {
                        AddressModel model = AddressModel(
                          addressLine1: _searchController.text,
                          city: _searchController.text,
                          district: _searchController.text,
                          state: _searchController.text,
                          country: _searchController.text,
                          postalCode: _postalCode.text,
                          isDefault: locationController.isDefault,
                          deliveryInstructions: _instructions.text,
                          latitude: _selectedPosition!.latitude,
                          longitude: _selectedPosition!.longitude,
                          addressModelDefault: locationController.isDefault,
                        );

                        String data = addressModelToJson(model);
                        final success = await addAddress(data);
                        if (success) Get.back();
                      }
                    },
                    btnHeight: 45,
                    text: widget.editAddress != null
                        ? "U P D A T E"
                        : "S U B M I T",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ الدالة الجديدة التي تنفذ الإضافة أو التعديل فعليًا
  Future<bool> addAddress(String data) async {
    try {
      final token = storage.read("token");
      if (token == null) {
        Get.snackbar("خطأ", "يجب تسجيل الدخول أولاً");
        return false;
      }

      final url = widget.editAddress != null
          ? Uri.parse('$appBaseUrl/api/address/${widget.editAddress!.id}')
          : Uri.parse('$appBaseUrl/api/address');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = widget.editAddress != null
          ? await http.put(url, headers: headers, body: data)
          : await http.post(url, headers: headers, body: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        Get.snackbar("تم بنجاح", body["message"] ?? "تم حفظ العنوان بنجاح");
        return true;
      } else {
        final err = jsonDecode(response.body);
        Get.snackbar("خطأ", err["message"] ?? "فشل في حفظ العنوان");
        return false;
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال: $e");
      return false;
    }
  }
}
