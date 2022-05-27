import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bubble/bubble.dart';
import 'package:retireinvanvitelli/model/group_model.dart';
import 'package:retireinvanvitelli/model/user_model.dart';

import '../globals.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  // final types.Room groupData;
  final GroupModel groupData;

  const ChatPage({Key? key, required this.groupData}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String _uid;
  late final types.User _user;
  // late types.User userTalkingTo;
  UserModel? userTalkingTo;
  String? userTalkingToImageUrl;
  @override
  void initState() {
    super.initState();
    _uid = getUid()!;
    _user = types.User(id: _uid);
    userTalkingTo = null;
  }

  late List<types.Message> _messages = [];

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) {
    return Bubble(
      child: child,
      color: _user.id != message.author.id ||
              message.type == types.MessageType.image
          ? const Color(0xfff5f5f7)
          : const Color(0xff6f61e8),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : _user.id != message.author.id
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
    );
  }

  Future<List<types.Message>> _fetchMessages(String guid) async {
    if (widget.groupData.members.length == 2) {
      var uidToSearch =
          widget.groupData.members.firstWhere((element) => element != _uid);
      var userQuerySnapshot = await db
          .collection("user")
          .where("uid", isEqualTo: uidToSearch)
          .get();
      userTalkingTo = UserModel.fromJson(userQuerySnapshot.docs.single.data());
      try {
        userTalkingToImageUrl =
            await storage.ref(userTalkingTo!.imageUrl).getDownloadURL();
      } catch (e) {
        print("non riesco a scaricare nessun immagine");
      }
    }
    List<types.Message> messages = [];
    var messageDocs = await db
        .collection("message")
        .doc(widget.groupData.gid)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .get();
    for (var message in messageDocs.docs) {
      var data = message.data();
      messages.add(types.Message.fromJson(data));
    }
    return messages;
  }

  void _addMessage(types.Message message) async {
    setState(() {
      // _messages.add(message);
      _messages.insert(0, message);
    });
    await db
        .collection("message")
        .doc(widget.groupData.gid)
        .collection("messages")
        .add(message.toJson());
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1440,
    );
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );
      _addMessage(message);
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );
      _addMessage(message);
    }
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchMessages(widget.groupData.gid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          _messages = snapshot.data as List<types.Message>;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios)),
              title: ListTile(
                leading: Hero(
                  tag: 'profilepic',
                  child: CircleAvatar(
                    backgroundImage: userTalkingToImageUrl == null
                        ? null
                        : NetworkImage(userTalkingToImageUrl!),
                  ),
                ),
                title: Text(userTalkingTo!.displayName),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Chat(
                messages: _messages,
                onAttachmentPressed: _handleAtachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                user: _user,
                bubbleBuilder: _bubbleBuilder,
                showUserAvatars: false,
                showUserNames: false,
              ),
            ),
          );
        }
        return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
      },
    );
  }
}
