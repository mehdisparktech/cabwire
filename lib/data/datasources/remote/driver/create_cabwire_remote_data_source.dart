import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/driver/create_cabwire_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:fpdart/fpdart.dart';

abstract class CreateCabwireRemoteDataSource {
  Future<Result<CabwireResponseModel>> createCabwire(
    CabwireRequestModel request,
  );
}

class CreateCabwireRemoteDataSourceImpl
    implements CreateCabwireRemoteDataSource {
  final ApiServiceImpl apiService = ApiServiceImpl.instance;

  @override
  Future<Result<CabwireResponseModel>> createCabwire(
    CabwireRequestModel request,
  ) async {
    final token = LocalStorage.token;
    final response = await apiService.post(
      ApiEndPoint.createCabwire,
      body: request.toJson(),
      header: {'Authorization': 'Bearer $token'},
    );

    return response.fold((l) => left(l.message), (r) {
      try {
        final responseModel = CabwireResponseModel.fromJson(r.data);
        return right(responseModel);
      } catch (e) {
        return left('Failed to parse response: $e');
      }
    });
  }
}
