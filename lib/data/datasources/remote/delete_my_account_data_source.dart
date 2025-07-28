import 'package:cabwire/core/base/result.dart';
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/api_service.dart';
import 'package:fpdart/fpdart.dart';

abstract class DeleteMyAccountDataSource {
  Future<Result<String>> deleteMyAccount(String password);
}

class DeleteMyAccountDataSourceImpl implements DeleteMyAccountDataSource {
  final ApiService _apiService;

  DeleteMyAccountDataSourceImpl(this._apiService);

  @override
  Future<Result<String>> deleteMyAccount(String password) async {
    final result = await _apiService.delete(
      ApiEndPoint.deleteMyAccount,
      header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      body: {'password': password},
    );
    appLog("DeleteMyAccountDataSourceImpl ${result.fold((l) => l, (r) => r)}");
    return result.fold(
      (l) => left(l.message.toString()),
      (r) => right(r.data['message'] as String),
    );
  }
}
