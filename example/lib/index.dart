import 'package:provider/provider.dart';
import 'package:webx/webx.dart';
import 'package:flutter/material.dart';

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    final zstate = Provider.of<AppZoneStore>(context);
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                zstate.widgetForZone("topbar"),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 80.0,
                  child: zstate.widgetForZone("main"),
                ),
              ],
            )));
  }
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}
