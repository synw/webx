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
