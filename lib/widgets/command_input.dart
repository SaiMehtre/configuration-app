import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../main.dart';

class CommandInput extends StatelessWidget {
  const CommandInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Enter command...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Command: ${controller.text}");
                },
                child: const Text("Send"),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// CONFIGURE DEVICE BUTTON
          ElevatedButton(
            onPressed: () async {
              final deviceProvider =
                  Provider.of<DeviceProvider>(context, listen: false);

              try {
                await deviceProvider.connectToDevice();

                await deviceProvider.sendWifiConfig(
                  "test",
                  "12345678",
                );

                messengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text("Command Sent")),
                );
              } catch (e) {
                messengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text("Device connection failed")),
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