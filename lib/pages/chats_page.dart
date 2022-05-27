import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/model/group_model.dart';
import 'package:retireinvanvitelli/model/user_model.dart';
import 'package:retireinvanvitelli/pages/chat_page.dart';
import '../globals.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  late String _uid;
  List<GroupModel?> groups = [];
  @override
  void initState() {
    super.initState();
    _uid = getUid()!;
  }

  Future<List<GroupModel?>> fetchGroupByUID(String uid) async {
    List<GroupModel?> groups = [];
    final groupRef = _db.collection('group');
    final snapshot = await groupRef.where('members', arrayContains: _uid).get();
    for (var document in snapshot.docs) {
      groups.add(GroupModel.fromJson(document.data()));
    }
    for (var group in groups) {
      var userTalkingToUid =
          group!.members.firstWhere((element) => element != _uid);
      var querySnapshot = await _db
          .collection("user")
          .where("uid", isEqualTo: userTalkingToUid)
          .get();
      UserModel userTalkingTo =
          UserModel.fromJson(querySnapshot.docs.single.data());
      group.name = userTalkingTo.displayName;
      try {
        var userImage = await _storage
            .ref("$userTalkingToUid/images/profile_image.jpg")
            .getDownloadURL();
        group.imageUrl = userImage;
      } catch (e) {
        print(e);
      }
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchGroupByUID(_uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              groups = snapshot.data as List<GroupModel?>;
              return Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {
                    List<GroupModel?> tempGroups = await fetchGroupByUID(_uid);
                    setState(() {
                      groups = tempGroups;
                    });
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: groups.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      groupData: groups[index]!,
                                    ),
                                  ),
                                );
                              },
                              leading: Hero(
                                tag: 'profilepic',
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: groups[index]!
                                          .imageUrl
                                          .isEmpty
                                      ? const NetworkImage(
                                          "https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar-300x300.jpg")
                                      : NetworkImage(groups[index]!.imageUrl),
                                ),
                              ),
                              title: Text(groups[index]!.name),
                              // subtitle:
                              //    Text(groups[index]!.recentMessage!["messageText"]),
                              //trailing: Column(children: [
                              //  Text(
                              //      (groups[index]!.recentMessage!["sentAt"] as Timestamp)
                              //          .toDate()
                              //          .day
                              //          .toString()),
                              //  const SizedBox(height: 10.0),
                              //  Container(
                              //    padding: const EdgeInsets.all(4.0),
                              //    decoration: BoxDecoration(
                              //        color: Theme.of(context).primaryColorLight,
                              //        borderRadius: BorderRadius.circular(10.0)),
                              //    child: const Text("0"),
                              //  ),
                              // ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
