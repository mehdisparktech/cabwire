class ApiEndPoint {
  // static const baseUrl = "https://rabby3000.binarybards.online/api/v1";
  // static const imageUrl = "https://rabby3000.binarybards.online";
  // static const socketUrl = "https://rabby3000.binarybards.online";

  static const baseUrl = "http://10.10.7.109:5005/api/v1";
  static const imageUrl = "http://10.10.7.109:5005";
  static const socketUrl = "http://10.10.7.109:5005";

  static const signUp = "$baseUrl/user";
  static const verifyEmail = "$baseUrl/auth/verify-email";
  static const signIn = "$baseUrl/auth/login";
  static const forgotPassword = "$baseUrl/auth/forget-password";
  static const verifyOtp = "$baseUrl/auth/verify-otp";
  static const resetPassword = "$baseUrl/auth/reset-password";
  static const changePassword = "$baseUrl/auth/change-password";
  static const user = "$baseUrl/  users";
  static const notifications = "$baseUrl/notifications";
  static const privacyPolicies = "$baseUrl/privacy-policies";
  static const termsOfServices = "$baseUrl/terms-and-conditions";
  static const chats = "$baseUrl/chats";
  static const messages = "$baseUrl/messages";
  static const resetCode = "$baseUrl/auth/forget-password";
  static const updateDriverProfile = "$baseUrl/user/profile/";
  static const resetPasswordWithToken = "$baseUrl/auth/reset-password";
  static const updateProfileByEmail = "$baseUrl/user/update-profile-by-email/";
  static const getProfile = "$baseUrl/user/profile";
  static const updateOnlineStatus = "$baseUrl/user/update-online-status/";
  static const contact = "$baseUrl/contact";
  static const passengers = "$baseUrl/user";
  static const passengerServices = "$baseUrl/service";
  static const passengerCategories = "$baseUrl/category";
  static const createRide = "$baseUrl/ride/create-ride";
  static const ridesAccept = "$baseUrl/ride/accept-ride-driver/";
  static const startRide = "$baseUrl/ride/continue-ride-driver/";
  static const closeTrip = "$baseUrl/ride/verify-ride-otp/";
  static const requestCloseRide = "$baseUrl/ride/request-close-ride/";
  static const cancelRide = "$baseUrl/ride/cancel-ride/";
  static const notification = "$baseUrl/notification";
  static const driverEarnings = "$baseUrl/payment/";
}
