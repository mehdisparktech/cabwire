import 'package:cabwire/core/utility/trial_utility.dart';
import 'package:cabwire/data/driver/services/backend_as_a_service.dart';

abstract class InfoRemoteDataSource {
  Future<void> getPromotionalMessage({
    required void Function(String) onPromotionalMessage,
  });
}

class InfoRemoteDataSourceImpl implements InfoRemoteDataSource {
  InfoRemoteDataSourceImpl(this._backendAsAService);
  final BackendAsAService _backendAsAService;

  @override
  Future<void> getPromotionalMessage({
    required void Function(String) onPromotionalMessage,
  }) async {
    _backendAsAService.getRemoteNotice(
      onNotification: (Map<String, Object?> map) async {
        await catchFutureOrVoid(() async {
          final Map<String, Object?> remoteNotice = map.map(MapEntry.new);
          final String? promotionalMessage =
              remoteNotice['promotional_message'] as String?;
          if (promotionalMessage != null) {
            onPromotionalMessage(promotionalMessage);
          }
        });
      },
    );
  }
}
