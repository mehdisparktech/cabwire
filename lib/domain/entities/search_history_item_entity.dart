import 'package:cabwire/core/base/base_entity.dart';

class SearchHistoryItem extends BaseEntity {
  final String location;
  final String distance;

  const SearchHistoryItem({required this.location, required this.distance});

  @override
  List<Object?> get props => [location, distance];
}
