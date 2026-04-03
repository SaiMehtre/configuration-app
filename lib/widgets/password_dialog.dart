class PasswordDialog extends StatefulWidget {
  final WifiNetwork wifi;

  const PasswordDialog({required this.wifi});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Connect to ${widget.wifi.ssid}"),
      content: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(labelText: "Password"),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Provider.of<WifiProvider>(context, listen: false)
                .connectWifi(widget.wifi.ssid, controller.text);

            Navigator.pop(context);
          },
          child: Text("Connect"),
        )
      ],
    );
  }
}