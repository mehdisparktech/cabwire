import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/signin_response_model.dart';
import 'package:cabwire/data/models/signup_response_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:convert';

abstract class DriverAuthRemoteDataSource {
  Future<Result<SignupResponseModel>> signUp(UserModel user);
  Future<Result<SigninResponseModel>> signIn(String email, String password);
  Future<Result<Map<String, dynamic>>> verifyEmail(String email, String otp);
  Future<Result<String>> resetCode(String email);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> updateDriverProfile(
    String? name,
    String? contact,
    String? profileImage,
    String token,
  );
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  );
  Future<Result<DriverProfileModel>> getDriverProfile(String token);
  Future<Result<String>> deleteMyAccount(String token, String password);

  // New separate API methods for driver registration with FormData
  Future<Result<String>> confirmDriverInformation({
    required String name,
    required String contact,
    required String gender,
    required String dateOfBirth,
    required String email,
    String? profileImage,
  });

  Future<Result<String>> submitDriverVehicleInformation({
    required String vehiclesMake,
    required String vehiclesModel,
    required String vehiclesYear,
    required String vehiclesRegistrationNumber,
    required String vehiclesInsuranceNumber,
    required String vehiclesCategory,
    required String email,
    String? vehicleImage,
  });

  Future<Result<String>> submitDriverLicenseInformation({
    required String licenseNumber,
    required String licenseExpiryDate,
    required String email,
    String? licenseImage,
  });
}

