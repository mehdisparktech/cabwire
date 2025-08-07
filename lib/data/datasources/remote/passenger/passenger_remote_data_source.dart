import 'dart:io';

import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
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
            LocalStorage.savePassengerProfile(
              ProfileModel.fromJson(
                result.fold((l) => {}, (r) => {'image': r.data['image']}),
              ),
            );
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
