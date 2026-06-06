import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../main.dart';
import '../providers/wifi_provider.dart';
import '../core/utils/app_snackbar.dart';

class CommandInput extends StatefulWidget {
  final String? selectedSsid;
  final VoidCallback? onClear;

  const CommandInput({
    super.key,
    this.selectedSsid,
    this.onClear,
  });

  @override
  State<CommandInput> createState() => _CommandInputState();
}

class _CommandInputState extends State<CommandInput> {
  final TextEditingController ssidController = TextEditingController();

  bool isConfiguring = false;

  final TextEditingController passwordController = TextEditingController();

    @override
    void didUpdateWidget(covariant CommandInput oldWidget) {
      super.didUpdateWidget(oldWidget);

      if (widget.selectedSsid != null &&
          widget.selectedSsid != oldWidget.selectedSsid) {
        ssidController.text = widget.selectedSsid!;
      }
    }

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
            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(
              labelText: "WiFi SSID",
              labelStyle: const TextStyle(color: Colors.white70),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.cyanAccent.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(14),
              ),

              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.cyanAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(
              labelText: "WiFi Password",
              labelStyle: const TextStyle(color: Colors.white70),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.cyanAccent.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(14),
              ),

              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.cyanAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isConfiguring
                    ? const Color(0xFF111827)
                    : Colors.cyanAccent,

                foregroundColor:
                    isConfiguring ? Colors.white : Colors.black,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              onPressed: isConfiguring
                  ? null
                  : () async {
                      final ssid = ssidController.text.trim();
                      final password =
                          passwordController.text.trim();

                      if (ssid.isEmpty || password.isEmpty) {
                        AppSnackbar.warning(
                          context,
                          "Enter SSID & Password",
                        );
                        return;
                      }

                      final deviceProvider =
                          Provider.of<DeviceProvider>(
                        context,
                        listen: false,
                      );

                      if (!deviceProvider.isConnected) {
                        AppSnackbar.error(
                          context,
                          "Device not connected",
                        );
                        return;
                      }

                      try {
                        setState(() {
                          isConfiguring = true;
                        });

                        Provider.of<WifiProvider>(
                          context,
                          listen: false,
                        ).clearConnectedWifi();


                        await deviceProvider.sendWifiConfig(
                          ssid,
                          password,
                        );

                        deviceProvider.disconnect();

                        // await Future.delayed(
                        //   const Duration(seconds: 2),
                        // );

                        // if (context.mounted) {
                        //   await Provider.of<WifiProvider>(
                        //     context,
                        //     listen: false,
                        //   ).scanWifi();
                        // }

                        for (int i = 0; i < 10; i++) {
                          await Future.delayed(
                            const Duration(seconds: 1),
                          );

                          if (!context.mounted) return;

                          final wifiProvider =
                              Provider.of<WifiProvider>(
                            context,
                            listen: false,
                          );

                          await wifiProvider.refreshConnectedWifi();

                          final currentWifi =
                              wifiProvider.connectedWifi;

                          if (currentWifi != null &&
                              !currentWifi.contains("VIO SMART SWITCH")) {
                            break;
                          }
                        }

                        ssidController.clear();
                        passwordController.clear();

                        widget.onClear?.call();

                        AppSnackbar.success(
                          context,
                          "Device configured successfully",
                        );

                        setState(() {
                          isConfiguring = false;
                        });
                      } catch (e) {
                        setState(() {
                          isConfiguring = false;
                        });

                        AppSnackbar.error(
                          context,
                          "Error: $e",
                        );
                      }
                    },

              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),

                child: isConfiguring
                    ? Row(
                        key: const ValueKey("loading"),
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.cyanAccent,
                            ),
                          ),

                          SizedBox(width: 14),

                          Text(
                            "Configuring Device...",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        "Configure Device",
                        key: ValueKey("button"),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
