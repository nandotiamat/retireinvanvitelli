import 'package:flutter/material.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.all(45.0),
              child: Text(
                'E quindi vorresti recuperare la Password... Salvato ma he ne so?',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
