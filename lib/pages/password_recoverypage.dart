import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retireinvanvitelli/pages/login_page.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  TextEditingController mailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Recupero Password'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'Inserisci il tuo indirizzo mail',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: mailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(20),
                  prefixIcon: Icon(Icons.mail),
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Recupera Password'),
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(13.0),
                              child: Text(
                                'Controlla la tua mail per recuperare la password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                            ),
                            Container(
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  child: const Text(
                                      'Torna alla schermata di Login'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                                )),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
