import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screens/settings_screen.dart';
import 'services/settings_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nagendra Assistant',
      theme: ThemeData.dark(),
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController controller =
      TextEditingController();

  final List<ChatMessage> messages = [];

  bool loading = false;

  Future<void> sendMessage() async {

    final prompt = controller.text.trim();

    if (prompt.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: prompt,
          isUser: true,
        ),
      );

      loading = true;
    });

    controller.clear();

    try {

      final provider =await SettingsService.getProvider();
      final backendUrl =await SettingsService.getBackendUrl();

      final response = await http.post(
        Uri.parse("$backendUrl/chat",),
        headers: {
          "Content-Type":
              "application/json",
        },
        body: jsonEncode({
          "message": prompt,
          "provider": provider,
        }),
      );

      final data =
          jsonDecode(response.body);

      setState(() {
        messages.add(
          ChatMessage(
            text: data["response"],
            isUser: false,
          ),
        );
      });

    } catch (e) {

      setState(() {
        messages.add(
          ChatMessage(
            text:
                "Error: $e",
            isUser: false,
          ),
        );
      });

    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nagendra Assistant",),
        actions: 
          [
            IconButton
            (
              icon:const Icon(Icons.settings),
              onPressed: () 
              {
                Navigator.push(context, MaterialPageRoute(builder:(_) =>const SettingsScreen(),),);
              },
            ),
          ],
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount:
                  messages.length,
              itemBuilder:
                  (context, index) {

                final msg =
                    messages[index];

                return Align(
                  alignment:
                      msg.isUser
                          ? Alignment
                              .centerRight
                          : Alignment
                              .centerLeft,

                  child: Container(
                    margin:
                        const EdgeInsets
                            .symmetric(
                            vertical: 6),

                    padding:
                        const EdgeInsets
                            .all(12),

                    decoration:
                        BoxDecoration(
                      color:
                          msg.isUser
                              ? Colors.blue
                              : Colors
                                  .grey[800],

                      borderRadius:
                          BorderRadius
                              .circular(
                                  12),
                    ),

                    child: Text(
                      msg.text,
                    ),
                  ),
                );
              },
            ),
          ),

          if (loading)
            const Padding(
              padding:
                  EdgeInsets.all(8),
              child: Text(
                "Thinking...",
              ),
            ),

          Row(
            children: [

              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets
                          .all(8),
                  child: TextField(
                    controller:
                        controller,
                    decoration:
                        const InputDecoration(
                      hintText:
                          "Ask anything...",
                    ),
                  ),
                ),
              ),

              IconButton(
                onPressed:
                    sendMessage,
                icon:
                    const Icon(
                        Icons.send),
              )
            ],
          )
        ],
      ),
    );
  }
}