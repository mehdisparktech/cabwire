import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/signin_response_model.dart';
import 'package:cabwire/data/models/signup_response_model.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_keys.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:mime/mime.dart';

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
    String? vehicleFrontImage,
    String? vehicleBackImage,
  });

  Future<Result<String>> submitDriverLicenseInformation({
    required String licenseNumber,
    required String licenseExpiryDate,
    required String email,
    String? licenseImage,
    String? licenseBackImage,
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

      appLog(profileImage != null);

      // Add image if provided
      if (profileImage != null) {
        final fileName = profileImage.split('/').last;
        var mimeType = lookupMimeType(fileName);
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              profileImage,
              filename: fileName,
              contentType: MediaType.parse(mimeType!),
            ),
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
    String? vehicleFrontImage,
    String? vehicleBackImage,
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

      appLog(vehicleFrontImage != null || vehicleBackImage != null);

      // Add vehicle front image if provided
      if (vehicleFrontImage != null) {
        final fileName = vehicleFrontImage.split('/').last;
        var mimeType = lookupMimeType(fileName);
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              vehicleFrontImage,
              filename: fileName,
              contentType: MediaType.parse(mimeType!),
            ),
          ),
        );
      }

      // Add vehicle back image if provided
      if (vehicleBackImage != null) {
        final fileName = vehicleBackImage.split('/').last;
        var mimeType = lookupMimeType(fileName);
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              vehicleBackImage,
              filename: fileName,
              contentType: MediaType.parse(mimeType!),
            ),
          ),
        );
      }

      final result = await apiService.patchFormData(
        ApiEndPoint.driverVehicleInformation + email,
        formData: formData,
        header: {'Authorization': 'Bearer $token'},
      );

      result.fold((_) => null, (r) {
        try {
          final List<dynamic>? uploads =
              r.data['data']?['driverVehicles']?['vehiclesPicture']
                  as List<dynamic>?;
          if (uploads != null && uploads.isNotEmpty) {
            final String front = uploads.elementAt(0)?.toString() ?? '';
            LocalStorage.setString(LocalStorageKeys.vehicleFrontImage, front);
            LocalStorage.vehicleFrontImage = front;
            if (uploads.length > 1) {
              final String back = uploads.elementAt(1)?.toString() ?? '';
              LocalStorage.setString(LocalStorageKeys.vehicleBackImage, back);
              LocalStorage.vehicleBackImage = back;
            }
          }
        } catch (_) {}
      });

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
    String? licenseBackImage,
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

      appLog(licenseImage != null);

      // Add license image if provided
      if (licenseImage != null) {
        final fileName = licenseImage.split('/').last;
        var mimeType = lookupMimeType(fileName);
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              licenseImage,
              filename: fileName,
              contentType: MediaType.parse(mimeType!),
            ),
          ),
        );
      }

      // Add license back image if provided
      if (licenseBackImage != null) {
        final fileName = licenseBackImage.split('/').last;
        var mimeType = lookupMimeType(fileName);
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              licenseBackImage,
              filename: fileName,
              contentType: MediaType.parse(mimeType!),
            ),
          ),
        );
      }

      final result = await apiService.patchFormData(
        ApiEndPoint.driverLicensInformation + email,
        formData: formData,
        header: {'Authorization': 'Bearer $token'},
      );

      // Save returned license image paths locally only on success
      result.fold((_) => null, (r) {
        try {
          final List<dynamic>? uploads =
              r.data['data']?['driverLicense']?['uploadDriversLicense']
                  as List<dynamic>?;
          if (uploads != null && uploads.isNotEmpty) {
            final String front = uploads.elementAt(0)?.toString() ?? '';
            LocalStorage.setString(LocalStorageKeys.licenseFrontImage, front);
            LocalStorage.licenseFrontImage = front;
            if (uploads.length > 1) {
              final String back = uploads.elementAt(1)?.toString() ?? '';
              LocalStorage.setString(LocalStorageKeys.licenseBackImage, back);
              LocalStorage.licenseBackImage = back;
            }
          }
        } catch (_) {}
      });

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
