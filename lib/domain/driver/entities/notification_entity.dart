import 'package:cabwire/core/base/base_entity.dart';

class NotificationEntity extends BaseEntity {
  final String title;
  final String description;
  final String image;
  final String time;

  const NotificationEntity({
    required this.title,
    required this.description,
    required this.image,
    required this.time,
  });

  @override
  List<Object?> get props => [title, description, image, time];
}
