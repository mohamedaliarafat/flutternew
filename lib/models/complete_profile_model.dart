class CompleteProfileResponse {
  final bool success;
  final String message;
  final UserData? data;

  CompleteProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CompleteProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompleteProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String id;
  final String email;
  final Map<String, dynamic>? documents;
  final String? phone;
  final bool? phoneVerified;
  final String? userType;
  final String? createdAt;
  final String? updatedAt;

  UserData({
    required this.id,
    required this.email,
    this.documents,
    this.phone,
    this.phoneVerified,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      documents: json['documents'],
      phone: json['phone'],
      phoneVerified: json['phoneVerification'],
      userType: json['userType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
