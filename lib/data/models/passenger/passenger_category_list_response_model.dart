class PassengerCategoryListResponseModel {
  final bool success;
  final String message;
  final List<PassengerCategoryModel> data;

  PassengerCategoryListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PassengerCategoryListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PassengerCategoryListResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<PassengerCategoryModel>.from(
                (json['data'] as List).map(
                  (item) => PassengerCategoryModel.fromJson(item),
                ),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((category) => category.toJson()).toList(),
    };
  }
}

class PassengerCategoryModel {
  final String id;
  final String categoryName;
  final String image;
  final double basePrice;
  final double ratePerKm;
  final double ratePerHour;
  final String status;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  PassengerCategoryModel({
    required this.id,
    required this.categoryName,
    required this.image,
    required this.basePrice,
    required this.ratePerKm,
    required this.ratePerHour,
    required this.status,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PassengerCategoryModel.fromJson(Map<String, dynamic> json) {
    return PassengerCategoryModel(
      id: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      image: json['image'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      ratePerKm: (json['ratePerKm'] ?? 0).toDouble(),
      ratePerHour: (json['ratePerHour'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'image': image,
      'basePrice': basePrice,
      'ratePerKm': ratePerKm,
      'ratePerHour': ratePerHour,
      'status': status,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
