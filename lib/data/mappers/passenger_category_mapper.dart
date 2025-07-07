import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/passenger/passenger_category_list_response_model.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';

class PassengerCategoryMapper {
  static PassengerCategoryEntity fromModel(PassengerCategoryModel model) {
    return PassengerCategoryEntity(
      id: model.id,
      categoryName: model.categoryName,
      image: '${ApiEndPoint.imageUrl}${model.image}',
      basePrice: model.basePrice,
      ratePerKm: model.ratePerKm,
      ratePerHour: model.ratePerHour,
      status: model.status,
      isActive: model.isActive,
      isDeleted: model.isDeleted,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static List<PassengerCategoryEntity> fromModelList(
    List<PassengerCategoryModel> models,
  ) {
    return models.map((model) => fromModel(model)).toList();
  }
}
