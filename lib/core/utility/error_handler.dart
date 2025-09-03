import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static const String _logTag = 'ErrorHandler';

  /// Handle and log errors with context
  static void handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    bool showToUser = false,
    VoidCallback? onRetry,
  }) {
    final errorMessage = _formatErrorMessage(error, context);

    // Log error
    if (kDebugMode) {
      debugPrint('$_logTag: $errorMessage');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    // Handle specific error types
    if (error is NetworkError) {
      _handleNetworkError(error, showToUser, onRetry);
    } else if (error is ValidationError) {
      _handleValidationError(error, showToUser);
    } else {
      _handleGenericError(errorMessage, showToUser);
    }
  }

  /// Format error message with context
  static String _formatErrorMessage(dynamic error, String? context) {
    final baseMessage = error.toString();
    return context != null ? '$context: $baseMessage' : baseMessage;
  }

  /// Handle network-related errors
  static void _handleNetworkError(
    NetworkError error,
    bool showToUser,
    VoidCallback? onRetry,
  ) {
    if (showToUser) {
      // Show network error dialog with retry option
      _showErrorDialog(
        title: 'Network Error',
        message: error.message,
        showRetry: onRetry != null,
        onRetry: onRetry,
      );
    }
  }

  /// Handle validation errors
  static void _handleValidationError(ValidationError error, bool showToUser) {
    if (showToUser) {
      _showErrorSnackBar(error.message);
    }
  }

  /// Handle generic errors
  static void _handleGenericError(String message, bool showToUser) {
    if (showToUser) {
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
    }
  }

  /// Show error dialog
  static void _showErrorDialog({
    required String title,
    required String message,
    bool showRetry = false,
    VoidCallback? onRetry,
  }) {
    final context = _getCurrentContext();
    if (context == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (showRetry && onRetry != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRetry();
                  },
                  child: const Text('Retry'),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  /// Show error snackbar
  static void _showErrorSnackBar(String message) {
    final context = _getCurrentContext();
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Get current context (you might need to implement this based on your navigation setup)
  static BuildContext? _getCurrentContext() {
    // This is a simplified implementation
    // You might need to use a global navigator key or similar approach
    return null;
  }
}

/// Custom error classes
class NetworkError extends Error {
  final String message;
  final int? statusCode;

  NetworkError(this.message, {this.statusCode});

  @override
  String toString() =>
      'NetworkError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ValidationError extends Error {
  final String message;
  final String? field;

  ValidationError(this.message, {this.field});

  @override
  String toString() =>
      'ValidationError: $message${field != null ? ' (Field: $field)' : ''}';
}

class ApiError extends NetworkError {
  ApiError(super.message, {super.statusCode});
}

class ImageLoadError extends NetworkError {
  final String imageUrl;

  ImageLoadError(this.imageUrl)
    : super('Failed to load image: $imageUrl', statusCode: 404);
}
