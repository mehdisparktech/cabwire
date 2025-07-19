import 'package:cabwire/core/base/base_presenter.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/create_ride_model.dart';
import 'package:cabwire/data/models/driver/driver_profile_model.dart';
import 'package:cabwire/data/models/ride_data_model.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/entities/driver/create_cabwire_entity.dart';
import 'package:cabwire/domain/usecases/driver/create_cabwire_usecase.dart';
import 'package:cabwire/presentation/driver/create_post/ui/screens/create_post_details_page.dart';
import 'package:get/get.dart';
import 'create_post_ui_state.dart';

class CreatePostPresenter extends BasePresenter<CreatePostUiState> {
  final CreateCabwireUsecase createCabwireUsecase;

  CreatePostPresenter(this.createCabwireUsecase);

  final Obs<CreatePostUiState> uiState = Obs<CreatePostUiState>(
    CreatePostUiState.empty(),
  );
  CreatePostUiState get currentUiState => uiState.value;

  @override
  void onInit() {
    super.onInit();
    loadDriverProfile();
  }

  Future<void> loadDriverProfile() async {
    try {
      logError('Static LocalStorage.myName: ${LocalStorage.myName}');
      final DriverProfileModel? profile = await LocalStorage.getDriverProfile();
      if (profile != null) {
        logDebug('Driver profile from LocalStorage: ${profile.toJson()}');

        // Create a new RideData object with the updated driver name
        final updatedRideData =
            currentUiState.rideData != null
                ? RideData(
                  driverName: profile.name ?? '',
                  vehicleNumber: currentUiState.rideData!.vehicleNumber,
                  vehicleModel: currentUiState.rideData!.vehicleModel,
                  pickupLocation: currentUiState.rideData!.pickupLocation,
                  dropoffLocation: currentUiState.rideData!.dropoffLocation,
                  dropoffLocation2: currentUiState.rideData!.dropoffLocation2,
                  statistics: currentUiState.rideData!.statistics,
                  totalAmount: currentUiState.rideData!.totalAmount,
                )
                : null;

        // Create a completely new state object
        final newState = CreatePostUiState(
          isLoading: currentUiState.isLoading,
          userMessage: currentUiState.userMessage,
          rideData: updatedRideData,
          createRideModel: currentUiState.createRideModel,
          totalAmount: currentUiState.totalAmount,
          driverName: profile.name,
        );

        // Assign the new state
        uiState.value = newState;

        logDebug('Driver profile loaded: ${profile.name}');
        logDebug('Current UI state driver name: ${currentUiState.driverName}');
      } else {
        logError('No driver profile found in LocalStorage');
        // Fallback to static value if profile not found
        uiState.value = currentUiState.copyWith(
          driverName:
              LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'Driver',
        );
      }
      // Force UI update
      update();
    } catch (e) {
      logError('Error loading driver profile: $e');
    } finally {
      toggleLoading(loading: false);
    }
  }

  // create cabwire
  Future<void> createCabwire() async {
    toggleLoading(loading: true);

    try {
      if (currentUiState.createRideModel == null) {
        addUserMessage('No ride data available');
        toggleLoading(loading: false);
        return;
      }

      // Calculate fare from the total amount
      final double fare =
          double.tryParse(currentUiState.totalAmount ?? '0') ?? 350;

      final result = await createCabwireUsecase.execute(
        currentUiState.createRideModel!,
        fare,
      );

      result.fold(
        (error) {
          addUserMessage(error);
          toggleLoading(loading: false);
        },
        (response) {
          addUserMessage(response.message);

          // Update the ride data with the response
          _updateRideDataWithResponse(response.data);

          toggleLoading(loading: false);
          Get.to(
            () => CreatePostDetailsScreen(cabwireResponseEntity: response),
          );
        },
      );
    } catch (e) {
      logError('Error creating cabwire: $e');
      addUserMessage('Failed to create cabwire: $e');
      toggleLoading(loading: false);
    }
  }

  // Update ride data with response
  void _updateRideDataWithResponse(CabwireDataEntity data) {
    final updatedRideData = RideData(
      driverName: currentUiState.driverName ?? 'Driver',
      vehicleNumber: currentUiState.rideData?.vehicleNumber ?? 'Vehicle',
      vehicleModel: currentUiState.rideData?.vehicleModel ?? 'Model',
      pickupLocation: data.pickupLocation.address,
      dropoffLocation: data.dropoffLocation.address,
      totalAmount: data.fare.toString(),
    );

    uiState.value = currentUiState.copyWith(rideData: updatedRideData);
    update();
  }

  // set create ride model
  void setCreateRideModel(CreateRideModel createRideModel) {
    uiState.value = currentUiState.copyWith(createRideModel: createRideModel);
    setTotalAmount();
  }

  // set total amount
  void setTotalAmount() {
    final totalAmount =
        (double.parse(currentUiState.createRideModel?.totalDistance ?? '0') *
                double.parse(currentUiState.createRideModel?.perKmRate ?? '0'))
            .toString();
    uiState.value = currentUiState.copyWith(totalAmount: totalAmount);
  }

  // add user message
  @override
  Future<void> addUserMessage(String message) async {
    uiState.value = currentUiState.copyWith(userMessage: message);
    showMessage(message: currentUiState.userMessage);
  }

  // toggle loading
  @override
  Future<void> toggleLoading({required bool loading}) async {
    uiState.value = currentUiState.copyWith(isLoading: loading);
  }
}
