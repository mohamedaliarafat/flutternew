import 'dart:convert';

AddressResponse addressResponseFromJson(String str) => AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) => json.encode(data.toJson());

class AddressResponse {
    final String id;
    final String userId;
    final String addressLine1;
    final String city;
    final String postalCode;
    final bool isDefault;
    final String deliveryInstructions;
    final double latitude;
    final double longitude;
    final int v;

    AddressResponse({
        required this.id,
        required this.userId,
        required this.addressLine1,
        required this.city,
        required this.postalCode,
        required this.isDefault,
        required this.deliveryInstructions,
        required this.latitude,
        required this.longitude,
        required this.v,
    });

    factory AddressResponse.fromJson(Map<String, dynamic> json) => AddressResponse(
        id: json["_id"],
        userId: json["userId"],
        addressLine1: json["addressLine1"],
        city: json["city"],
        postalCode: json["postalCode"],
        isDefault: json["isDefault"],
        deliveryInstructions: json["deliveryInstructions"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "addressLine1": addressLine1,
        "city": city,
        "postalCode": postalCode,
        "isDefault": isDefault,
        "deliveryInstructions": deliveryInstructions,
        "latitude": latitude,
        "longitude": longitude,
        "__v": v,
    };
}
