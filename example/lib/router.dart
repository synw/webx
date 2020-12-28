import 'package:flutter/material.dart';
import 'package:webx/webx.dart';

import 'index.dart';
import 'zones.dart';

final router = WebxRouter(index: Index(), store: zStore, routes: <WebxRoute>[
  WebxRoute.toZone("/",
      zone: "main",
      widgetBuilder: (BuildContext context) => Container(
            child: Column(children: [
              const Text("Main widget"),
              RaisedButton(
                  child: const Text("Page 2"),
                  onPressed: () => navigateTo(context, "/page2"))
            ]),
          )),
  WebxRoute(
    "/page2",
    handler: (BuildContext context, Map<String, dynamic> params) {
      zStore.update("main", const Text("Page 2 route"));
    },
  ),
]);
