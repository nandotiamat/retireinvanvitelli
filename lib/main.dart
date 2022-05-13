import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart';
import 'package:retireinvanvitelli/pages/error_page.dart';
import 'package:retireinvanvitelli/pages/get_started_page.dart';
import 'package:retireinvanvitelli/pages/home_page.dart';
import 'package:retireinvanvitelli/pages/login_page.dart';
import 'package:retireinvanvitelli/pages/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const RetireInVanvitelli());
}

class RetireInVanvitelli extends StatefulWidget {
  const RetireInVanvitelli({Key? key}) : super(key: key);

  @override
  State<RetireInVanvitelli> createState() => _RetireInVanvitelliState();
}

class _RetireInVanvitelliState extends State<RetireInVanvitelli> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Retire in Vanvitelli',
            initialRoute: "/getstarted",
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/getstarted': (context) => const GetStartedPage(),
              '/': (context) => const HomePage(),
            },
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const CircularProgressIndicator();
      } 
    );
  }
}
