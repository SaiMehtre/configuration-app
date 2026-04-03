import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wifi_network.dart';
import '../providers/wifi_provider.dart';

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
            await Provider.of<WifiProvider>(context, listen: false)
                .connectWifi(widget.wifi.ssid, controller.text);

            Navigator.pop(context);
          },
          child: const Text("Connect"),
        )
      ],
    );
  }
}