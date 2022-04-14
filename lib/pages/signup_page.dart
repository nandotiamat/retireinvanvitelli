import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email = "";
  String _password = "";
  String _username = "";
  String? _name;
  String? _surname;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleRegistration(
    String email,
    String password,
    String username,
    String? name,
    String? surname,
  ) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Registrazione'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Inserisci i tuoi dati:"),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) {
                    _email = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Inserirsci la tua email";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    labelText: 'E-Mail',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (value) {
                    _username = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Inserirsci l'username che vuoi utilizzare";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (value) {
                    _password = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Inserisci la tua password";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (value) {
                    _name = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    labelText: 'Nome (facoltativo)',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onSaved: (value) {
                    _surname = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    labelText: 'Cognome (facoltativo)',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Registrati'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _handleRegistration(
                        _email,
                        _password,
                        _username,
                        _name,
                        _surname,
                      );
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  "Controlla la tua inbox per verificare la registrazione."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
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
}
