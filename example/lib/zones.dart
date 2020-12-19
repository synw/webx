import 'package:webx/webx.dart';
import 'package:flutter/widgets.dart';

final List<AppZone> zones = <AppZone>[
  AppZone("main"),
  AppZone("sidebar", widget: Text("SIDE")),
  AppZone("topBar", widget: Text("TOP")),
];

final zStore = AppZoneStore(zones);
