import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/data/models/user_model.dart';
import 'package:cabwire/domain/entities/signin_response_entity.dart';
import 'package:cabwire/domain/entities/signup_response_entity.dart';

abstract class DriverAuthRepository {
  Future<Result<SignupResponseEntity>> signUp(UserModel user);
  Future<Result<SigninResponseEntity>> signIn(String email, String password);
  Future<Result<Map<String, dynamic>>> verifyEmail(String email, String otp);
  Future<Result<String>> resetCode(String email);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> updateDriverProfile(
    String? name,
    String? contact,
    String? profileImage,
  );
  Future<Result<String>> resetPasswordWithToken(
    String token,
    String newpassword,
    String confirmPassword,
  );
  Future<Result<String>> deleteMyAccount(String password);

  // New separate API methods for driver registration
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
    String? licenseBackImage,
  });
}
