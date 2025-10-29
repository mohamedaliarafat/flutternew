import 'dart:convert';

List<CartResponse> cartResponseFromJson(String str) => List<CartResponse>.from(json.decode(str).map((x) => CartResponse.fromJson(x)));

String cartResponseToJson(List<CartResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponse {
    final String id;
    final String userId;
    final ProductId productId;
    final List<String> additives;
    final double totalPrice;
    final int quantity;

    CartResponse({
        required this.id,
        required this.userId,
        required this.productId,
        required this.additives,
        required this.totalPrice,
        required this.quantity,
    });

    factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        id: json["_id"],
        userId: json["userId"],
        productId: ProductId.fromJson(json["productId"]),
        additives: List<String>.from(json["additives"].map((x) => x)),
        totalPrice: json["totalPrice"]?.toDouble(),
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "productId": productId.toJson(),
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "totalPrice": totalPrice,
        "quantity": quantity,
    };
}

class ProductId {
    final String id;
    final String title;
    final List<String> imageUrl;
    final Restaurant restaurant;
    final double rating;
    final String ratingCount;

    ProductId({
        required this.id,
        required this.title,
        required this.imageUrl,
        required this.restaurant,
        required this.rating,
        required this.ratingCount,
    });

    factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        title: json["title"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        restaurant: Restaurant.fromJson(json["restaurant"]),
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "restaurant": restaurant.toJson(),
        "rating": rating,
        "ratingCount": ratingCount,
    };
}

class Restaurant {
    final Coords coords;
    final String id;
    final String time;

    Restaurant({
        required this.coords,
        required this.id,
        required this.time,
    });

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "time": time,
    };
}

class Coords {
    final String id;
    final double latitude;
    final double longitude;
    final double latitudeDelta;
    final double longitudeDelta;
    final String address;
    final String title;

    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.latitudeDelta,
        required this.longitudeDelta,
        required this.address,
        required this.title,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        latitudeDelta: json["latitudeDelta"]?.toDouble(),
        longitudeDelta: json["longitudeDelta"]?.toDouble(),
        address: json["address"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
        "address": address,
        "title": title,
    };
}
