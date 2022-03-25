import 'package:flutter/material.dart';

class personWidget extends StatelessWidget {
  const personWidget({Key? key}) : super(key: key);

  final String ema = 'https://www.imacoritti.it/wp-content/uploads/2016/08/dummy-prod-1.jpg';

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        flex: 2,
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: CircleAvatar(
              radius: 45,
              child: Padding(
                padding: const EdgeInsets.all(8), // Border radius
                child: ClipOval(
                    child: Image.network(
                        ema)),
              ),
            )),
      ),
      const Expanded(
        flex: 12,
        child: ListTile(
            title: Text('Lorem Ipsum'),
            subtitle: Text('Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...')),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text('00.00'),
      )
    ]);
  }
}
