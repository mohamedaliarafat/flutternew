class User {
  final String id;
  final String phone;
  final bool phoneVerification;
  final List<dynamic> addresses;
  final dynamic cart;
  final List<dynamic> orders;

  User({
    required this.id,
    required this.phone,
    required this.phoneVerification,
    required this.addresses,
    required this.cart,
    required this.orders,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      phone: json['phone'],
      phoneVerification: json['phoneVerification'] ?? false,
      addresses: json['addresses'] ?? [],
      cart: json['cart'],
      orders: json['orders'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'phone': phone,
        'phoneVerification': phoneVerification,
        'addresses': addresses,
        'cart': cart,
        'orders': orders,
      };
}
