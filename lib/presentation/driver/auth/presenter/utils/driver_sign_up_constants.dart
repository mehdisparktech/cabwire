class DriverSignUpConstants {
  // Configuration constants
  static const int verificationCodeLength = 4;
  static const int minAge = 18;
  static const int maxLicenseValidityYears = 10;

  static const List<String> genderOptions = ['Male', 'Female', 'Other'];

  static const List<String> vehicleCategories = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Convertible',
    'Van',
    'Truck',
    'Motorcycle',
    'Other',
  ];

  // Private constructor to prevent instantiation
  DriverSignUpConstants._();
}
