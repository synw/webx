import 'package:webx/webx.dart';
import 'app1/zones.dart';
import 'topbar.dart';

final zones = <String, AppZone>{
  "main": AppZone("main"),
  "topbar": AppZone("topbar", widget: TopBar())
}..addAll(app1Zones);

final zStore = AppZoneStore(zones);
