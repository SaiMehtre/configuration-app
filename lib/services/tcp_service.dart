import 'dart:convert';
import 'dart:io';

class TcpService {
  Socket? _socket;
  bool _isListening = false;

  Future<void> connect(String ip, int port) async {
    try {
      _socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 5),
      );

      print("✅ Connected to device");

      // 🔥 Listen ONLY ONCE
      if (!_isListening) {
        _socket!.listen(
          (data) {
            print("📩 RESPONSE: ${utf8.decode(data)}");
          },
          onError: (error) {
            print("❌ SOCKET ERROR: $error");
          },
          onDone: () {
            print("🔌 CONNECTION CLOSED");
            _isListening = false;
            _socket = null;
          },
        );

        _isListening = true;
      }
    } catch (e) {
      print("❌ CONNECT ERROR: $e");
      rethrow;
    }
  }

  Future<void> sendCommand(Map<String, dynamic> command) async {
    if (_socket == null) {
      throw Exception("Socket not connected");
    }

    try {
      String jsonCommand = jsonEncode(command);

      // 🔥 IMPORTANT: newline for ESP parsing
      _socket!.write("$jsonCommand\n");

      await _socket!.flush();

      print("🚀 Command sent: $jsonCommand");
    } catch (e) {
      print("❌ SEND ERROR: $e");
      rethrow;
    }
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
    _isListening = false;
    print("🔌 Disconnected");
  }
}