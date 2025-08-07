import 'dart:io';

import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/passenger/create_passenger_model.dart';
import 'package:cabwire/data/models/passenger/passenger_response_model.dart';
import 'package:cabwire/data/models/profile_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

abstract class PassengerRemoteDataSource {
  /// Creates a new passenger
  ///
  /// Throws an [Exception] if an error occurs
  Future<PassengerResponseModel> createPassenger(CreatePassengerModel model);

  Future<Result<void>> updateProfilePhoto(String email, String photo);
}

class PassengerRemoteDataSourceImpl implements PassengerRemoteDataSource {
  final ApiService _apiService;

  PassengerRemoteDataSourceImpl(this._apiService);

  @override
  Future<PassengerResponseModel> createPassenger(
    CreatePassengerModel model,
  ) async {
    final response = await _apiService.post(
      ApiEndPoint.passengers,
      body: model.toJson(),
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (success) => PassengerResponseModel.fromJson(success.data),
    );
  }

  @override
  Future<Result<void>> updateProfilePhoto(String email, String photo) async {
    try {
      if (photo.isNotEmpty) {
        final file = File(photo);
        if (await file.exists()) {
          String fileName = file.path.split('/').last;
          var mimeType = lookupMimeType(file.path);
          final formData = FormData();
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType.parse(mimeType!),
              ),
            ),
          );
          final result = await _apiService.patch(
            ApiEndPoint.updateProfileByEmail + email,
            body: formData,
          );
          if (result.isRight()) {
            // Extract the data from successful API response - the actual profile is in the 'data' field
            final apiResponse = result.fold((l) => {}, (r) => r.data);

            appLog(
              "Raw API response: $apiResponse",
              source: "updateProfilePhoto",
            );

            // In the API response, the actual profile data is in the 'data' field
            final profileData =
                apiResponse is Map<String, dynamic>
                    ? apiResponse['data']
                    : null;

            if (profileData is Map<String, dynamic>) {
              // Found the profile data, directly update the image in LocalStorage first for immediate effect
              if (profileData.containsKey('image')) {
                final imagePath = profileData['image'];
                appLog(
                  "📸 Image path from API: $imagePath",
                  source: "updateProfilePhoto",
                );

                // CRITICAL STEP: Update both LocalStorage variables and SharedPreferences directly
                LocalStorage.myImage = imagePath;
                await LocalStorage.setString('myImage', imagePath);

                // Verify immediate update
                final verifyPath = await LocalStorage.preferences?.getString(
                  'myImage',
                );
                appLog(
                  "📸 Immediate verification - myImage: $verifyPath",
                  source: "updateProfilePhoto",
                );
              } else {
                appLog(
                  "⚠️ No image field found in profileData!",
                  source: "updateProfilePhoto",
                );
              }

              // Create and save the complete profile model
              final updatedProfile = ProfileModel.fromJson(profileData);
              appLog(
                "📸 Creating passenger model with image: ${updatedProfile.image}",
                source: "updateProfilePhoto",
              );

              // Force clear old profile data first
              await LocalStorage.removePassengerProfile();

              // Force update the local storage with complete profile
              await LocalStorage.savePassengerProfile(updatedProfile);

              // Triple-check that image was saved correctly
              final finalCheck = LocalStorage.preferences?.getString('myImage');
              appLog(
                "📸 Final image verification - Static: ${LocalStorage.myImage}, Prefs: $finalCheck",
                source: "updateProfilePhoto",
              );

              // Make one final direct set to be absolutely sure
              if (profileData['image'] != null) {
                LocalStorage.myImage = profileData['image'];
                await LocalStorage.setString('myImage', profileData['image']);
              }
            } else {
              appLog(
                "ERROR: Couldn't extract profile data from response",
                source: "updateProfilePhoto",
              );
            }
            return right(null);
          }

          return left(result.fold((l) => l.message, (r) => r.data['message']));
        }
      }

      return left('Photo is empty');
    } catch (e) {
      return left(e.toString());
    }
  }
}
