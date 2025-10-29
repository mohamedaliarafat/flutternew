import 'dart:convert';

List<FoodsModel> foodsModelFromJson(String str) => List<FoodsModel>.from(json.decode(str).map((x) => FoodsModel.fromJson(x)));

String foodsModelToJson(List<FoodsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodsModel {
    final String id;
    final String title;
    final String time;
    final List<String> foodTags;
    final List<String> foodType;
    final String category;
    final List<String> imageUrl;
    final String code;
    final String restaurant;
    final double rating;
    final String ratingCount;
    final bool isAvailable;
    final String description;
    final double price;
    final List<Additive> additives;
    final DateTime createdAt;
    final DateTime updatedAt;

    FoodsModel({
        required this.id,
        required this.title,
        required this.time,
        required this.foodTags,
        required this.foodType,
        required this.category,
        required this.imageUrl,
        required this.code,
        required this.restaurant,
        required this.rating,
        required this.ratingCount,
        required this.isAvailable,
        required this.description,
        required this.price,
        required this.additives,
        required this.createdAt,
        required this.updatedAt,
    });

    factory FoodsModel.fromJson(Map<String, dynamic> json) => FoodsModel(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        foodTags: List<String>.from(json["foodTags"].map((x) => x)),
        foodType: List<String>.from(json["foodType"].map((x) => x)),
        category: json["category"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        code: json["code"],
        restaurant: json["restaurant"],
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
        isAvailable: json["isAvailable"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        additives: List<Additive>.from(json["additives"].map((x) => Additive.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "foodTags": List<dynamic>.from(foodTags.map((x) => x)),
        "foodType": List<dynamic>.from(foodType.map((x) => x)),
        "category": category,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "code": code,
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "isAvailable": isAvailable,
        "description": description,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

class Additive {
    final int id;
    final String title;
    final String price;

    Additive({
        required this.id,
        required this.title,
        required this.price,
    });

    factory Additive.fromJson(Map<String, dynamic> json) => Additive(
        id: json["id"],
        title: json["title"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
    };
}
