import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/datasources/remote/driver/driver_auth_remote_data_source.dart';
import 'package:cabwire/data/mappers/signin_response_mapper.dart';
import 'package:cabwire/data/mappers/signup_response_mapper.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';
import 'package:cabwire/domain/repositories/driver/driver_auth_repository.dart';
import 'package:fpdart/fpdart.dart' show left, right;

class DriverAuthRepositoryImpl implements DriverAuthRepository {
  final DriverAuthRemoteDataSource _authDataSource;

  DriverAuthRepositoryImpl(this._authDataSource);

  @override
  Future<Result<SignupResponseEntity>> signUp(UserModel user) async {
    final result = await _authDataSource.signUp(user);
    return result.fold((l) => left(l), (r) => right(r.toEntity()));
  }

  @override
  Future<Result<SigninResponseEntity>> signIn(
    String email,
    String password,
  ) async {
    final result = await _authDataSource.signIn(email, password);
    if (result.isRight()) {
      final profileResult = await _authDataSource.getDriverProfile(
        'Bearer ${result.fold((l) => l, (r) => r.data?.token ?? '')}',
      );
      appLog('profileResult: $profileResult');
      if (profileResult.isRight()) {
        final profileData = profileResult.fold((l) => l, (r) => r);
        final profileModel = profileData as DriverProfileModel;
        await LocalStorage.saveDriverProfile(profileModel);
      }
      return result.fold((l) => left(l), (r) => right(r.toEntity()));
    }
    return result.fold((l) => left(l), (r) => right(r.toEntity()));
  }

  @override
  Future<Result<Map<String, dynamic>>> verifyEmail(
    String email,
    String otp,
  ) async {
    final result = await _authDataSource.verifyEmail(email, otp);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> resetCode(String email) async {
    final result = await _authDataSource.resetCode(email);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> forgotPassword(String email) async {
    final result = await _authDataSource.forgotPassword(email);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> updateDriverProfile(
    String? name,
    String? contact,
    String? profileImage,
  ) async {
    final result = await _authDataSource.updateDriverProfile(
      name,
      contact,
      profileImage,
      LocalStorage.token,
    );

    // If update is successful, save to local storage
    if (result.isRight()) {
      // If we have a current profile, merge with the updates
      final currentProfile = await LocalStorage.getDriverProfile();
      if (currentProfile != null) {
        // Create a merged profile with updated fields
        final updatedProfile = DriverProfileModel(
          id: currentProfile.id,
          name: name ?? currentProfile.name,
          role: currentProfile.role,
          email: currentProfile.email,
          image: profileImage ?? currentProfile.image,
          status: currentProfile.status,
          verified: currentProfile.verified,
          isOnline: currentProfile.isOnline,
          isDeleted: currentProfile.isDeleted,
          geoLocation: currentProfile.geoLocation,
          stripeAccountId: currentProfile.stripeAccountId,
          createdAt: currentProfile.createdAt,
          updatedAt: DateTime.now(),
          contact: contact ?? currentProfile.contact,
          gender: currentProfile.gender,
          dateOfBirth: currentProfile.dateOfBirth,
          driverLicense: currentProfile.driverLicense,
          driverVehicles: currentProfile.driverVehicles,
          driverTotalEarn: currentProfile.driverTotalEarn,
          totalTrip: currentProfile.totalTrip,
          action: currentProfile.action,
          adminRevenue: currentProfile.adminRevenue,
          totalAmountSpend: currentProfile.totalAmountSpend,
        );

        await LocalStorage.saveDriverProfile(updatedProfile);
        appLog(
          'Updated driver profile saved to local storage',
          source: "DriverAuthRepository",
        );
      } else {
        // If no current profile, just save what we have
        await LocalStorage.saveDriverProfile(
          DriverProfileModel(name: name, contact: contact, image: profileImage),
        );
        appLog(
          'New driver profile saved to local storage',
          source: "DriverAuthRepository",
        );
      }
    }

    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  ) async {
    final result = await _authDataSource.resetPasswordWithToken(
      token,
      newpassword,
      confirmPassword,
    );
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> deleteMyAccount(String password) async {
    final token = LocalStorage.token;
    final result = await _authDataSource.deleteMyAccount(token, password);
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> confirmDriverInformation({
    required String name,
    required String contact,
    required String gender,
    required String dateOfBirth,
    required String email,
    String? profileImage,
  }) async {
    final result = await _authDataSource.confirmDriverInformation(
      name: name,
      contact: contact,
      gender: gender,
      dateOfBirth: dateOfBirth,
      profileImage: profileImage,
      email: email,
    );
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> submitDriverVehicleInformation({
    required String vehiclesMake,
    required String vehiclesModel,
    required String vehiclesYear,
    required String vehiclesRegistrationNumber,
    required String vehiclesInsuranceNumber,
    required String vehiclesCategory,
    required String email,
    String? vehicleImage,
  }) async {
    final result = await _authDataSource.submitDriverVehicleInformation(
      vehiclesMake: vehiclesMake,
      vehiclesModel: vehiclesModel,
      vehiclesYear: vehiclesYear,
      vehiclesRegistrationNumber: vehiclesRegistrationNumber,
      vehiclesInsuranceNumber: vehiclesInsuranceNumber,
      vehiclesCategory: vehiclesCategory,
      vehicleImage: vehicleImage,
      email: email,
    );
    return result.fold((l) => left(l), (r) => right(r));
  }

  @override
  Future<Result<String>> submitDriverLicenseInformation({
    required String licenseNumber,
    required String licenseExpiryDate,
    required String email,
    String? licenseImage,
  }) async {
    final result = await _authDataSource.submitDriverLicenseInformation(
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
      licenseImage: licenseImage,
      email: email,
    );
    return result.fold((l) => left(l), (r) => right(r));
  }
}
