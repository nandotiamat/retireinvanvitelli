// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        required this.displayName,
        required this.email,
        required this.groups,
        required this.imageUrl,
        required this.uid,
    });

    String displayName;
    String email;
    List<String> groups;
    String imageUrl;
    String uid;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        displayName: json["displayName"],
        email: json["email"],
        groups: List<String>.from(json["groups"].map((x) => x)),
        imageUrl: json["imageUrl"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "imageUrl": imageUrl,
        "uid": uid,
    };
}
