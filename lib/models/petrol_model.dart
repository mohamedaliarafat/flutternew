class OrderModel {
  final String id;
  final String userId;
  final String fuelType;
  final double fuelLiters;
  final String notes;
  final double? price;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.fuelType,
    required this.fuelLiters,
    required this.notes,
    this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      fuelType: json['fuelType'] ?? '',
      fuelLiters: (json['fuelLiters'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
