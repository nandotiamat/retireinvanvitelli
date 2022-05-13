import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  Future<String?> _getUID() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUID(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Scaffold(
                body: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "logo",
                          child: Image.asset("images/logo.png"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Retire in Vanvitelli",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: const Text(
                            "Get started!",
                            style: TextStyle(fontSize: 20),
                          ),
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const HomePage();
            }
          }
          return const CircularProgressIndicator();
        });
  }
}
