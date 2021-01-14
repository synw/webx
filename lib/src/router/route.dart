import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';

import '../zones/models.dart';
import '../zones/store.dart';

/// A route
class WebxRoute {
  /// Base constructor
  WebxRoute(this.url, {@required this.builders, this.appId = "mainApp"})
      : assert(url != null),
        assert(builders.isNotEmpty, "Provide at least one builder") {
    _initSegments();
  }

  /// The route url
  final String url;

  /// The app that this route belongs to
  final String appId;

  /// The zone builders
  final List<ZoneBuilder> builders;

  /// Autocreated route _segments
  final _segments = <WebxRouteSegment>[];

  /// Autocreate route matcher
  String _startSequence;

  /// The first portion of the url to match
  String get matcher => _startSequence;

  /// Define the route handlers
  Handler routeHandler(Widget index, AppZoneStore store) {
    return Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      // read params
      final _params = <String, String>{};
      params.forEach((key, dynamic value) {
        _params[key] = params[key][0].toString();
      });
      // build zones
      builders.forEach((zoneBuilder) {
        store.update(zoneBuilder.zone, zoneBuilder.builder(context, _params));
      });
      store.state.currentAppId = appId;
      return index;
    });
  }

  /// Zones builder for internal nav
  void buildZones(BuildContext context, String uri, AppZoneStore store,
      {bool rebuildMain = false}) {
    final params = _readParamSegments(uri);
    print("Param segs for $uri: $params");
    builders.forEach((zoneBuilder) {
      if (zoneBuilder.alwaysBuild) {
        store.update(zoneBuilder.zone, zoneBuilder.builder(context, params));
      }
    });
  }

  Map<String, String> _readParamSegments(String uri) {
    final m = <String, String>{};
    final u = uri.split("/").sublist(1);
    _segments.forEach((s) {
      if (s.isParam) {
        m[s.name] = u[s.position];
      }
    });
    print("R seg $_segments");
    return m;
  }

  /// Get the url params
  void _initSegments() {
    if (url == "/") {
      return;
    }
    final s = url.split("/").sublist(1);
    var i = 0;
    var startSeq = "";
    var isStart = true;
    s.forEach((el) {
      var name = el;
      var isParam = false;
      if (el.startsWith(":")) {
        isStart = false;
        name = el.replaceFirst(":", "");
        isParam = true;
      }
      _segments.add(WebxRouteSegment(
        position: i,
        name: name,
        isParam: isParam,
      ));
      if (isStart) {
        startSeq += "/$name";
      }
      ++i;
    });
    _startSequence = startSeq;
    //print("Init seg $_segments");
  }

  @override
  String toString() {
    return url;
  }
}
