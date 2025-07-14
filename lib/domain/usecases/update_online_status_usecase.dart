import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/repositories/driver/driver_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateStatusParams extends Equatable {
  final String email;
  final bool isOnline;

  const UpdateStatusParams({required this.email, required this.isOnline});

  @override
  List<Object?> get props => [email, isOnline];
}

class UpdateOnlineStatusUseCase {
  final DriverRepository repository;

  UpdateOnlineStatusUseCase(this.repository);

  Future<Result<void>> call(UpdateStatusParams params) {
    return repository.updateOnlineStatus(params.email, params.isOnline);
  }
}
