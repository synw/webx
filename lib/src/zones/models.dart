import 'package:flutter/material.dart';

/// The main app zone class
class AppZone {
  /// Provide a name and an initial widget
  AppZone(this.name, {this.widget = const Text("")});

  /// The name of the zone
  final String name;

  /// The initial widget to populate the zone with
  Widget widget;
}

class ZoneBuilder {
  ZoneBuilder({@required this.zone, @required this.builder});

  final String zone;
  final Widget Function(BuildContext, Map<String, dynamic>) builder;
}
