import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retireinvanvitelli/pages/get_started_page.dart';

void main() {
  runApp(const RetireInVanvitelli());
}

class RetireInVanvitelli extends StatefulWidget {
  const RetireInVanvitelli({Key? key}) : super(key: key);

  @override
  State<RetireInVanvitelli> createState() => _RetireInVanvitelliState();
}

class _RetireInVanvitelliState extends State<RetireInVanvitelli> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retire in Vanvitelli',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const GetStartedPage(),
    );
  }
}
