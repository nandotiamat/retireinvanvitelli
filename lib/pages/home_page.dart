import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/chats_page.dart';
import 'package:retireinvanvitelli/pages/profile_page.dart';
import 'package:retireinvanvitelli/pages/settings_page.dart';
import 'package:retireinvanvitelli/types/chat_data.dart';
import '../globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getSharedPreferences() async {
    // final prefs = await SharedPreferences.getInstance();
    
    String? uid = prefs!.getString("uid");
    print(uid);
    //int? token = prefs.getInt("token");
    //print(token);
  }

  int _currentIndex = 1;
  List<ChatData> chatData = [
    ChatData(
      lastMessageTime: "13:23",
      numberOfUnreadMessages: 134,
      avatarUrl:
          "https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar-300x300.jpg",
      chatTitle: "Dummy",
      lastMessage: "Lorem Ipsum",
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retire in Vanvitelli"),
        actions: <Widget>[
          IconButton(
              onPressed: getSharedPreferences, icon: const Icon(Icons.search)),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          const ProfilePage(),
          ChatsPage(
            chatData: chatData,
          ),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profilo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messaggi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Impostazioni',
          ),
        ],
      ),
    );
  }
}
