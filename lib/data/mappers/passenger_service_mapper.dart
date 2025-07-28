import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/passenger/passenger_service_list_response_model.dart';
import 'package:cabwire/domain/entities/passenger/passenger_service_entity.dart';

class PassengerServiceMapper {
  static PassengerServiceEntity fromModel(PassengerServiceModel model) {
    return PassengerServiceEntity(
      id: model.id,
      serviceName: model.serviceName,
      image: '${ApiEndPoint.imageUrl}${model.image}',
      baseFare: model.baseFare,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static List<PassengerServiceEntity> fromModelList(
    List<PassengerServiceModel> models,
  ) {
    return models.map((model) => fromModel(model)).toList();
  }
}
