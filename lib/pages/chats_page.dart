import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/chat_page.dart';
import 'package:retireinvanvitelli/types/chat_data.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({
    Key? key,
    required this.chatData,
  }) : super(key: key);

  final List<ChatData> chatData;
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.chatData.length,
      itemBuilder: (BuildContext context, int index) => ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                chatData: widget.chatData[index],
              ),
            )),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(widget.chatData[index].avatarUrl),
        ),
        title: Text(widget.chatData[index].chatTitle),
        subtitle: Text(widget.chatData[index].lastMessage),
        trailing: Column(children: [
          Text(widget.chatData[index].lastMessageTime),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(10.0)),
            child:
                Text(widget.chatData[index].numberOfUnreadMessages.toString()),
          ),
        ]),
      ),
    );
  }
}
