import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly/common/app_style.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/user_location_controller.dart';
import 'package:foodly/models/address_response.dart';
import 'package:foodly/common/back_ground_container.dart';
import 'package:foodly/common/custom_button.dart';
import 'package:foodly/common/reusable_text.dart';
import 'package:foodly/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly/views/profile/shipping_address.dart';
import 'package:http/http.dart' as http;

class AddressesPage extends HookWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAddresses();
    final List<AddressResponse> addresses = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    final locationController = Get.put(UserLocationController());

    // دالة حذف العنوان
    Future<void> deleteAddress(AddressResponse address) async {
      final box = GetStorage();
      final token = box.read("token");
      if (token == null) return;

      final url = Uri.parse("$appBaseUrl/api/address/${address.id}");

      try {
        final response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar("تم", "تم حذف العنوان بنجاح");
          hookResult.refetch(); // إعادة تحميل العناوين
        } else {
          Get.snackbar("خطأ", "فشل حذف العنوان");
        }
      } catch (e) {
        Get.snackbar("خطأ", "حدث خطأ أثناء الحذف: $e");
      }
    }

    // دالة تعديل العنوان
    void editAddress(AddressResponse address) {
      Get.to(() => ShippingAddress(
            editAddress: address, // أرسل العنوان ليتم التعديل
          ))?.then((_) {
        hookResult.refetch(); // إعادة تحميل القائمة بعد التعديل
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: "Address",
          style: appStyle(20, kLightWhite, FontWeight.w600),
          tex: "",
        ),
        backgroundColor: const Color.fromARGB(255, 4, 57, 148),
      ),
      body: BackGroundContainer(
        color: kOffWhite,
        child: Column(
          children: [
            // عرض العنوان الحالي أعلى الصفحة
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: kOffWhite,
                    backgroundImage: const NetworkImage(
                      "https://b.top4top.io/p_35575874g1.png",
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          text: "توصيل إلى",
                          style: appStyle(
                            15,
                            const Color.fromARGB(255, 14, 34, 65),
                            FontWeight.bold,
                          ),
                          tex: '',
                        ),
                        Obx(() {
                          final selected = locationController.selectedAddress.value;
                          return Text(
                            selected?.addressLine1 ??
                                "حائل, المنطقة الصناعية , المملكة العربية السعودية",
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(12, kGray, FontWeight.normal),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // قائمة العناوين
            Expanded(
              child: isLoading
                  ? const FoodsListShimmer()
                  : AddressListWidget(
                      addresses: addresses,
                      onAddressSelected: (address) {
                        locationController.selectAddress(address);
                        Get.back();
                      },
                      onDeleteAddress: deleteAddress,
                      onEditAddress: editAddress,
                    ),
            ),

            // زر إضافة عنوان جديد
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 30.h),
              child: CustomButton(
                btnHeight: 40,
                btnWidth: width,
                onTap: () => Get.to(() => const ShippingAddress())?.then((_) {
                  hookResult.refetch();
                }),
                text: "Add Address",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// تعديل AddressListWidget لقبول callback للحذف والتعديل
class AddressListWidget extends StatelessWidget {
  final List<AddressResponse> addresses;
  final void Function(AddressResponse) onAddressSelected;
  final void Function(AddressResponse) onDeleteAddress;
  final void Function(AddressResponse) onEditAddress;

  const AddressListWidget({
    super.key,
    required this.addresses,
    required this.onAddressSelected,
    required this.onDeleteAddress,
    required this.onEditAddress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return ListTile(
          title: Text(address.addressLine1),
          subtitle: Text(address.postalCode),
          onTap: () => onAddressSelected(address),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEditAddress(address),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDeleteAddress(address),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Hook لجلب العناوين
FetchAddresses useFetchAddresses() {
  final addresses = useState<List<AddressResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final box = GetStorage();
      final token = box.read("token");
      if (token == null) {
        print("❌ Token not found");
        isLoading.value = false;
        return;
      }

      Uri url = Uri.parse("$appBaseUrl/api/address/all");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("📍Fetched addresses: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        addresses.value =
            decoded.map((item) => AddressResponse.fromJson(item)).toList();
      } else {
        print("❌ Error fetching addresses: ${response.body}");
      }
    } catch (e) {
      error.value = Exception(e.toString());
      print("⚠️ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() => fetchData();

  return FetchAddresses(
    data: addresses.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

class FetchAddresses {
  final List<AddressResponse>? data;
  final bool isLoading;
  final Exception? error;
  final void Function() refetch;

  FetchAddresses({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.refetch,
  });
}
