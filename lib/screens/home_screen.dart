import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wifi_network.dart';
import '../providers/wifi_provider.dart';
import '../widgets/password_dialog.dart';
import '../widgets/command_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WifiProvider>(context, listen: false).scanWifi());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WifiProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Configuration App")),
      body: Column(
        children: [
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          if (provider.connectedWifi != null)
            ListTile(
              title: Text("Connected: ${provider.connectedWifi}"),
              leading: const Icon(Icons.wifi, color: Colors.green),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: provider.networks.length,
              itemBuilder: (context, index) {
                final AppWifiNetwork wifi = provider.networks[index];

                return ListTile(
                  title: Text(wifi.ssid),
                  trailing: const Icon(Icons.wifi),
                  onTap: () => _connectDialog(context, wifi),
                );
              },
            ),
          ),

          const CommandInput(),
        ],
      ),
    );
  }

  void _connectDialog(BuildContext context, AppWifiNetwork wifi) {
    showDialog(
      context: context,
      builder: (_) => PasswordDialog(wifi: wifi),
    );
  }
}