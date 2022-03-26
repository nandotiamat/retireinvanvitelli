import 'package:flutter/material.dart';

class PersonWidget extends StatelessWidget {
  const PersonWidget({Key? key}) : super(key: key);

  final String avatarURL =
      'https://www.imacoritti.it/wp-content/uploads/2016/08/dummy-prod-1.jpg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: CircleAvatar(
                radius: 45,
                child: Padding(
                  padding: const EdgeInsets.all(8), // Border radius
                  child: ClipOval(child: Image.network(avatarURL)),
                ),
              )),
        ),
        const Expanded(
          flex: 5,
          child: ListTile(
              title: Text('Lorem Ipsum'),
              subtitle: Text(
                  'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...')),
        ),
        Column(
          children: [
            const Text("00:00"),
            const SizedBox(height: 10.0),
            Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10.0)),
                child: const Text("123"))
          ],
        ),
      ]),
    );
  }
}
