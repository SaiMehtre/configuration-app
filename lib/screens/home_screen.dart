import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wifi_network.dart';
import '../providers/wifi_provider.dart';
import '../providers/device_provider.dart';
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

    Future.microtask(() async {
      final wifiProvider =
          Provider.of<WifiProvider>(context, listen: false);

      // final deviceProvider =
      //     Provider.of<DeviceProvider>(context, listen: false);

      await wifiProvider.scanWifi();

      // if (wifiProvider.connectedWifi != null &&
      //   wifiProvider.connectedWifi!.contains("VIO SMART SWITCH")) {
      //   await deviceProvider.connectToDevice();
      // }
    });
  }
  @override
  Widget build(BuildContext context) {
    final wifiProvider = Provider.of<WifiProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Configuration App")),
      body: Column(
        children: [
          if (wifiProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          if (wifiProvider.connectedWifi != null)
            ListTile(
              title: Text("Connected WiFi: ${wifiProvider.connectedWifi}"),
              leading: const Icon(Icons.wifi, color: Colors.green),
            ),

          ListTile(
            title: Text(
              "Device TCP Status: ${deviceProvider.isConnected ? "Connected" : deviceProvider.isConnecting ? "Connecting..." : "Not Connected"}",
              style: TextStyle(
                color: deviceProvider.isConnected
                    ? Colors.green
                    : deviceProvider.isConnecting
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: !deviceProvider.isConnected && !deviceProvider.isConnecting
                ? ElevatedButton(
                    onPressed: () async {
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
                    },
                    child: const Text("Retry"),
                  )
                : null,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: wifiProvider.networks.length,
              itemBuilder: (context, index) {
                final wifi = wifiProvider.networks[index];
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