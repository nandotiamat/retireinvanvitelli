import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/home_page.dart';
import 'package:retireinvanvitelli/pages/password_recovery_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:retireinvanvitelli/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  Future<UserCredential?> _firebaseLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);    
      final prefs = await SharedPreferences.getInstance();
      if (userCredential.user != null ) {
        await prefs.setString("uid", userCredential.user!.uid);
        // await prefs.setInt("token", userCredential.credential!.token!);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorCode;
      if (e.code == "invalid-email") {
        errorCode = "Email non valida";
      } else if (e.code == "user-disabled") {
        errorCode = "Utente disabilitato";
      } else if (e.code == "user-not-found") {
        errorCode = "Nessun utente associato a questa email";
      } else if (e.code == "wrong-password") {
        errorCode = "Password errata";
      } else {
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

      return null;
    }
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserCredential? userCredential = await _firebaseLogin(_email, _password);
      if (userCredential != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    }
  }

  void _handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        User? firebaseUser =
            (await _auth.signInWithCredential(credential)).user;
        // TODO : SOCIAL LOGIN REGISTRATION TO DATABASE
        
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _handleForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordRecoveryPage()),
    );
  }

  void _handleRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Hero(
                tag: "logo",
                child: Image.asset(
                  "images/logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
              const Text(
                'Retire in V:',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(seconds: 3),
                      animatedTexts: [
                        TypewriterAnimatedText('Chatta con i tuoi amici'),
                        TypewriterAnimatedText(
                            'Chiedi tutto ciò di cui hai bisogno nei gruppi'),
                        TypewriterAnimatedText(
                            'Ritirati nella vanvitelli...............'),
                      ],
                      onTap: () {},
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        onSaved: (value) {
                          _email = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci la tua email.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        onSaved: (value) {
                          _password = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci la tua password.';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(16.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: const Text('Login'),
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: _handleGoogleSignIn,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1.0,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: RichText(
                      text: TextSpan(
                          text: "Password dimenticata?",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _handleForgetPassword),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).primaryTextTheme.bodyText2,
                          text: 'Non sei ancora registrato? ',
                          children: [
                            TextSpan(
                                text: "Registrati",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _handleRegistration),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
