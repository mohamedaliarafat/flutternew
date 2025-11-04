// import 'dart:convert';

// /// ✅ تحويل JSON إلى كائن CartResponse كامل
// CartResponse cartResponseFromJson(String str) =>
//     CartResponse.fromJson(json.decode(str));

// /// ✅ تحويل كائن CartResponse إلى JSON
// String cartResponseToJson(CartResponse data) =>
//     json.encode(data.toJson());

// /// 🧾 نموذج الاستجابة الكاملة من السيرفر
// class CartResponse {
//   final bool success;
//   final String message;
//   final CartData? data;

//   CartResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
//         success: json["success"] ?? false,
//         message: json["message"] ?? '',
//         data: json["data"] != null ? CartData.fromJson(json["data"]) : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": data?.toJson(),
//       };
// }

// /// 🛒 كائن بيانات السلة الفعلية
// class CartData {
//   final String id;
//   final UserId user;
//   final List<CartItem> items;
//   final double totalPrice;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   CartData({
//     required this.id,
//     required this.user,
//     required this.items,
//     required this.totalPrice,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory CartData.fromJson(Map<String, dynamic> json) => CartData(
//         id: json["_id"] ?? '',
//         user: json["user"] != null
//             ? UserId.fromJson(json["user"])
//             : UserId.empty(),
//         items: json["items"] != null
//             ? List<CartItem>.from(
//                 json["items"].map((x) => CartItem.fromJson(x)))
//             : [],
//         totalPrice: (json["totalPrice"] ?? 0).toDouble(),
//         createdAt: json["createdAt"] != null
//             ? DateTime.tryParse(json["createdAt"])
//             : null,
//         updatedAt: json["updatedAt"] != null
//             ? DateTime.tryParse(json["updatedAt"])
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "user": user.toJson(),
//         "items": List<dynamic>.from(items.map((x) => x.toJson())),
//         "totalPrice": totalPrice,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//       };
// }

// /// 🧺 عنصر داخل السلة
// class CartItem {
//   final String id;
//   final Product product;
//   final List<String> additives;
//   final int quantity;
//   final double totalPrice;

//   CartItem({
//     required this.id,
//     required this.product,
//     required this.additives,
//     required this.quantity,
//     required this.totalPrice,
//   });

//   factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
//         id: json["_id"] ?? '',
//         product: json["product"] != null
//             ? Product.fromJson(json["product"])
//             : Product.empty(),
//         additives: json["additives"] != null
//             ? List<String>.from(json["additives"].map((x) => x.toString()))
//             : [],
//         quantity: json["quantity"] ?? 1,
//         totalPrice: (json["totalPrice"] ?? 0).toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "product": product.toJson(),
//         "additives": additives,
//         "quantity": quantity,
//         "totalPrice": totalPrice,
//       };
// }

// /// 👤 المستخدم المرتبط بالسلة
// class UserId {
//   final String id;
//   final String phone;
//   final bool phoneVerification;
//   final String userType;

//   UserId({
//     required this.id,
//     required this.phone,
//     required this.phoneVerification,
//     required this.userType,
//   });

//   factory UserId.fromJson(Map<String, dynamic> json) => UserId(
//         id: json["_id"] ?? '',
//         phone: json["phone"] ?? '',
//         phoneVerification: json["phoneVerification"] ?? false,
//         userType: json["userType"] ?? 'Client',
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "phone": phone,
//         "phoneVerification": phoneVerification,
//         "userType": userType,
//       };

//   factory UserId.empty() => UserId(
//         id: '',
//         phone: '',
//         phoneVerification: false,
//         userType: 'Client',
//       );
// }

// /// 🍔 المنتج داخل السلة
// class Product {
//   final String id;
//   final String title;
//   final List<String> imageUrl;
//   final double price;
//   final double rating;
//   final String ratingCount;
//   final Restaurant restaurant;

//   Product({
//     required this.id,
//     required this.title,
//     required this.imageUrl,
//     required this.price,
//     required this.rating,
//     required this.ratingCount,
//     required this.restaurant,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["_id"] ?? '',
//         title: json["title"] ?? '',
//         imageUrl: json["imageUrl"] != null
//             ? List<String>.from(json["imageUrl"].map((x) => x.toString()))
//             : [],
//         price: (json["price"] ?? 0).toDouble(),
//         rating: (json["rating"] ?? 0).toDouble(),
//         ratingCount: json["ratingCount"]?.toString() ?? '0',
//         restaurant: json["restaurant"] != null
//             ? Restaurant.fromJson(json["restaurant"])
//             : Restaurant.empty(),
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "imageUrl": imageUrl,
//         "price": price,
//         "rating": rating,
//         "ratingCount": ratingCount,
//         "restaurant": restaurant.toJson(),
//       };

//   factory Product.empty() => Product(
//         id: '',
//         title: '',
//         imageUrl: [],
//         price: 0.0,
//         rating: 0.0,
//         ratingCount: '0',
//         restaurant: Restaurant.empty(),
//       );
// }

// /// 🍽️ المطعم المرتبط بالمنتج
// class Restaurant {
//   final String id;
//   final String name;
//   final Coords coords;
//   final String time;

//   Restaurant({
//     required this.id,
//     required this.name,
//     required this.coords,
//     required this.time,
//   });

//   factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
//         id: json["_id"] ?? '',
//         name: json["name"] ?? '',
//         coords: json["coords"] != null
//             ? Coords.fromJson(json["coords"])
//             : Coords.empty(),
//         time: json["time"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "coords": coords.toJson(),
//         "time": time,
//       };

//   factory Restaurant.empty() => Restaurant(
//         id: '',
//         name: '',
//         coords: Coords.empty(),
//         time: '',
//       );
// }

// /// 📍 إحداثيات المطعم
// class Coords {
//   final String id;
//   final double latitude;
//   final double longitude;
//   final String address;
//   final String title;

//   Coords({
//     required this.id,
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//     required this.title,
//   });

//   factory Coords.fromJson(Map<String, dynamic> json) => Coords(
//         id: json["id"] ?? '',
//         latitude: (json["latitude"] ?? 0).toDouble(),
//         longitude: (json["longitude"] ?? 0).toDouble(),
//         address: json["address"] ?? '',
//         title: json["title"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "latitude": latitude,
//         "longitude": longitude,
//         "address": address,
//         "title": title,
//       };

//   factory Coords.empty() => Coords(
//         id: '',
//         latitude: 0.0,
//         longitude: 0.0,
//         address: '',
//         title: '',
//       );
// }
