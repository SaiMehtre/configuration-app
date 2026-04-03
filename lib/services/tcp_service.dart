import 'dart:convert';
import 'dart:io';

class TcpService {
  Socket? _socket;

  Future<void> connect(String ip, int port) async {
    _socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
    print("Connected to device");
  }

  Future<void> sendCommand(Map<String, dynamic> command) async {
    if (_socket == null) {
      throw Exception("Socket not connected");
    }

    String jsonCommand = jsonEncode(command);

    _socket!.write(jsonCommand + "\n");
    await _socket!.flush();

    print("Command sent: $jsonCommand");
  }

  void disconnect() {
    _socket?.close();
    _socket = null;
  }
}