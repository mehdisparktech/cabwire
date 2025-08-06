import 'dart:io';

import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
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
          if (result.isRight()) {
            LocalStorage.saveDriverProfile(
              DriverProfileModel.fromJson(
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
