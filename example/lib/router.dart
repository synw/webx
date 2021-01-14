import 'package:flutter/material.dart';
import 'package:webx/webx.dart';

import 'app1/content.dart';
import 'app1/index.dart';
import 'app1/sidebar.dart';
import 'app2/index.dart';
import 'index.dart';
import 'zones.dart';

final router = WebxRouter(index: Index(), store: zStore, routes: <WebxRoute>[
  WebxRoute("/", builders: <ZoneBuilder>[
    ZoneBuilder(
        zone: "main",
        builder: (BuildContext context, Map<String, String> params) {
          return const Text("Main widget");
        })
  ])
], apps: <WebxApp>[
  WebxApp(name: "app1", builder: (context) => App1(), routes: <WebxRoute>[
    WebxRoute("/:category", builders: <ZoneBuilder>[
      ZoneBuilder(
          zone: "app1_sidebar",
          alwaysBuild: true,
          builder: (BuildContext context, Map<String, String> params) {
            return App1Sidebar(category: params["category"], key: UniqueKey());
          }),
      ZoneBuilder(
          zone: "app1_content",
          alwaysBuild: true,
          builder: (BuildContext context, Map<String, String> params) {
            return App1Content(category: params["category"], key: UniqueKey());
          }),
    ])
  ]),
  WebxApp(name: "app2", builder: (context) => App2())
]);
