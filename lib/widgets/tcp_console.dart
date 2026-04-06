import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';

class TcpConsole extends StatefulWidget {
  const TcpConsole({super.key});

  @override
  State<TcpConsole> createState() => _TcpConsoleState();
}

class _TcpConsoleState extends State<TcpConsole> {
  final List<String> logs = [];

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      color: Colors.black,
      child: StreamBuilder<String>(
        stream: deviceProvider.logs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            logs.add(snapshot.data!);
          }

          return ListView(
            children: logs
                .map(
                  (e) => Text(
                    e,
                    style: const TextStyle(
                      color: Colors.green,
                      fontFamily: 'monospace',
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}