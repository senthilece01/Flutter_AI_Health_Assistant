import 'package:chat_bot/helper/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatListView extends StatefulWidget {
  List<String>? messages = [];

  ChatListView({super.key, this.messages});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.messages!.length,
        itemBuilder: (context, index) {
          bool isUserMessage = widget.messages![index].startsWith(".");

          return Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              if (!isUserMessage)
                const CircleAvatar(
                  backgroundImage: AssetImage(chatBotPath),
                  backgroundColor: Colors.grey,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: !isUserMessage
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: !isUserMessage
                                ? Colors.white
                                : Color.fromARGB(255, 0, 117, 154),
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(
                            top: 5.0, right: 10, bottom: 10),
                        child: Text(
                          widget.messages![index],
                          style: TextStyle(
                              color:
                                  !isUserMessage ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
