import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/home_page.dart';
import 'package:retireinvanvitelli/pages/password_recoverypage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";

  void _handleLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  void _handleForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordRecoveryPage()),
    );
  }

  void _handleRegistration() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const SignupPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
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
                        color: Colors.black),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AuthTextField(
                  onChanged: (value) {
                    email = value;
                  },
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Email",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AuthTextField(
                  onChanged: (value) {
                    password = value;
                  },
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Password",
                  isPassword: true,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)))),
                child: const Text('Login'),
                onPressed: _handleLogin,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              RichText(
                text: TextSpan(
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                    text: 'Non sei ancora registrato? ',
                    children: [
                      TextSpan(
                          text: "Registrati",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600),
                          // TODO: SIGNUP SCREEN
                          recognizer: TapGestureRecognizer()
                            ..onTap = _handleRegistration),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}