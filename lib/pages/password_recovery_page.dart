import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Recupero Password'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Inserisci il tuo indirizzo mail',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onSaved: (value) {
                    _email = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Perfavore, inserisci la tua email.";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(20),
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Recupera Password'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // TODO: Handle Password Recovery with Firebase Auth

                      _handlePasswordRecovery(_email);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  "Controlla la tua inbox per rigenerare la password."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.popUntil(
                                        context, ModalRoute.withName("/login"));
                                  },
                                  child: const Text("Torna alla Login Page"),
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePasswordRecovery(String email) {}
}
