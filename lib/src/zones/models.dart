import 'package:flutter/material.dart';
import '../types.dart';

class WebxRouteSegment {
  const WebxRouteSegment(
      {@required this.position, @required this.name, @required this.isParam});

  final int position;
  final String name;
  final bool isParam;

  @override
  String toString() {
    return "$position $name $isParam";
  }
}

/// The main app zone class
class AppZone {
  /// Provide a name and an initial widget
  AppZone(this.name, {this.widget = const Text("")});

  /// The name of the zone
  final String name;

  /// The initial widget to populate the zone with
  Widget widget;

  @override
  String toString() => name;
}

/// An app zone to build on route hit
class ZoneBuilder {
  /// Default constructor
  ZoneBuilder(
      {@required this.zone, @required this.builder, this.alwaysBuild = false});

  /// The zone to build in
  final String zone;

  /// The widget rebuilder
  final StringParamsWidgetBuilder builder;

  /// Always rebuild the zone on internal route
  final bool alwaysBuild;
}
