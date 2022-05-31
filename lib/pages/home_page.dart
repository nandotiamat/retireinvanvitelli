import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/delegate/my_search_delegate.dart';
import 'package:retireinvanvitelli/pages/chats_page.dart';
import 'package:retireinvanvitelli/pages/profile_page.dart';
import 'package:retireinvanvitelli/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

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
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ProfilePage(),
          ChatsPage(),
          // SettingsPage(),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Impostazioni',
          // ),
        ],
      ),
    );
  }
}
