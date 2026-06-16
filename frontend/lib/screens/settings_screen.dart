import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  String provider = "ollama";

  final TextEditingController
      backendController =
          TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {

    final savedProvider =
        await SettingsService.getProvider();

    final savedUrl =
        await SettingsService.getBackendUrl();

    setState(() {
      provider = savedProvider;
      backendController.text = savedUrl;
      loading = false;
    });
  }

  Future<void> saveSettings() async {

    await SettingsService.saveProvider(
      provider,
    );

    await SettingsService.saveBackendUrl(
      backendController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Settings saved"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Provider",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            RadioListTile(
              title:
                  const Text("Ollama Local"),

              value: "ollama",

              groupValue: provider,

              onChanged: (value) {
                setState(() {
                  provider =
                      value.toString();
                });
              },
            ),

            RadioListTile(
              title:
                  const Text("OpenAI"),

              value: "openai",

              groupValue: provider,

              onChanged: (value) {
                setState(() {
                  provider =
                      value.toString();
                });
              },
            ),
            RadioListTile(
                title: const Text("Gemini"),
                value: "gemini",
                groupValue: provider,
                onChanged: (value) {
                  setState(() {
                    provider = value.toString();
                  });
                },
              ),

            const SizedBox(height: 25),

            const Text(
              "Backend URL",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  backendController,

              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),

                hintText:
                    "http://127.0.0.1:8000",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed:
                    saveSettings,

                child: const Text(
                  "Save Settings",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}