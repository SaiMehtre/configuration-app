import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wifi_network.dart';
import '../providers/wifi_provider.dart';
import '../providers/device_provider.dart';
import '../widgets/password_dialog.dart';
import '../widgets/command_input.dart';
import '../widgets/tcp_console.dart';

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

      await wifiProvider.scanWifi();
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
          /// 🔄 Loader
          if (wifiProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          /// 📶 Connected WiFi (quotes removed)
          if (wifiProvider.connectedWifi != null)
            ListTile(
              title: Text(
                "Connected WiFi: ${wifiProvider.connectedWifi!.replaceAll('"', '')}",
              ),
              leading: const Icon(Icons.wifi, color: Colors.green),
            ),

          /// 📌 Instructions
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "1. Connect to VIO SMART SWITCH\n2. Tap Connect",
              textAlign: TextAlign.center,
            ),
          ),

          /// 🔌 TCP Status + Connect Button
          ListTile(
            title: Text(
              "Device TCP Status: ${deviceProvider.isConnected ? "Connected" : deviceProvider.isConnecting ? "Connecting..." : "Disconnected"}",
              style: TextStyle(
                color: deviceProvider.isConnected
                    ? Colors.green
                    : deviceProvider.isConnecting
                        ? Colors.orange
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: !deviceProvider.isConnected
                ? ElevatedButton(
                    /// ❌ disable when connecting
                    onPressed: deviceProvider.isConnecting
                        ? null
                        : () async {
                            try {
                              await deviceProvider.connectToDevice();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Connected to device")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Connection failed")),
                              );
                            }
                          },
                    child: Text(
                      deviceProvider.isConnecting
                          ? "Connecting..."
                          : "Connect",
                    ),
                  )
                : const Icon(Icons.check_circle, color: Colors.green),
          ),

          /// 📡 WiFi List
          Expanded(
            child: ListView.builder(
              itemCount: wifiProvider.networks.length,
              itemBuilder: (context, index) {
                final AppWifiNetwork wifi = wifiProvider.networks[index];

                return ListTile(
                  title: Text(wifi.ssid),
                  trailing: const Icon(Icons.wifi),
                  onTap: () => _connectDialog(context, wifi),
                );
              },
            ),
          ),

          const SizedBox(height: 10),
          const TcpConsole(),

          /// ⚠️ IMPORTANT: CommandInput tabhi kaam kare jab TCP connected
          AbsorbPointer(
            absorbing: !deviceProvider.isConnected,
            child: Opacity(
              opacity: deviceProvider.isConnected ? 1 : 0.4,
              child: const CommandInput(),
            ),
          ),
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