import 'package:webx/webx.dart';
import 'package:flutter/widgets.dart';

final zones = <String, AppZone>{
  "main": AppZone("main"),
  "sidebar": AppZone("sidebar", widget: const Text("SIDE")),
  "topBar": AppZone("topBar", widget: const Text("TOP")),
  "bottom": AppZone("bottom", widget: const Text("BOTTOM"))
};

final zStore = AppZoneStore(zones);
