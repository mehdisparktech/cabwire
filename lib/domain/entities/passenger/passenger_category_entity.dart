import 'package:cabwire/core/base/base_entity.dart';

class PassengerCategoryEntity extends BaseEntity {
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

  const PassengerCategoryEntity({
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

  @override
  List<Object?> get props => [
    id,
    categoryName,
    image,
    basePrice,
    ratePerKm,
    ratePerHour,
    status,
    isActive,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
