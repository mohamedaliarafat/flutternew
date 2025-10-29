import 'dart:convert';

OrdersRequest ordersRequestFromJson(String str) =>
    OrdersRequest.fromJson(json.decode(str));

String ordersRequestToJson(OrdersRequest data) => json.encode(data.toJson());

class OrdersRequest {
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
  final List<double> recipintCoords;
  final String delivreId;
  final int rating;
  final String feedback;
  final String promoCode;
  final double discountAmount;
  final String notes;

  OrdersRequest({
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
    required this.recipintCoords,
    required this.delivreId,
    required this.rating,
    required this.feedback,
    required this.promoCode,
    required this.discountAmount,
    required this.notes,
  });

  factory OrdersRequest.fromJson(Map<String, dynamic> json) => OrdersRequest(
        userId: json["userId"] ?? "",
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
        orderStatus: json["orderStatus"] ?? "Pending Review",
        restaurantId: json["restaurantId"],
        restaurantCoords: json["restaurantCoords"] != null
            ? List<double>.from(
                json["restaurantCoords"].map((x) => (x ?? 0).toDouble()))
            : [],
        recipintCoords: json["recipintCoords"] != null
            ? List<double>.from(
                json["recipintCoords"].map((x) => (x ?? 0).toDouble()))
            : [],
        delivreId: json["delivreId"] ?? "",
        rating: json["rating"] ?? 3,
        feedback: json["feedback"] ?? "",
        promoCode: json["promoCode"] ?? "",
        discountAmount: (json["discountAmount"] ?? 0).toDouble(),
        notes: json["notes"] ?? "",
      );

  Map<String, dynamic> toJson() => {
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
        "recipintCoords": List<dynamic>.from(recipintCoords.map((x) => x)),
        "delivreId": delivreId,
        "rating": rating,
        "feedback": feedback,
        "promoCode": promoCode,
        "discountAmount": discountAmount,
        "notes": notes,
      };
}

class OrderItem {
  final String foodId;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instructions;

  OrderItem({
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instructions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json["foodId"] ?? "",
        quantity: json["quantity"] ?? 1,
        price: (json["price"] ?? 0).toDouble(),
        additives: json["additives"] != null
            ? List<String>.from(json["additives"].map((x) => x))
            : [],
        instructions: json["instructions"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
      };
}
