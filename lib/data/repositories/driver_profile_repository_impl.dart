import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/datasources/remote/driver_profile_remote_data_source.dart';
import 'package:cabwire/data/models/contact_us_model.dart';
import 'package:cabwire/domain/entities/contact_us_entity.dart';
import 'package:cabwire/domain/repositories/driver_profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class DriverProfileRepositoryImpl implements DriverProfileRepository {
  final DriverProfileRemoteDataSource _remoteDataSource;

  DriverProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void>> submitContactForm(ContactUsEntity contactUs) async {
    try {
      // Convert entity to model
      final contactUsModel = ContactUsModel(
        fullName: contactUs.fullName,
        email: contactUs.email,
        phone: contactUs.phone,
        subject: contactUs.subject,
        description: contactUs.description,
        status: contactUs.status,
      );

      // Call the remote data source
      final result = await _remoteDataSource.submitContactForm(contactUsModel);

      // Return the result
      return result.fold((error) => left(error), (success) => right(null));
    } catch (e) {
      return left(e.toString());
    }
  }
}
