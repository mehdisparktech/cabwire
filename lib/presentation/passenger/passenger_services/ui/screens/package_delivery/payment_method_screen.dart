import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/enum/service_type.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/data/models/ride/ride_response_model.dart';
import 'package:cabwire/presentation/common/components/action_button.dart';
import 'package:cabwire/presentation/common/components/payment_method_card.dart';
import 'package:cabwire/presentation/passenger/car_booking/ui/screens/passenger_ride_share_screen.dart';
import 'package:cabwire/presentation/passenger/home/ui/screens/passenger_search_destination_page.dart';
import 'package:cabwire/presentation/passenger/passenger_services/presenter/package_payment_method_presenter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PackagePaymentMethodScreen extends StatelessWidget {
  final String? serviceId;
  const PackagePaymentMethodScreen({super.key, this.serviceId});

  @override
  Widget build(BuildContext context) {
    final PackagePaymentMethodPresenter presenter =
        locate<PackagePaymentMethodPresenter>();
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Scaffold(
          body: _buildMap(context),
          bottomSheet: _buildBottomSheet(context, presenter),
        );
      },
    );
  }

  Widget _buildMap(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {}, // Use presenter's method
      initialCameraPosition: CameraPosition(
        target: LatLng(23.8103, 90.4125),
        zoom: 14.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    PackagePaymentMethodPresenter presenter,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.px),
          topRight: Radius.circular(16.px),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBar(context),
          SizedBox(height: 16.px),
          PaymentMethodSelector(
            isIWillPay: presenter.currentUiState.isIWillPay,
            isIWillPaySelected: presenter.currentUiState.isIWillPaySelected,
            onIWillPayChanged: (value) {
              presenter.onIWillPayChanged(value);
            },
            paymentMethods: [
              PaymentMethod(
                title: 'Online Payment',
                imageSrc: AppAssets.icOnlinePayment,
                isSelected:
                    presenter.currentUiState.selectedPaymentMethod ==
                    'Online Payment',
                isRecommended: true, // Show as recommended option
              ),
              PaymentMethod(
                title: 'Cash Payment',
                imageSrc: AppAssets.icCashPayment,
                isSelected:
                    presenter.currentUiState.selectedPaymentMethod ==
                    'Cash Payment',
              ),
            ],
            onPaymentMethodSelected: (method) {
              presenter.onPaymentMethodSelected(method.title);
            },
          ),
          SizedBox(height: 16.px),
          ActionButton(
            isPrimary: true,
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => PassengerSearchDestinationScreen(
                        serviceType: ServiceType.packageDelivery,
                        nextScreen: PassengerRideShareScreen(
                          rideId: '1',
                          rideResponse: RideResponseModel(
                            data: RideDataModel(
                              paymentMethod: 'Cash',
                              fare: 100,
                              userId: '1',
                              service: '1',
                              category: '1',
                              pickupLocation: LocationModel(
                                address: '123 Main St',
                                lat: 100,
                                lng: 100,
                              ),
                              dropoffLocation: LocationModel(
                                address: '123 Main St',
                                lat: 100,
                                lng: 100,
                              ),
                              distance: 100,
                              duration: 100,
                              rideStatus: '1',
                              paymentStatus: '1',
                              rideType: '1',
                              id: '1',
                              createdAt: '1',
                              updatedAt: '1',
                            ),
                            success: true,
                            message: 'success',
                          ),
                          chatId: '1',
                          isRideProcessing: false,
                        ),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Choose Your\nPayment Method',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.px, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityInt(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),
    );
  }
}
