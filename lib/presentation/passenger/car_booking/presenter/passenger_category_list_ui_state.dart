import 'package:cabwire/core/base/base_ui_state.dart';
import 'package:cabwire/domain/entities/passenger/passenger_category_entity.dart';

class PassengerCategoryListUiState extends BaseUiState {
  final List<PassengerCategoryEntity> categories;
  final String? error;
  final PassengerCategoryEntity? selectedCategory;

  const PassengerCategoryListUiState({
    required super.isLoading,
    required super.userMessage,
    required this.categories,
    this.error,
    this.selectedCategory,
  });

  factory PassengerCategoryListUiState.empty() {
    return const PassengerCategoryListUiState(
      userMessage: null,
      isLoading: true,
      categories: [],
      error: null,
      selectedCategory: null,
    );
  }

  @override
  List<Object?> get props => [
    userMessage,
    isLoading,
    categories,
    error,
    selectedCategory,
  ];

  PassengerCategoryListUiState copyWith({
    String? userMessage,
    bool? isLoading,
    List<PassengerCategoryEntity>? categories,
    String? error,
    PassengerCategoryEntity? selectedCategory,
  }) {
    return PassengerCategoryListUiState(
      isLoading: isLoading ?? this.isLoading,
      userMessage: userMessage ?? this.userMessage,
      categories: categories ?? this.categories,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
