import 'package:flutter/material.dart';

import 'router.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          RaisedButton(
              child: const Text("App 1"),
              onPressed: () => router.navigateTo(context, "/app1")),
          RaisedButton(
              child: const Text("App 2"),
              onPressed: () => router.navigateTo(context, "/app2"))
        ],
      ),
      color: Colors.green,
    );
  }
}
