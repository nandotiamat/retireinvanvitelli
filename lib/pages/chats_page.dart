import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/chat_page.dart';
import 'package:retireinvanvitelli/types/chat_data.dart';
import '../globals.dart';

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
  final _db = FirebaseFirestore.instance;
  late String _uid;

  @override
  void initState() {
    super.initState();
    _uid = (prefs?.getString("uid"))!;
  }

  Future<List<Map<String, dynamic>?>> fetchGroupByUID(String uid) async {
    List<Map<String, dynamic>?> groups = [];
    final groupRef = _db.collection('group');
    final snapshot = await groupRef.where('members', arrayContains: _uid).get();
    for (var document in snapshot.docs) {
      Map<String, dynamic> data = document.data();
      groups.add(data);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchGroupByUID(_uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text("Error");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>?> groups = snapshot.data as List<Map<String, dynamic>?>;
              return Scaffold(
                body: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatData: widget.chatData[index],
                          ),
                        )),
                    leading: Hero(
                      tag: 'profilepic',
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(groups[index]!["photoURL"]),
                      ),
                    ),
                    title: Text(groups[index]!["name"]),
                    subtitle: Text(groups[index]!["recentMessage"]["messageText"]),
                    trailing: Column(children: [
                      Text((groups[index]!["recentMessage"]["sentAt"]as Timestamp).toDate().day.toString()),
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(widget
                            .chatData[index].numberOfUnreadMessages
                            .toString()),
                      ),
                    ]),
                  ),
                ),
              );
            } else {
              return const Text("emptysnapshot");
            } 
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
