import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retireinvanvitelli/pages/login_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('images/logo.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  bottom: 20,
                  right: 120.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    child: Text(
                      'Con RETIRE IN VANVITELLI puoi chattare con i tuoi amici universitari...!',
                      textAlign: TextAlign.left,
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(350, 30)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange.shade100),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: const BorderSide(color: Colors.white),
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

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_label
    systemOverlayStyle:
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    );
    return Container(
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}
