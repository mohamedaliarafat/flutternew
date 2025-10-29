import 'dart:convert';

OrdersModel ordersModelFromJson(String str) =>
    OrdersModel.fromJson(json.decode(str));

String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  final String id;
  final String userId;
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String? deliveryAddress;
  final String restaurantAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? restaurantId;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  OrdersModel({
    required this.id,
    required this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.restaurantAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.restaurantId,
    required this.restaurantCoords,
    required this.recipientCoords,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        id: json["_id"],
        userId: json["userId"],
        orderItems: json["orderItems"] != null
            ? List<OrderItem>.from(
                json["orderItems"].map((x) => OrderItem.fromJson(x)))
            : [],
        orderTotal: (json["orderTotal"] ?? 0).toDouble(),
        deliveryFee: (json["deliveryFee"] ?? 0).toDouble(),
        grandTotal: (json["grandTotal"] ?? 0).toDouble(),
        deliveryAddress: json["deliveryAddress"],
        restaurantAddress: json["restaurantAddress"] ?? "",
        paymentMethod: json["paymentMethod"] ?? "",
        paymentStatus: json["paymentStatus"] ?? "Pending",
        orderStatus: json["orderStatus"] ?? "Pending",
        restaurantId: json["restaurantId"],
        restaurantCoords: json["restaurantCoords"] != null
            ? List<double>.from(
                json["restaurantCoords"].map((x) => (x ?? 0).toDouble()))
            : [],
        recipientCoords: json["recipintCoords"] != null
            ? List<double>.from(
                json["recipintCoords"].map((x) => (x ?? 0).toDouble()))
            : [],
        orderDate: DateTime.parse(json["createdAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );

  get items => null;

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddress": deliveryAddress,
        "restaurantAddress": restaurantAddress,
        "paymentMethod": paymentMethod,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "restaurantId": restaurantId,
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "recipintCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class OrderItem {
  final FoodId foodId;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instructions;
  final String id;

  OrderItem({
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instructions,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: FoodId.fromJson(json["foodId"]),
        quantity: json["quantity"] ?? 1,
        price: (json["price"] ?? 0).toDouble(),
        additives: json["additives"] != null
            ? List<String>.from(json["additives"].map((x) => x))
            : [],
        instructions: json["instructions"] ?? "",
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId.toJson(),
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
        "_id": id,
      };
}

class FoodId {
  final String id;
  final String? title;
  final double? rating;
  final List<String> imageUrl;
  final String? time;

  FoodId({
    required this.id,
    this.title,
    this.rating,
    required this.imageUrl,
    this.time,
  });

  factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"] ?? "",
        title: json["title"],
        rating: (json["rating"] ?? 0).toDouble(),
        imageUrl: json["imageUrl"] != null
            ? List<String>.from(json["imageUrl"].map((x) => x))
            : [],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "rating": rating,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "time": time,
      };
}
