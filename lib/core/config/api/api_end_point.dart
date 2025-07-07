class ApiEndPoint {
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
}
