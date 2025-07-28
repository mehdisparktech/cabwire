import 'package:equatable/equatable.dart';

class PassengerServiceEntity extends Equatable {
  final String id;
  final String serviceName;
  final String image;
  final double baseFare;
  final String status;
  final String createdAt;
  final String updatedAt;

  const PassengerServiceEntity({
    required this.id,
    required this.serviceName,
    required this.image,
    required this.baseFare,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    serviceName,
    image,
    baseFare,
    status,
    createdAt,
    updatedAt,
  ];
}
