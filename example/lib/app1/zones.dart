import 'package:webx/webx.dart';

import 'content.dart';
import 'sidebar.dart';

final app1Zones = <String, AppZone>{
  "app1_sidebar":
      AppZone("app1_sidebar", widget: const App1Sidebar(category: null)),
  "app1_content":
      AppZone("app1_content", widget: const App1Content(category: null))
};
