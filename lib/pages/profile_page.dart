import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retireinvanvitelli/globals.dart';
import 'package:retireinvanvitelli/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String? userProfileImageUrl;

  void _handleLogOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("uid");
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", ModalRoute.withName("/getstarted"));
  }

  Future<UserModel> _fetchUserData(String uid) async {
    var querySnapshot =
        await _db.collection("user").where("uid", isEqualTo: uid).get();
    UserModel user = UserModel.fromJson(querySnapshot.docs.single.data());
    try {
      userProfileImageUrl = await _storage.ref(user.imageUrl).getDownloadURL();
    } catch (e) {
      print(e);
    }
    return user;
  }

  void _handleChangeImage() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1440,
    );
    var fileRef = _storage.ref(getUid()! + "/images/profile_image.jpg");
    File file = File(result!.path);
    try {
      await fileRef.putFile(file);
      var tempUserProfileImageUrl = await fileRef.getDownloadURL();
      setState(() {
        userProfileImageUrl = tempUserProfileImageUrl;
      });
    } on FirebaseException catch (e) {
      print(e);
    }
    var userRef = _db.collection("user").doc(getUid()!);
    var tempUserDoc = await userRef.get();
    UserModel tempUser = UserModel.fromJson(tempUserDoc.data()!);
    tempUser.imageUrl = fileRef.fullPath;
    await userRef.set(tempUser.toJson());
  }

  final String dummyAvatar =
      "https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar-300x300.jpg";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchUserData(getUid()!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ElevatedButton(
              onPressed: _handleLogOut,
              child: const Text("Logout"),
            );
          }

          if (snapshot.hasData) {
            UserModel user = snapshot.data as UserModel;
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: _handleChangeImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: user.imageUrl.isEmpty ||
                                    userProfileImageUrl == null
                                ? NetworkImage(dummyAvatar)
                                : NetworkImage(userProfileImageUrl!),
                          ),
                        ),
                      ),
                      // const Text(
                      //   "Name Surname",
                      //   style: TextStyle(fontSize: 24.0),
                      // ),
                      Text(
                        '@${user.displayName}',
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.black54),
                      ),
                      // TextField(
                      //   controller: TextEditingController()
                      //     ..text = "Name Username",
                      //   decoration:
                      //       const InputDecoration(label: Text("Username")),
                      // ),
                      TextField(
                        readOnly: true,
                        controller: TextEditingController()..text = user.email,
                        decoration: const InputDecoration(label: Text("Email")),
                      ),
                      // TextField(
                      //   controller: TextEditingController()
                      //     ..text = "Via Dummy 3, Dummyland",
                      //   decoration:
                      //       const InputDecoration(label: Text("Address")),
                      // ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: _handleLogOut,
                          child: const Text("LOGOUT")),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
