import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wifi_network.dart';
import '../providers/wifi_provider.dart';
import '../providers/device_provider.dart';
class PasswordDialog extends StatefulWidget {
  final AppWifiNetwork wifi;

  const PasswordDialog({super.key, required this.wifi});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Connect to ${widget.wifi.ssid}"),
      content: TextField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(labelText: "Password"),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final wifiProvider = Provider.of<WifiProvider>(context, listen: false);
            final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

            Navigator.pop(context); // close dialog

            try {
              await wifiProvider.connectWifi(widget.wifi.ssid, controller.text);

              // wait for IP assignment + hotspot stabilization
              await Future.delayed(const Duration(seconds: 3));

              if (widget.wifi.ssid == "VIO SMART SWITCH") {
                try {
                  await deviceProvider.connectToDevice();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("TCP Connected!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("TCP connect failed: $e")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("WiFi Connected")),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Wrong password or connection failed")),
              );
            }
          },
          child: const Text("Connect"),
        )
      ],
    );
  }
}