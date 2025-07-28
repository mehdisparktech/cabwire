import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerRideCard extends StatelessWidget {
  final String driverName;
  final String driverLocation;
  final String pickupLocation;
  final String dropoffLocation;
  final String distance;
  final String duration;
  final bool isCarRide;
  final VoidCallback onTap;

  const PassengerRideCard({
    super.key,
    required this.driverName,
    required this.driverLocation,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.duration,
    required this.isCarRide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.px),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver information
            Row(
              children: [
                CircleAvatar(
                  radius: 24.px,
                  backgroundColor: Colors.blue.shade200,
                  backgroundImage: AssetImage(AppAssets.icProfileImage),
                ),
                SizedBox(width: 12.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.px),
                      Text(
                        driverLocation,
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.px),

            // Trip information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip route indicators (vertical line with dots)
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Trip',
                        style: TextStyle(
                          fontSize: 16.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.px),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 20.px,
                                color: Colors.black87,
                              ),
                              SizedBox(height: 4.px),
                              Container(
                                width: 2.px,
                                height: 42.px,
                                color: Colors.grey.shade300,
                              ),
                              Icon(
                                Icons.location_on,
                                size: 20.px,
                                color: context.theme.colorScheme.primary,
                              ),
                            ],
                          ),

                          SizedBox(width: 12.px),

                          // Trip details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pickupLocation,
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 24.px),
                                Text(
                                  dropoffLocation,
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trip stats
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total Distance:',
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            distance,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.px),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Travel Time:',
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.px),
                      InkWell(
                        onTap: onTap,
                        child: Text(
                          'See Details',
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
