import 'package:fpdart/fpdart.dart';
import 'package:cabwire/domain/repositories/passenger_repository.dart';

class CreatePassengerUseCase {
  final PassengerRepository _repository;

  CreatePassengerUseCase(this._repository);

  Future<Either<String, void>> execute(CreatePassengerParams params) async {
    return await _repository.createPassenger(
      name: params.name,
      role: params.role,
      email: params.email,
      password: params.password,
    );
  }
}

class CreatePassengerParams {
  final String name;
  final String role;
  final String email;
  final String password;

  CreatePassengerParams({
    required this.name,
    required this.role,
    required this.email,
    required this.password,
  });
}
