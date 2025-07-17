import 'package:cabwire/core/base/base_entity.dart';

class LocationHistoryEntity extends BaseEntity {
  final double lat;
  final double lng;
  final String address;

  const LocationHistoryEntity({
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  List<Object?> get props => [lat, lng, address];
}
