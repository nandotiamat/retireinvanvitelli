import 'package:flutter/material.dart';
import 'package:retireinvanvitelli/widgets/personWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VChat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   final String piro =
      'https://super-monitoring.com/blog/wp-content/uploads/2019/06/lorem-ipsum.png';
      
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.draw)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /* const Padding(
              padding: EdgeInsetsDirectional.all(8.0),
              child: Text(
                'Stories',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Center(child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(piro),
                  )
                  ),
                  shape: const CircleBorder(),
                ),
              ),
            ), */
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chat',
                style: TextStyle(fontSize: 18),
              ),
            ),
           SizedBox(
              height: 600.0,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) => const Center(child: personWidget(
                )
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Contatti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messaggi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), 
            label: 'Impostazioni'),
        ],
      ),
    );
  }
}
