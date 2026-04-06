import 'dart:convert';
import 'dart:io';
import 'dart:async';

class TcpService {
  Socket? _socket;
  bool _isListening = false;

  /// 🔥 Stream for logs
  final StreamController<String> _logController =
      StreamController.broadcast();

  Stream<String> get logs => _logController.stream;

  Future<void> connect(String ip, int port) async {
    _socket = await Socket.connect(
      ip,
      port,
      timeout: const Duration(seconds: 10),
    );

    _logController.add("✅ Connected to $ip:$port");

    if (!_isListening) {
      _socket!.listen(
        (data) {
          final msg = utf8.decode(data);
          _logController.add("📥 $msg");
        },
        onError: (error) {
          _logController.add("❌ ERROR: $error");
        },
        onDone: () {
          _logController.add("🔌 Disconnected");
          _socket = null;
          _isListening = false;
        },
      );

      _isListening = true;
    }
  }

  Future<void> sendCommand(Map<String, dynamic> command) async {
    if (_socket == null) {
      throw Exception("Socket not connected");
    }

    String jsonCommand = jsonEncode(command);

    _socket!.write("$jsonCommand\n");
    await _socket!.flush();

    _logController.add("📤 $jsonCommand");
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
    _isListening = false;
    _logController.add("🔌 Manually disconnected");
  }
}