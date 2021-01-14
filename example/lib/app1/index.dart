import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx/webx.dart';

class _App1State extends State<App1> {
  @override
  Widget build(BuildContext context) {
    final zstate = Provider.of<AppZoneStore>(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(flex: 2, child: zstate.widgetForZone("app1_sidebar")),
      Expanded(
        flex: 8,
        child: zstate.widgetForZone("app1_content"),
      ),
    ]);
  }
}

class App1 extends StatefulWidget {
  @override
  _App1State createState() => _App1State();
}
