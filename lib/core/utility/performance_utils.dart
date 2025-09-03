import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class PerformanceUtils {
  static const int _maxFrameSkipThreshold = 5;
  static Timer? _debounceTimer;

  /// Debounce function calls to prevent excessive API calls
  static void debounce(
    Duration delay,
    VoidCallback callback, {
    String? debugLabel,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      if (kDebugMode && debugLabel != null) {
        print('Executing debounced callback: $debugLabel');
      }
      callback();
    });
  }

  /// Execute callback after frame is rendered to avoid blocking UI
  static void executeAfterFrame(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  /// Execute callback with frame budget consideration
  static Future<void> executeWithFrameBudget(
    Future<void> Function() callback, {
    Duration maxExecutionTime = const Duration(milliseconds: 16),
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      await callback();
    } finally {
      stopwatch.stop();

      if (kDebugMode &&
          stopwatch.elapsedMilliseconds > maxExecutionTime.inMilliseconds) {
        print(
          'Warning: Long-running operation detected: ${stopwatch.elapsedMilliseconds}ms',
        );
      }
    }
  }

  /// Batch multiple operations to reduce frame drops
  static Future<List<T>> batchOperations<T>(
    List<Future<T> Function()> operations, {
    int batchSize = 3,
    Duration batchDelay = const Duration(milliseconds: 16),
  }) async {
    final results = <T>[];

    for (int i = 0; i < operations.length; i += batchSize) {
      final batch = operations.skip(i).take(batchSize);
      final batchResults = await Future.wait(batch.map((op) => op()));
      results.addAll(batchResults);

      // Add delay between batches to prevent UI blocking
      if (i + batchSize < operations.length) {
        await Future.delayed(batchDelay);
      }
    }

    return results;
  }

  /// Monitor frame performance
  static void startFrameMonitoring() {
    if (kDebugMode) {
      SchedulerBinding.instance.addTimingsCallback((timings) {
        for (final timing in timings) {
          final frameTime = timing.totalSpan.inMilliseconds;
          if (frameTime > 16) {
            // 60fps = 16ms per frame
            print('Frame drop detected: ${frameTime}ms');
          }
        }
      });
    }
  }

  /// Dispose resources
  static void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}
