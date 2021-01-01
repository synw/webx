# Webx

Routing and layout management for Flutter web. Define some zones in your app layout and update them
from routes

## Usage

### Layout

Define some zones in your app. In zones.dart:

```dart
import 'package:webx/webx.dart';
import 'package:flutter/widgets.dart';

final zones = <String, AppZone>{
  "main": AppZone("main"),
  "sidebar": AppZone("sidebar", widget: const Text("SIDE")),
  "topBar": AppZone("topBar", widget: const Text("TOP"))
};

final zStore = AppZoneStore(zones);
```

Create an index wiget using your zones. In index.dart:

```dart
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
                zstate.widgetForZone("topBar"),
                Expanded(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                                child: zstate.widgetForZone("sidebar"))),
                        Expanded(
                          flex: 8,
                          child: SingleChildScrollView(
                              child: zstate.widgetForZone("main")),
                        ),
                      ]),
                ),
              ],
            )));
  }
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}
```

### Routes

Define your routes and their behavior. In router.dart:

```dart
import 'package:flutter/material.dart';
import 'package:webx/webx.dart';

import 'index.dart';
import 'zones.dart';

final router = WebxRouter(index: Index(), store: zStore, routes: <WebxRoute>[
  WebxRoute("/",
      zone: "main",
      widgetBuilder: (BuildContext context) => Container(
            child: Column(children: [
              Text("Main widget"),
              RaisedButton(
                  child: Text("Page 2"),
                  onPressed: () => navigateTo(context, "/page2"))
            ]),
          )),
  WebxRoute.withHandler(
    "/page2",
    handler: (BuildContext context, Map<String, dynamic> params) {
        // manual zone update
      zStore.update("main", Text("Page 2 route"));
    },
  ),
]);
```

### Main app

Plug it on your main app. In main.dart:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webx/webx.dart';

import 'router.dart';
import 'zones.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppZoneStore>.value(
            initialData: zStore, value: appZoneStateStream),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Webx',
          onGenerateRoute: router.generator),
    );
  }
}
```