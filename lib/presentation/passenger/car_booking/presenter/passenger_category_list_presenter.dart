import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';
import 'package:cabwire/domain/usecases/passenger/get_passenger_categories_usecase.dart';
import 'passenger_category_list_ui_state.dart';

class PassengerCategoryListPresenter
    extends BasePresenter<PassengerCategoryListUiState> {
  final GetPassengerCategoriesUseCase _getPassengerCategoriesUseCase;
  final Obs<PassengerCategoryListUiState> uiState =
      Obs<PassengerCategoryListUiState>(PassengerCategoryListUiState.empty());
  PassengerCategoryListUiState get currentUiState => uiState.value;

  PassengerCategoryListPresenter(this._getPassengerCategoriesUseCase);

  @override
  void onInit() {
    super.onInit();
    loadPassengerCategories();
  }

  Future<void> loadPassengerCategories() async {
    try {
      await toggleLoading(loading: true);
      final result = await _getPassengerCategoriesUseCase();

      result.fold(
        (failure) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            error: failure.message,
          );
          addUserMessage(failure.message);
        },
        (categories) {
          uiState.value = currentUiState.copyWith(
            isLoading: false,
            categories: categories,
            error: null,
          );
        },
      );
    } catch (e) {
      uiState.value = currentUiState.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      addUserMessage(e.toString());
    }
  }

  void selectCategory(PassengerCategoryEntity category) {
    uiState.value = currentUiState.copyWith(selectedCategory: category);
  }

  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
