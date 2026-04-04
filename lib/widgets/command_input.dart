import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../main.dart';

class CommandInput extends StatefulWidget {
  const CommandInput({super.key});

  @override
  State<CommandInput> createState() => _CommandInputState();
}

class _CommandInputState extends State<CommandInput> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: ssidController,
            decoration: const InputDecoration(
              labelText: "WiFi SSID",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "WiFi Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final ssid = ssidController.text.trim();
              final password = passwordController.text.trim();

              if (ssid.isEmpty || password.isEmpty) {
                messengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text("Enter SSID & Password")),
                );
                return;
              }

              final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

              // check TCP connection
              if (!deviceProvider.isConnected) {
                messengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text("Device not connected")),
                );
                return;
              }

              try {
                await deviceProvider.sendWifiConfig(ssid, password);
                messengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text("Command Sent")),
                );
              } catch (e) {
                messengerKey.currentState?.showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Configure Device"),
          )
        ],
      ),
    );
  }
}
