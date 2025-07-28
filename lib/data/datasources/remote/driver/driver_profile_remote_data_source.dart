import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/data/models/contact_us_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:fpdart/fpdart.dart';

abstract class DriverProfileRemoteDataSource {
  Future<Result<ContactUsResponseModel>> submitContactForm(
    ContactUsModel contactUs,
  );
}

class DriverProfileRemoteDataSourceImpl
    implements DriverProfileRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  @override
  Future<Result<ContactUsResponseModel>> submitContactForm(
    ContactUsModel contactUs,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.contact,
        body: contactUs.toJson(),
        header: {
          "Authorization": LocalStorage.token,
          "Content-Type": "application/json",
        },
      );

      return result.fold((failure) => left(failure.message), (success) {
        final response = ContactUsResponseModel.fromJson(success.data);
        return right(response);
      });
    } catch (e) {
      return left(e.toString());
    }
  }
}
