class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WifiProvider>(context, listen: false).scanWifi();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WifiProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Configuration App")),
      body: Column(
        children: [
          if (provider.isLoading)
            Center(child: CircularProgressIndicator()),

          // CONNECTED WIFI
          if (provider.connectedWifi != null)
            ListTile(
              title: Text("Connected: ${provider.connectedWifi}"),
              leading: Icon(Icons.wifi, color: Colors.green),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: provider.networks.length,
              itemBuilder: (context, index) {
                final wifi = provider.networks[index];

                return ListTile(
                  title: Text(wifi.ssid),
                  trailing: Icon(Icons.wifi),
                  onTap: () => _connectDialog(context, wifi),
                );
              },
            ),
          ),

          // COMMAND INPUT
          CommandInput(),
        ],
      ),
    );
  }

  void _connectDialog(BuildContext context, WifiNetwork wifi) {
    showDialog(
      context: context,
      builder: (_) => PasswordDialog(wifi: wifi),
    );
  }
}