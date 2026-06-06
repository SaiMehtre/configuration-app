import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';

  final Map<String, List<String>> instructions = {
    'English': [
      'Open your mobile Wi-Fi settings and connect to VIO SMART SWITCH.\nPassword: 1234567890',
      'Then open the configuration app. In the Connected Network section, you will see VIO SMART SWITCH.',
      'The TCP Device will show as disconnected. Tap the Connect button to connect it.',
      'After the device connects successfully, tap on the Wi-Fi router/network you want the device to connect to.',
      'Once you tap the network, the Wi-Fi SSID field will be filled automatically.',
      'Now enter the password of that Wi-Fi network and click on Configure Device.',
      'The device will connect successfully.',
    ],

    'Hindi': [
      'अपने मोबाइल की Wi-Fi सेटिंग्स खोलें और VIO SMART SWITCH से कनेक्ट करें।\nपासवर्ड: 1234567890',

      'फिर Configuration App खोलें। Connected Network सेक्शन में आपको VIO SMART SWITCH दिखाई देगा।',

      'TCP Device डिस्कनेक्टेड दिखाई देगा। उसे कनेक्ट करने के लिए Connect बटन पर टैप करें।',

      'डिवाइस सफलतापूर्वक कनेक्ट होने के बाद, जिस Wi-Fi राउटर/नेटवर्क से डिवाइस को कनेक्ट करना है उस पर टैप करें।',

      'नेटवर्क पर टैप करने के बाद, Wi-Fi SSID अपने आप भर जाएगा।',

      'अब उस Wi-Fi नेटवर्क का पासवर्ड डालें और Configure Device पर क्लिक करें।',

      'डिवाइस सफलतापूर्वक कनेक्ट हो जाएगा।',
    ],

    'Marathi': [
      'आपल्या मोबाईलच्या Wi-Fi सेटिंग्समध्ये जाऊन VIO SMART SWITCH ला कनेक्ट करा।\nपासवर्ड: 1234567890',

      'त्यानंतर Configuration App उघडा। Connected Network विभागात VIO SMART SWITCH दिसेल।',

      'TCP Device डिस्कनेक्टेड दिसेल। ते कनेक्ट करण्यासाठी Connect बटणावर टॅप करा।',

      'डिव्हाइस यशस्वीरित्या कनेक्ट झाल्यानंतर, ज्या Wi-Fi राउटर/नेटवर्कला डिव्हाइस कनेक्ट करायचे आहे त्यावर टॅप करा।',

      'नेटवर्कवर टॅप केल्यानंतर, Wi-Fi SSID आपोआप भरले जाईल।',

      'आता त्या Wi-Fi नेटवर्कचा पासवर्ड टाका आणि Configure Device वर क्लिक करा।',

      'डिव्हाइस यशस्वीरित्या कनेक्ट होईल।',
    ],

    'Help': [
      'Name: Suman Kumar',

      'Contact Number: 91012 17784',

      'Address: S. No. 80, Laigude Wearhousing, Mumbai Pune Bypass Rd Flyover, near JSPM Shahu College, Ashok Nagar, Tathawade, Pune, Pimpri-Chinchwad, Maharashtra 411033',
    ],

    // 'Hindi': [
    //   'Hindi content coming soon...',
    // ],

    // 'Marathi': [
    //   'Marathi content coming soon...',
    // ],

    // 'Help': [
    //   'Help content coming soon...',
    // ],
  };

    List<TextSpan> _buildStyledText(String text) {
    final boldWords = [
      'Wi-Fi',
      'VIO', 'SMART', 'SWITCH',
      'Password',
      'Configuration', 'App',
      'Connected Network',
      'TCP', 'Device',
      'Connect',
      'Wi-Fi', 'SSID',
      'Configure', 'Device',
      'Name',
      'Contact', 'Number',
      'Address',
    ];

    List<TextSpan> spans = [];

    final words = text.split(' ');

    for (var word in words) {
      bool isBold = boldWords.any(
        (b) => word.contains(b),
      );

      spans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(
            fontWeight:
                isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Instruction Manual',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
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
            const SizedBox(height: 18),

            /// TOP CARDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  buildCard(
                    title: 'English',
                    icon: Icons.language,
                  ),

                  buildCard(
                    title: 'Hindi',
                    icon: Icons.translate,
                  ),

                  buildCard(
                    title: 'Marathi',
                    icon: Icons.g_translate,
                  ),

                  buildCard(
                    title: 'Help',
                    icon: Icons.help_outline,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// CONTENT
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: instructions[selectedLanguage]!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E293B),
                          Color(0xFF111827),
                        ],
                      ),

                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.18),
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Colors.cyanAccent.withOpacity(0.15),
                          ),

                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontSize: 14,
                              ),

                              children: _buildStyledText(
                                instructions[selectedLanguage]![index],
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
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
    );
  }

  Widget buildCard({
    required String title,
    required IconData icon,
  }) {
    final bool isSelected = selectedLanguage == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedLanguage = title;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          margin: const EdgeInsets.symmetric(horizontal: 4),

          padding: const EdgeInsets.symmetric(vertical: 14),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Colors.cyanAccent,
                      Color(0xFF06B6D4),
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF111827),
                    ],
                  ),
          ),

          child: Column(
            children: [
              Icon(
                icon,
                color:
                    isSelected ? Colors.black : Colors.cyanAccent,
                size: 22,
              ),

              const SizedBox(height: 8),

              Text(
                title,

                style: TextStyle(
                  color:
                      isSelected ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}