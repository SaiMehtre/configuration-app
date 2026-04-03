import 'package:flutter/material.dart';

class CommandInput extends StatelessWidget {
  const CommandInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
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
    );
  }
}