import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wifi_provider.dart';
import 'providers/device_provider.dart';
import 'screens/home_screen.dart';


final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WifiProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Configuration App',
        home: HomeScreen(),
      ),
    );
  }
}