// import 'dart:convert';

// CartRequest cartRequestFromJson(String str) =>
//     CartRequest.fromJson(json.decode(str));

// String cartRequestToJson(CartRequest data) => json.encode(data.toJson());

// class CartRequest {
//   final String productId;
//   final List<String> additives;
//   final int quantity;
//   final double totalPrice;

//   CartRequest( {
//     required this.productId,
//     required this.additives,
//     required this.quantity,
//     required this.totalPrice,
//   });

//   factory CartRequest.fromJson(Map<String, dynamic> json) => CartRequest(
//               productId: json["productId"] ?? '',
//         additives: json["additives"] != null
//             ? List<String>.from(json["additives"].map((x) => x.toString()))
//             : [],
//         quantity: json["quantity"] ?? 1,
//         totalPrice: (json["totalPrice"] ?? 0).toDouble(),
//       );

//  Map<String, dynamic> toJson() => {
//         "productId": productId,
//         "additives": additives,
//         "quantity": quantity,
//         "totalPrice": totalPrice,
//       };
//   /// إنشاء نسخة محدثة من CartRequest
//   CartRequest copyWith({
//     String? userId,
//     String? productId,
//     List<String>? additives,
//     int? quantity,
//     double? totalPrice,
//   }) {
//     return CartRequest(
//           productId: productId ?? this.productId,
//       additives: additives ?? this.additives,
//       quantity: quantity ?? this.quantity,
//       totalPrice: totalPrice ?? this.totalPrice,
//     );
//   }
// }
