import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/wifi_network.dart';
import '../providers/device_provider.dart';
import '../providers/wifi_provider.dart';
import '../widgets/command_input.dart';
import 'settings_screen.dart';
import '../core/utils/app_snackbar.dart';
// import '../widgets/tcp_console.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedSsid;
  int dotCount = 0;
  Timer? dotTimer;

  @override
  void initState() {
    super.initState();

    dotTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        if (mounted) {
          setState(() {
            dotCount = (dotCount + 1) % 4;
          });
        }
      },
    );

    Future.microtask(() async {
      final wifiProvider =
          Provider.of<WifiProvider>(context, listen: false);

      await wifiProvider.scanWifi();
    });
  }

  @override
  void dispose() {
    dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wifiProvider = Provider.of<WifiProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF111827),
        centerTitle: true,

        title: const Text(
          "Configuration App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),

            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyanAccent.withOpacity(0.12),
                ),

                child: const Icon(
                  Icons.settings,
                  color: Colors.cyanAccent,
                ),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      /// BODY
      body: RefreshIndicator(
        color: Colors.cyanAccent,

        onRefresh: () async {
          await wifiProvider.scanWifi();

          if (mounted) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Dashboard refreshed"),
            //     duration: Duration(seconds: 1),
            //   ),
            // );
            AppSnackbar.success(
              context,
              "Dashboard refreshed",
            );
          }
        },

        child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF111827),
              Color(0xFF020617),
            ],
          ),
        ),

        child: Column(
          children: [
            // const SizedBox(height: 15),

            /// HEADER CARD
            // TweenAnimationBuilder<double>(
            //   tween: Tween(begin: 0.95, end: 1),
            //   duration: const Duration(seconds: 2),
            //   curve: Curves.easeInOut,
            //   builder: (context, value, child) {
            //     return Transform.scale(
            //       scale: value,
            //       child: child,
            //     );
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 15),
            //     padding: const EdgeInsets.all(18),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(22),
            //       gradient: const LinearGradient(
            //         colors: [
            //           Color(0xFF1E293B),
            //           Color(0xFF0F172A),
            //         ],
            //       ),
            //       border: Border.all(
            //         color: Colors.cyanAccent.withOpacity(0.3),
            //       ),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.cyanAccent.withOpacity(0.15),
            //           blurRadius: 20,
            //           spreadRadius: 2,
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           padding: const EdgeInsets.all(14),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.cyanAccent.withOpacity(0.15),
            //           ),
            //           child: const Icon(
            //             Icons.memory,
            //             color: Colors.cyanAccent,
            //             size: 12,
            //           ),
            //         ),

            //         const SizedBox(width: 8),

            //         const Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "IoT Device Configuration",
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 8,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),

            //               SizedBox(height: 5),

            //               Text(
            //                 "Connect your smart device securely via TCP & WiFi",
            //                 style: TextStyle(
            //                   color: Colors.white70,
            //                   fontSize: 13,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 20),

            /// LOADER
            if (wifiProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  color: Colors.cyanAccent,
                ),
              ),

            /// CONNECTED WIFI CARD
            if (wifiProvider.connectedWifi != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.green.withOpacity(0.12),
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.4),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.wifi,
                    color: Colors.greenAccent,
                  ),
                  title: Text(
                    wifiProvider.connectedWifi!
                        .replaceAll('"', ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Connected Network",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            /// TCP STATUS CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF1E293B),
                border: Border.all(
                  color: deviceProvider.isConnected
                      ? Colors.greenAccent.withOpacity(0.5)
                      : Colors.redAccent.withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 14,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: deviceProvider.isConnected
                          ? Colors.greenAccent
                          : deviceProvider.isConnecting
                              ? Colors.orangeAccent
                              : Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: (deviceProvider.isConnected
                                  ? Colors.greenAccent
                                  : deviceProvider.isConnecting
                                      ? Colors.orangeAccent
                                      : Colors.redAccent)
                              .withOpacity(0.7),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: deviceProvider.isConnecting
                        ? Row(
                            children: [
                              const Text(
                                "Connecting to Device",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              AnimatedSwitcher(
                                duration:
                                    const Duration(milliseconds: 250),

                                child: Text(
                                  "." * dotCount,
                                  key: ValueKey(dotCount),

                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            deviceProvider.isConnected
                                ? "TCP Device Connected"
                                : "TCP Device Disconnected",

                            style: TextStyle(
                              color: deviceProvider.isConnected
                                  ? Colors.white
                                  : Colors.redAccent,

                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),

                  if (!deviceProvider.isConnected)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: deviceProvider.isConnecting
                          ? null
                          : () async {
                              try {
                                await deviceProvider.connectToDevice();

                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text(
                                //       "Connected to device successfully",
                                //     ),
                                //   ),
                                // );
                                AppSnackbar.success(
                                  context,
                                  "Connected to device successfully",
                                );
                              } catch (e) {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content:
                                //         Text("Connection failed"),
                                //   ),
                                // );
                                AppSnackbar.error(
                                  context,
                                  "Connection failed",
                                );
                              }
                            },
                      child: Text(
                        deviceProvider.isConnecting
                            ? "Connecting"
                            : "Connect",

                        style: TextStyle(
                          color: deviceProvider.isConnecting
                              ? Colors.orangeAccent
                              : Colors.black,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 28,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // /// TCP CONSOLE
            // const TcpConsole(),

            // const SizedBox(height: 20),

            /// WIFI TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Available WiFi Networks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// WIFI LIST
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                itemCount: wifiProvider.networks.length,
                itemBuilder: (context, index) {
                  final AppWifiNetwork wifi =
                      wifiProvider.networks[index];

                  return AnimatedContainer(
                    duration:
                        Duration(milliseconds: 300 + (index * 50)),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E293B),
                          Color(0xFF111827),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 5,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Colors.cyanAccent.withOpacity(0.12),
                        ),
                        child: const Icon(
                          Icons.wifi,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      title: Text(
                        wifi.ssid,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        wifi.isSecure
                            ? "Secured Network"
                            : "Open Network",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white54,
                        size: 18,
                      ),
                      onTap: () {
                        setState(() {
                          selectedSsid = wifi.ssid;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            /// COMMAND INPUT
            /// COMMAND INPUT
            AbsorbPointer(
              absorbing: !deviceProvider.isConnected,
              child: Opacity(
                opacity:
                    deviceProvider.isConnected ? 1 : 0.45,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color(0xFF111827),
                        border: Border.all(
                          color:
                              Colors.cyanAccent.withOpacity(0.2),
                        ),
                      ),
                      child: CommandInput(
                        selectedSsid: selectedSsid,
                        onClear: () {
                          setState(() {
                            selectedSsid = null;
                          });
                        },
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "© Vidani Automations Pvt Ltd",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}