// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
    GroupModel({
        required this.createdAt,
        required this.createdBy,
        required this.gid,
        required this.name,
        required this.imageUrl,
        required this.members,
        required this.modifiedAt,
        required this.type,
    });

    String createdAt;
    String createdBy;
    String gid;
    String name;
    String imageUrl;
    List<String> members;
    String modifiedAt;
    String type;

    factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        gid: json["gid"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        members: List<String>.from(json["members"].map((x) => x)),
        modifiedAt: json["modifiedAt"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "createdBy": createdBy,
        "gid": gid,
        "name": name,
        "imageUrl": imageUrl,
        "members": List<dynamic>.from(members.map((x) => x)),
        "modifiedAt": modifiedAt,
        "type": type,
    };
}
