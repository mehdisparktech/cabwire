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

  // Common vehicle makes (extend as needed)
  static const List<String> vehicleMakes = [
    'Toyota',
    'Honda',
    'Ford',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Nissan',
    'Hyundai',
    'Kia',
    'Volkswagen',
    'Chevrolet',
    'Tesla',
    'Lexus',
    'Mazda',
    'Subaru',
    'Mitsubishi',
    'Volvo',
    'Peugeot',
    'Renault',
    'Other',
  ];

  // Mapping of vehicle make to popular models
  static const Map<String, List<String>> makeToModels = {
    'Toyota': [
      'Camry',
      'Corolla',
      'RAV4',
      'Highlander',
      'Yaris',
      'Prius',
      'Fortuner',
      'Hilux',
      'Avensis',
    ],
    'Honda': [
      'Civic',
      'Accord',
      'CR-V',
      'Fit',
      'HR-V',
      'City',
      'Vezel',
      'Pilot',
    ],
    'Ford': [
      'Focus',
      'Fiesta',
      'Fusion',
      'Escape',
      'Explorer',
      'F-150',
      'Edge',
    ],
    'BMW': ['1 Series', '3 Series', '5 Series', 'X1', 'X3', 'X5'],
    'Mercedes-Benz': ['A-Class', 'C-Class', 'E-Class', 'GLA', 'GLC', 'GLE'],
    'Audi': ['A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7'],
    'Nissan': ['Sunny', 'Sentra', 'Altima', 'Qashqai', 'X-Trail', 'Rogue'],
    'Hyundai': ['Accent', 'Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'i20'],
    'Kia': ['Rio', 'Cerato', 'Optima', 'Sportage', 'Sorento', 'Seltos'],
    'Volkswagen': ['Polo', 'Golf', 'Passat', 'Tiguan', 'Jetta', 'Touareg'],
    'Chevrolet': ['Spark', 'Aveo', 'Cruze', 'Malibu', 'Trax', 'Equinox'],
    'Tesla': ['Model 3', 'Model Y', 'Model S', 'Model X'],
    'Lexus': ['IS', 'ES', 'GS', 'RX', 'NX', 'LX'],
    'Mazda': ['Mazda2', 'Mazda3', 'Mazda6', 'CX-3', 'CX-5', 'CX-9'],
    'Subaru': ['Impreza', 'Legacy', 'Forester', 'Outback', 'XV'],
    'Mitsubishi': ['Lancer', 'Attrage', 'Outlander', 'ASX', 'Pajero'],
    'Volvo': ['S60', 'S90', 'V60', 'XC40', 'XC60', 'XC90'],
    'Peugeot': ['208', '308', '508', '2008', '3008', '5008'],
    'Renault': ['Clio', 'Megane', 'Fluence', 'Captur', 'Duster', 'Koleos'],
  };

  // Private constructor to prevent instantiation
  DriverSignUpConstants._();
}
