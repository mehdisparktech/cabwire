// socket_service.dart
abstract class SocketService {
  bool get isConnected;

  void connectToSocket();
  void disconnect();
  void on(String event, Function(dynamic data) handler);
  void emit(String event, dynamic data);
  void emitWithAck(
    String event,
    Map<String, dynamic> data,
    Function(dynamic data) handler,
  );
  void off(String event);
  void forceReconnect();
}
