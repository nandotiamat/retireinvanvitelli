import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/types/chat_data.dart';

class ChatPage extends StatefulWidget {
  final ChatData chatData;

  const ChatPage({Key? key, required this.chatData}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
        title: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.chatData.avatarUrl),
          ),
          title: Text(widget.chatData.chatTitle),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: const Center(
        child: Text("chat page"),
      ),
    );
  }
}
