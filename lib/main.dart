import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/chat_page.dart';
import 'package:retireinvanvitelli/pages/profile_page.dart';
import 'package:retireinvanvitelli/pages/settings_page.dart';

void main() {
  runApp(const RetireInVanvitelli());
}

class RetireInVanvitelli extends StatefulWidget {
  const RetireInVanvitelli({Key? key}) : super(key: key);

  @override
  State<RetireInVanvitelli> createState() => _RetireInVanvitelliState();
}

class _RetireInVanvitelliState extends State<RetireInVanvitelli> {
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retire in Vanvitelli',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Retire in Vanvitelli"),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[
            ProfilePage(),
            ChatPage(),
            SettingsPage(),
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
      ),
    );
  }
}
