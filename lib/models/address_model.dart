import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
    final String addressLine1;
    final String city;
    final String district;
    final String state;
    final String country;
    final String postalCode;
    final bool isDefault;
    final bool addressModelDefault;
    final String deliveryInstructions;
    final double latitude;
    final double longitude;

    AddressModel({
        required this.addressLine1,
        required this.city,
        required this.district,
        required this.state,
        required this.country,
        required this.postalCode,
        required this.isDefault,
        required this.addressModelDefault,
        required this.deliveryInstructions,
        required this.latitude,
        required this.longitude,
    });

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addressLine1: json["addressLine1"],
        city: json["city"],
        district: json["district"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postalCode"],
        isDefault: json["isDefault"],
        addressModelDefault: json["addressModelDefault"],
        deliveryInstructions: json["deliveryInstructions"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "addressLine1": addressLine1,
        "city": city,
        "district": district,
        "state": state,
        "country": country,
        "postalCode": postalCode,
        "isDefault": isDefault,
        "addressModelDefault": addressModelDefault,
        "deliveryInstructions": deliveryInstructions,
        "latitude": latitude,
        "longitude": longitude,
    };
}
