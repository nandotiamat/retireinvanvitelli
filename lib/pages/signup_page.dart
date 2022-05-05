import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  String _username = "";
  String? _name;
  String? _surname;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<UserCredential?> _handleRegistration(
    String email,
    String password,
    String username,
    String? name,
    String? surname,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorCode ; 
      if (e.code == "invalid-email") {
        errorCode = "Formato email errato";
      } else if (e.code == "email-already-in-use") {
        errorCode = "Email già in uso";
      } else if (e.code == "operation-not-allowed") {
        errorCode = "Operazione non permessa dal server";
      } else if (e.code == "weak-password") {
        errorCode = "Password debole, inserire una password di almeno 6";
      }
      else {
        errorCode = "Errore generico";
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(errorCode),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Chiudi"),
                ),
              ],
            );
          });
    }
    return null;
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Inserisci i tuoi dati:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  obscureText: true,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      UserCredential? userCredential =
                          await _handleRegistration(
                        _email,
                        _password,
                        _username,
                        _name,
                        _surname,
                      );
                      if (userCredential != null) {
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
                                      Navigator.popUntil(
                                        context,
                                        ModalRoute.withName("/login"),
                                      );
                                    },
                                    child: const Text("Torna alla Login Page"),
                                  ),
                                ],
                              );
                            });
                      } else {}
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
