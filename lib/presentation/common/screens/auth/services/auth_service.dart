import 'package:get/get.dart';

class AuthService extends GetxService {
  // Observable states
  final Rx<bool> isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  // Registration
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Verify Email
  Future<bool> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password
  Future<bool> resetPassword({required String email}) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Set New Password
  Future<bool> setNewPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1)); // Simulating API call
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
