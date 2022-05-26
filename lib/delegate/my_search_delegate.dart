import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../model/group_model.dart';
import '../model/user_model.dart';
import '../pages/chat_page.dart';

class MySearchDelegate extends SearchDelegate {
  dynamic resultsKey = const Key("results");
  dynamic suggestionsKey = const Key("suggestions");
  final String _uid = (prefs?.getString("uid"))!;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<GroupModel> createNewGroup(
      List<String>? membersUid, String type) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    var checkGroupQuerySnapshot = await _db
        .collection("group")
        .where("members", arrayContains: membersUid!)
        .where("type", isEqualTo: type)
        .get();
    if (checkGroupQuerySnapshot.docs.isNotEmpty) {
      GroupModel group =
          GroupModel.fromJson(checkGroupQuerySnapshot.docs.single.data());
      return group;
    }
    GroupModel group = GroupModel(
      createdAt: DateTime.now().toIso8601String(),
      modifiedAt: DateTime.now().toIso8601String(),
      createdBy: (prefs?.getString("uid"))!,
      gid: "tempgid",
      name: "",
      imageUrl: "",
      type: type,
      members: membersUid,
    );

    var docRef = await _db.collection("group").add(group.toJson());
    await docRef.update({"gid": docRef.id});

    for (String userUid in membersUid) {
      await _db.collection("user").doc(userUid).update({
        "groups": FieldValue.arrayUnion([docRef.id])
      });
    }

    var createdGroupSnapshot = await docRef.get();
    return GroupModel.fromJson(createdGroupSnapshot.data()!);
  }

  Future<GroupModel> _getGroupData() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    var currentUserQuerySnapshot =
        await _db.collection("user").where("uid", isEqualTo: _uid).get();

    UserModel currentUser =
        UserModel.fromJson(currentUserQuerySnapshot.docs.single.data());
    List<String> groupsId = currentUser.groups;
    for (String groupId in groupsId) {
      var fetchedGroupQuerySnapshot =
          await _db.collection("group").where("gid", isEqualTo: groupId).get();
      GroupModel groupData =
          GroupModel.fromJson(fetchedGroupQuerySnapshot.docs.single.data());
      if (groupData.members.contains(users.single.uid)) {
        groupData.imageUrl = users.single.imageUrl;
        return groupData;
      }
    }
    List<String> membersUid = [_uid, users.single.uid];
    GroupModel group = await createNewGroup(membersUid, "direct");
    return group;

    // var queryResult = await _db
    //     .collection("group")
    //     .where("members", arrayContains: [_uid, users.single.uid])
    //     .where("type", isEqualTo: "direct")
    //     .get();
    // print(queryResult.size);
    // if (queryResult.size == 0) {
    //   List<String> membersUid = [(prefs?.getString("uid"))!, users.single.uid];
    //   group = await createNewGroup(membersUid, "direct");
    // } else {
    //   group = GroupModel.fromJson(queryResult.docs.single.data());
    // }
    // return group;
  }

  Future<List<UserModel>> _fetchUsers() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    var searchUserQueryResult = await _db
        .collection("user")
        .where("email", isEqualTo: query)
        .where("uid", isNotEqualTo: (prefs?.getString("uid"))!)
        .get();
    for (var userSnapshot in searchUserQueryResult.docs) {
      var userData = userSnapshot.data();
      UserModel user = UserModel.fromJson(userData);
      if (user.imageUrl.isNotEmpty) {
        user.imageUrl = await _storage
            .ref("${user.uid}/images/profile_image.jpg")
            .getDownloadURL();
      }
      users.add(user);
    }
    return users;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  List<UserModel> users = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            List<UserModel> users = snapshot.data as List<UserModel>;
            if (users.isNotEmpty) {
              return ListTile(
                key: suggestionsKey,
                contentPadding: const EdgeInsets.all(8.0),
                onTap: () async {
                  GroupModel groupData = await _getGroupData();
                  close(context, null);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(groupData: groupData)));
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: users.single.imageUrl.isNotEmpty
                      ? NetworkImage(users.single.imageUrl)
                      : const NetworkImage(
                          "https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar-300x300.jpg"),
                ),
                title: Text(users.single.displayName),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return users.isNotEmpty
        ? ListTile(
            key: resultsKey,
            contentPadding: const EdgeInsets.all(8.0),
            onTap: () async {
              GroupModel groupData = await _getGroupData();
              close(context, null);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(groupData: groupData)));
            },
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: users.single.imageUrl.isNotEmpty
                  ? NetworkImage(users.single.imageUrl)
                  : const NetworkImage(
                      "https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar-300x300.jpg"),
            ),
            title: Text(users.single.displayName),
          )
        : const SizedBox();
  }
}
