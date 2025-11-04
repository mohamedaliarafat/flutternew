class NotificationModel {
  final String id;
  final String title;
  final String body;
  bool isRead; // ✅ يجب أن تكون mutable
  final String userId;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.userId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
