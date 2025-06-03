class ApiEndPoint {
  static const baseUrl = "http://10.0.60.114:5005/api/v1";
  static const imageUrl = "http://10.0.60.114:3000";
  static const socketUrl = "http://10.0.60.114:3001";

  static const signUp = "$baseUrl/user";
  static const verifyEmail = "$baseUrl/verify-email";
  static const signIn = "$baseUrl/login";
  static const forgotPassword = "$baseUrl/forget-password";
  static const verifyOtp = "$baseUrl/verify-otp";
  static const resetPassword = "$baseUrl/reset-password";
  static const changePassword = "$baseUrl/change-password";
  static const user = "$baseUrl/  users";
  static const notifications = "$baseUrl/notifications";
  static const privacyPolicies = "$baseUrl/privacy-policies";
  static const termsOfServices = "$baseUrl/terms-and-conditions";
  static const chats = "$baseUrl/chats";
  static const messages = "$baseUrl/messages";
}