class DriverAuthRemoteDataSourceImpl extends DriverAuthRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  // Sign Up
  @override
  Future<Result<SignupResponseModel>> signUp(UserModel user) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.signUp,
        body: user.toJson(),
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(SignupResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // Sign In
  @override
  Future<Result<SigninResponseModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.signIn,
        body: {'email': email, 'password': password},
      );
      appLog("signIn result: ${result.fold((l) => l.message, (r) => r.data)}");
      return result.fold(
        (l) => left(l.message),
        (r) => right(SigninResponseModel.fromJson(r.data)),
      );
    } catch (e) {
      appLog("signIn error: ${e.toString()}");
      return left(e.toString());
    }
  }

  // Verify Email
  @override
  Future<Result<Map<String, dynamic>>> verifyEmail(
    String email,
    String otp,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.verifyEmail,
        body: {'email': email, 'oneTimeCode': int.parse(otp)},
      );
      return result.fold((l) => left(l.message), (r) => right(r.data));
    } catch (e) {
      return left(e.toString());
    }
  }

  // reset code
  @override
  Future<Result<String>> resetCode(String email) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.resetCode,
        body: {'email': email},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // forgot password
  @override
  Future<Result<String>> forgotPassword(String email) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.forgotPassword,
        body: {'email': email},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // update driver profile
  @override
  Future<Result<String>> updateDriverProfile(
    String? name,
    String? contact,
    String? profileImage,
    String token,
  ) async {
    try {
      final result = await apiService.patch(
        ApiEndPoint.updateProfile,
        body: {'name': name, 'contact': contact, 'profileImage': profileImage},
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // reset password with token
  @override
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  ) async {
    try {
      final result = await apiService.post(
        ApiEndPoint.resetPasswordWithToken,
        header: {'Authorization': token, 'Content-Type': 'application/json'},
        body: {'newPassword': newpassword, 'confirmPassword': confirmPassword},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // get driver profile
  @override
  Future<Result<DriverProfileModel>> getDriverProfile(String token) async {
    try {
      final result = await apiService.get(
        ApiEndPoint.getProfile,
        header: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      appLog(
        'getDriverProfile result: ${result.fold((l) => l.message, (r) => r.data)}',
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(DriverProfileModel.fromJson(r.data['data'])),
      );
    } catch (e) {
      appLog('getDriverProfile error: ${e.toString()}');
      return left(e.toString());
    }
  }

  // delete my account
  @override
  Future<Result<String>> deleteMyAccount(String token, String password) async {
    try {
      final result = await apiService.delete(
        ApiEndPoint.deleteMyAccount,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: {'password': password},
      );
      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message']),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  // Confirm driver information with FormData
  @override
  Future<Result<String>> confirmDriverInformation({
    required String name,
    required String contact,
    required String gender,
    required String dateOfBirth,
    required String email,
    String? profileImage,
  }) async {
    try {
      final token = LocalStorage.token;

      // Prepare JSON data
      final jsonData = {
        'name': name,
        'contact': contact,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
      };

      // Create FormData
      final formData = FormData.fromMap({'data': jsonEncode(jsonData)});

      // Add image if provided
      if (profileImage != null) {
        final fileName = profileImage.split('/').last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(profileImage, filename: fileName),
          ),
        );
      }

      appLog("DataSource ========>>>   $email");

      final result = await apiService.patchFormData(
        ApiEndPoint.driverConfirmInformation + email,
        formData: formData,
        header: {'Authorization': 'Bearer $token'},
      );

      return result.fold(
        (l) => left(l.message),
        (r) => right(r.data['message'] ?? 'Information confirmed successfully'),
      );
    } catch (e) {
      appLog('confirmDriverInformation error: ${e.toString()}');
      return left(e.toString());
    }
  }

  // Submit driver vehicle information with FormData
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
    try {
      final token = LocalStorage.token;

      DateTime dateFromYear = DateTime(int.parse(vehiclesYear));

      // এটিকে ISO 8601 ফরম্যাটের স্ট্রিং-এ রূপান্তর করুন
      String formattedDateString = dateFromYear.toIso8601String();

      // Prepare JSON data
      final jsonData = {
        "driverVehicles": {
          "vehiclesMake": vehiclesMake,
          "vehiclesModel": vehiclesModel,
          "vehiclesYear": formattedDateString,
          "vehiclesRegistrationNumber": vehiclesRegistrationNumber,
          "vehiclesInsuranceNumber": vehiclesInsuranceNumber,
          "vehiclesCategory": vehiclesCategory,
        },
      };

      // Create FormData
      final formData = FormData.fromMap({'data': jsonEncode(jsonData)});

      // Add vehicle image if provided
      if (vehicleImage != null) {
        final fileName = vehicleImage.split('/').last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(vehicleImage, filename: fileName),
          ),
        );
      }

      final result = await apiService.patchFormData(
        ApiEndPoint.driverVehicleInformation + email,
        formData: formData,
        header: {'Authorization': 'Bearer $token'},
      );

      return result.fold(
        (l) => left(l.message),
        (r) => right(
          r.data['message'] ?? 'Vehicle information submitted successfully',
        ),
      );
    } catch (e) {
      appLog('submitDriverVehicleInformation error: ${e.toString()}');
      return left(e.toString());
    }
  }

  @override
  Future<Result<String>> submitDriverLicenseInformation({
    required String licenseNumber,
    required String licenseExpiryDate,
    required String email,
    String? licenseImage,
  }) async {
    try {
      final token = LocalStorage.token;

      // Prepare JSON data
      final jsonData = {
        'driverLicense': {
          'licenseNumber':
              licenseNumber, // licenseNumber ভেরিয়েবল থেকে মান আসবে
          'licenseExpiryDate':
              licenseExpiryDate, // licenseExpiryDate ভেরিয়েবল থেকে মান আসবে
        },
      };

      // Create FormData
      final formData = FormData.fromMap({'data': jsonEncode(jsonData)});

      // Add license image if provided
      if (licenseImage != null) {
        final fileName = licenseImage.split('/').last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(licenseImage, filename: fileName),
          ),
        );
      }

      final result = await apiService.patchFormData(
        ApiEndPoint.driverLicensInformation + email,
        formData: formData,
        header: {'Authorization': 'Bearer $token'},
      );

      return result.fold(
        (l) => left(l.message),
        (r) => right(
          r.data['message'] ?? 'Vehicle information submitted successfully',
        ),
      );
    } catch (e) {
      appLog('submitDriverVehicleInformation error: ${e.toString()}');
      return left(e.toString());
    }
  }
}
