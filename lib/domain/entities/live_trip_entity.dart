class RidePathHistoryEntity {
  final bool success;
  final String message;
  final RidePathDataEntity? data;

  RidePathHistoryEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}

class RidePathDataEntity {
  final String id;
  final List<PathHistoryEntity> pathHistory;

  RidePathDataEntity({required this.id, required this.pathHistory});
}

class PathHistoryEntity {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String id;

  PathHistoryEntity({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.id,
  });
}
