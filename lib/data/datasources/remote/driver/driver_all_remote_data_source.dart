import 'dart:io';

import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/update_status_request_model.dart';
import 'package:cabwire/data/services/api/api_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

abstract class DriverAllRemoteDataSource {
  Future<Result<void>> updateOnlineStatus(
    String email,
    UpdateStatusRequestModel request,
  );
  Future<Result<void>> updateProfilePhoto(String email, String photo);
}

class DriverAllRemoteDataSourceImpl implements DriverAllRemoteDataSource {
  final apiService = ApiServiceImpl.instance;

  @override
  Future<Result<void>> updateOnlineStatus(
    String email,
    UpdateStatusRequestModel request,
  ) async {
    try {
      final result = await apiService.patch(
        ApiEndPoint.updateOnlineStatus + email,
        body: request.toJson(),
      );

      return result.fold((l) => left(l.message), (r) => right(null));
    } catch (e) {
      return left(e.toString());
    }
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
          final result = await apiService.patch(
            ApiEndPoint.updateProfileByEmail + email,
            body: formData,
          );
          appLog("++++++++++++++++++    $result    ++++++++++++++++++++");
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
                final verifyPath = LocalStorage.preferences?.getString(
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
              final updatedProfile = DriverProfileModel.fromJson(profileData);
              appLog(
                "📸 Creating driver model with image: ${updatedProfile.image}",
                source: "updateProfilePhoto",
              );

              // Force clear old profile data first
              await LocalStorage.removeDriverProfile();

              // Force update the local storage with complete profile
              await LocalStorage.saveDriverProfile(updatedProfile);

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
              // Couldn't find profile data in response, log the error
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
