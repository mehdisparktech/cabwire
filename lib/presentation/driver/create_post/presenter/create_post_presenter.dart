import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'create_post_ui_state.dart';

class CreatePostPresenter extends BasePresenter<CreatePostUiState> {
  final Obs<CreatePostUiState> uiState = Obs<CreatePostUiState>(CreatePostUiState.empty());
  CreatePostUiState get currentUiState => uiState.value;

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
