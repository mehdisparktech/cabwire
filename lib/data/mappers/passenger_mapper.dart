import 'package:cabwire/data/models/passenger/passenger_response_model.dart';
import 'package:cabwire/domain/entities/passenger/passenger_entity.dart';

/// Extension methods for PassengerDataModel to convert to/from PassengerEntity
extension PassengerDataModelMapper on PassengerDataModel {
  /// Convert model to entity
  PassengerEntity toEntity() {
    return PassengerEntity(
      id: id,
      name: name,
      role: role,
      email: email,
      password: password,
      image: image,
      status: status,
      verified: verified,
      location:
          location != null
              ? LocationEntity(
                lat: location!.lat,
                lng: location!.lng,
                address: location!.address,
              )
              : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension methods for PassengerEntity to convert to PassengerDataModel
extension PassengerEntityMapper on PassengerEntity {
  /// Convert entity to model
  PassengerDataModel toModel() {
    return PassengerDataModel(
      id: id,
      name: name,
      role: role,
      email: email,
      password: password ?? '',
      image: image,
      status: status,
      verified: verified,
      location:
          location != null
              ? LocationModel(
                lat: location!.lat,
                lng: location!.lng,
                address: location!.address,
              )
              : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension methods for LocationModel to convert to/from LocationEntity
extension LocationModelMapper on LocationModel {
  /// Convert model to entity
  LocationEntity toEntity() {
    return LocationEntity(lat: lat, lng: lng, address: address);
  }
}

/// Extension methods for LocationEntity to convert to LocationModel
extension LocationEntityMapper on LocationEntity {
  /// Convert entity to model
  LocationModel toModel() {
    return LocationModel(lat: lat, lng: lng, address: address);
  }
}
