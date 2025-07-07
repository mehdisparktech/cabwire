class PassengerServiceListResponseModel {
  final bool success;
  final String message;
  final List<PassengerServiceModel> data;

  PassengerServiceListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PassengerServiceListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PassengerServiceListResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? List<PassengerServiceModel>.from(
                (json['data'] as List).map(
                  (item) => PassengerServiceModel.fromJson(item),
                ),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((service) => service.toJson()).toList(),
    };
  }
}

class PassengerServiceModel {
  final String id;
  final String serviceName;
  final String image;
  final double baseFare;
  final String status;
  final String createdAt;
  final String updatedAt;

  PassengerServiceModel({
    required this.id,
    required this.serviceName,
    required this.image,
    required this.baseFare,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PassengerServiceModel.fromJson(Map<String, dynamic> json) {
    return PassengerServiceModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      image: json['image'] ?? '',
      baseFare: (json['baseFare'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceName': serviceName,
      'image': image,
      'baseFare': baseFare,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
