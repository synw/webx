import 'package:flutter/material.dart';
import 'package:webx/webx.dart';

import 'app1/index.dart';
import 'app1/sidebar.dart';
import 'index.dart';
import 'zones.dart';

final router = WebxRouter(
  index: Index(),
  store: zStore,
  routes: <WebxRoute>[
    WebxRoute("/", builders: <ZoneBuilder>[
      ZoneBuilder(
          zone: "main",
          builder: (BuildContext context, Map<String, String> params) {
            return Column(children: [
              const Text("Main widget"),
              RaisedButton(
                  child: const Text("App 1"),
                  onPressed: () => router.navigateTo(context, "/app1")),
              RaisedButton(
                  child: const Text("App 2"),
                  onPressed: () => router.navigateTo(context, "/app2")),
            ]);
          })
    ]),
    WebxRoute("/app1/:category", appId: "app1", builders: <ZoneBuilder>[
      ZoneBuilder(
          zone: "main",
          builder: (BuildContext context, Map<String, String> params) {
            return App1();
          }),
      ZoneBuilder(
          zone: "app1_sidebar",
          alwaysBuild: true,
          builder: (BuildContext context, Map<String, String> params) {
            return App1Sidebar(category: params["category"]);
          })
    ])
  ],
);
