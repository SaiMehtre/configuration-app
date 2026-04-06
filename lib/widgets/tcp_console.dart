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
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  Color _getColor(String log) {
    if (log.startsWith("📤")) return Colors.blue;
    if (log.startsWith("📥")) return Colors.green;
    if (log.startsWith("❌")) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          /// 🔥 Header (title + clear button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TCP Console",
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  setState(() {
                    logs.clear();
                  });
                },
              )
            ],
          ),

          const Divider(color: Colors.white),

          /// 🔥 Logs view
          Expanded(
            child: StreamBuilder<String>(
              stream: deviceProvider.logs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  logs.add(snapshot.data!);
                  _scrollToBottom();
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Text(
                      log,
                      style: TextStyle(
                        color: _getColor(log),
                        fontFamily: 'monospace',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}