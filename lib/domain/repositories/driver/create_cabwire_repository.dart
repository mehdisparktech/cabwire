import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/domain/entities/driver/create_cabwire_entity.dart';

abstract class CreateCabwireRepository {
  Future<Result<CabwireResponseEntity>> createCabwire(
    CabwireRequestEntity request,
  );
}
