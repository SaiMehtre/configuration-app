// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/device_provider.dart';

// class TcpConsole extends StatefulWidget {
//   const TcpConsole({super.key});

//   @override
//   State<TcpConsole> createState() => _TcpConsoleState();
// }

// class _TcpConsoleState extends State<TcpConsole> {
//   final List<String> logs = [];
//   final ScrollController _scrollController = ScrollController();

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(
//           _scrollController.position.maxScrollExtent,
//         );
//       }
//     });
//   }

//   Color _getColor(String log) {
//     if (log.startsWith("📤")) return Colors.blue;
//     if (log.startsWith("📥")) return Colors.green;
//     if (log.startsWith("❌")) return Colors.red;
//     return Colors.grey;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceProvider = Provider.of<DeviceProvider>(context);

//     return Container(
//       height: 220,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           /// 🔥 Header (title + clear button)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "TCP Console",
//                 style: TextStyle(color: Colors.white),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.white),
//                 onPressed: () {
//                   setState(() {
//                     logs.clear();
//                   });
//                 },
//               )
//             ],
//           ),

//           const Divider(color: Colors.white),

//           /// 🔥 Logs view
//           Expanded(
//             child: StreamBuilder<String>(
//               stream: deviceProvider.logs,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   logs.add(snapshot.data!);
//                   _scrollToBottom();
//                 }

//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: logs.length,
//                   itemBuilder: (context, index) {
//                     final log = logs[index];
//                     return Text(
//                       log,
//                       style: TextStyle(
//                         color: _getColor(log),
//                         fontFamily: 'monospace',
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Color _getColor(String log) {
    if (log.startsWith("📤")) return Colors.cyanAccent;
    if (log.startsWith("📥")) return Colors.greenAccent;
    if (log.startsWith("❌")) return Colors.redAccent;
    if (log.startsWith("🔌")) return Colors.orangeAccent;

    return Colors.white70;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              const Icon(
                Icons.terminal,
                color: Colors.cyanAccent,
                size: 20,
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "TCP Console",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              IconButton(
                tooltip: "Clear Logs",
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    logs.clear();
                  });
                },
              ),
            ],
          ),

          Divider(
            color: Colors.white.withOpacity(0.15),
            height: 12,
          ),

          Expanded(
            child: StreamBuilder<String>(
              stream: deviceProvider.logs,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    (logs.isEmpty ||
                        logs.last != snapshot.data)) {
                  logs.add(snapshot.data!);
                  _scrollToBottom();
                }

                if (logs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No TCP activity yet",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  );  
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: SelectableText(
                        log,
                        style: TextStyle( 
                          color: _getColor(log),
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
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