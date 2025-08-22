// socket_service_impl.dart
import 'package:cabwire/core/config/api/api_end_point.dart';
import 'package:cabwire/core/utility/log/app_log.dart';
import 'package:cabwire/data/services/notification/notification_service_impl.dart';
import 'package:cabwire/data/services/storage/storage_services.dart';
import 'package:cabwire/domain/services/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketServiceImpl implements SocketService {
  static SocketServiceImpl? _instance;
  final notificationService = NotificationServiceImpl.instance;
  io.Socket? _socket;
  bool show = false;

  // Singleton pattern
  static SocketServiceImpl get instance {
    _instance ??= SocketServiceImpl._();
    return _instance!;
  }

  SocketServiceImpl._();

  @override
  bool get isConnected => _socket?.connected ?? false;

  ///<<<============ Connect with socket ====================>>>
  @override
  void connectToSocket() {
    if (_socket != null && _socket!.connected) {
      appLog("Socket already connected");
      return;
    }

    // Dispose existing socket if it exists but is not connected
    if (_socket != null) {
      _socket!.dispose();
      _socket = null;
    }

    appLog("Creating new socket connection to: ${ApiEndPoint.socketUrl}");

    _socket = io.io(
      ApiEndPoint.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setTimeout(10000)
          .build(),
    );

    _socket!.onConnect((data) {
      appLog("=============> Socket Connected Successfully: $data");
      _setupNotificationListener();
    });

    _socket!.onConnectError((data) {
      appLog("========> Socket Connection Error: $data");
      // Attempt to reconnect after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (_socket != null && !_socket!.connected) {
          appLog("Attempting to reconnect after connection error...");
          _socket!.connect();
        }
      });
    });

    _socket!.onDisconnect((data) {
      appLog("========> Socket Disconnected: $data");
    });

    _socket!.onReconnect((data) {
      appLog("========> Socket Reconnected: $data");
      _setupNotificationListener();
    });

    _socket!.onReconnectError((data) {
      appLog("========> Socket Reconnection Error: $data");
    });

    _socket!.connect();

    // Log connection attempt
    appLog("Socket connection initiated...");
  }

  @override
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      appLog("Socket disconnected and disposed");
    }
  }

  @override
  void on(String event, Function(dynamic data) handler) {
    _ensureConnected();
    _socket!.on(event, handler);
  }

  @override
  void emit(String event, dynamic data) {
    _ensureConnected();
    _socket!.emit(event, data);
  }

  @override
  void emitWithAck(
    String event,
    Map<String, dynamic> data,
    Function(dynamic data) handler,
  ) {
    _ensureConnected();
    _socket!.emitWithAck(event, data, ack: handler);
  }

  @override
  void off(String event) {
    if (_socket != null) {
      _socket!.off(event);
    }
  }

  // Private helper methods
  void _ensureConnected() {
    if (_socket == null || !_socket!.connected) {
      appLog("Socket not connected, attempting to connect...");
      connectToSocket();
    }
  }

  // Force reconnection method
  @override
  void forceReconnect() {
    appLog("Force reconnecting socket...");
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    connectToSocket();
  }

  void _setupNotificationListener() {
    if (LocalStorage.userId.isNotEmpty) {
      _socket!.on("notification::${LocalStorage.userId}", (data) {
        appLog("================> Received notification data: $data");
        notificationService.showNotification(data['message']);
      });
    }
  }

  // Additional utility methods
  void reconnect() {
    disconnect();
    connectToSocket();
  }

  void joinRoom(String roomId) {
    emit('join-room', {'roomId': roomId});
  }

  void leaveRoom(String roomId) {
    emit('leave-room', {'roomId': roomId});
  }

  void sendMessage(String roomId, String message) {
    emit('send-message', {
      'roomId': roomId,
      'message': message,
      'userId': LocalStorage.userId,
    });
  }

  void updateNotificationListener(String newUserId) {
    // Remove old listener if exists
    if (LocalStorage.userId.isNotEmpty) {
      off("user-notification::${LocalStorage.userId}");
    }

    // Add new listener
    if (newUserId.isNotEmpty && _socket != null && _socket!.connected) {
      _socket!.on("user-notification::$newUserId", (data) {
        appLog("================> Received notification data: $data");
        notificationService.showNotification(data);
      });
    }
  }

  // Get connection status
  String getConnectionStatus() {
    if (_socket == null) return "Not initialized";
    if (_socket!.connected) return "Connected";
    if (_socket!.disconnected) return "Disconnected";
    return "Unknown";
  }
}
