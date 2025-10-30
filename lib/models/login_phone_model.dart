import 'package:foodly/models/cart_response.dart';

class User {
  String id;
  String phone;
  bool phoneVerification;
  List<dynamic> addresses;
  List<CartResponse> cart; // هنا السلة
  List<dynamic> orders;

  User({
    required this.id,
    required this.phone,
    required this.phoneVerification,
    required this.addresses,
    required this.cart,
    required this.orders,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'] ?? '',
        phone: json['phone'] ?? '',
        phoneVerification: json['phoneVerification'] ?? false,
        addresses: json['addresses'] ?? [],
        cart: json['cartItems'] != null
            ? List<CartResponse>.from(
                json['cartItems'].map((x) => CartResponse.fromJson(x)))
            : [],
        orders: json['orders'] ?? [],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'phone': phone,
        'phoneVerification': phoneVerification,
        'addresses': addresses,
        'cartItems': cart.map((e) => e.toJson()).toList(),
        'orders': orders,
      };
}
