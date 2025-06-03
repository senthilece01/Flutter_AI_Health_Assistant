import 'package:chat_bot/helper/api_helper.dart';
import 'package:chat_bot/helper/constants.dart';
import 'package:chat_bot/views/widgets/chat_list_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 117, 154),
        elevation: 0.0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
        ),
        title: Text(
          appName,
          textAlign: TextAlign.left,
          style: GoogleFonts.figtree(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
        child: Column(
          children: [
            ChatListView(messages: _messages),
            Container(
              height: 60,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration.collapsed(
                          hintText: typeQuestionHere),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send,
                        color: Color.fromARGB(255, 0, 117, 154)),
                    onPressed: () {
                      String message = _controller.text.trim();
                      if (message.isNotEmpty) {
                        sendMessage(message);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  Future<void> sendMessage(String message) async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(noInternetConnection),
            content: const Text(checkInternetConnectionStr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(okay),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      _messages.add(".$message");
    });

    final response = await APIHelper.callGoogleAPI(message);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body)['candidates'][0]['content'];

      final String generatedResponse = data['parts'][0]['text'];

      setState(() {
        _messages.add(generatedResponse);
      });
    } else {
      throw Exception(failedLoadResponse);
    }
  }
}
