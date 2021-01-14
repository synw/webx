import 'dart:html' as html;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../zones/models.dart';
import '../zones/store.dart';
import 'route.dart';

final _router = FluroRouter();

/// The router
class WebxRouter {
  /// Provide the routes, the index widget and the zones store
  WebxRouter(
      {@required this.routes, @required this.index, @required this.store}) {
    _configureRoutes();
  }

  /// The zones store
  final AppZoneStore store;

  /// The index widget
  final Widget index;

  /// The user defined roues
  final List<WebxRoute> routes;

  /// The routes generator
  Route<dynamic> Function(RouteSettings routeSettings) get generator =>
      _router.generator;

  /// A method to navigate to a route
  Future<void> navigateTo(BuildContext context, String uri) async {
    // get the route
    print("MAtching route $uri");
    final r = _matchRoute(uri);
    print("Mathed route $r");
    if (r == null) {
      throw ArgumentError("Route $uri was not found");
    }
    if (store.state.currentAppId != r.appId) {
      print("Nav to full route");
      await _router.navigateTo(context, uri, transition: TransitionType.none);
    } else {
      print("Nav to local route");
      html.window.history.pushState(null, "", "#$uri");
      r.buildZones(context, uri, store);
    }
    store.state.currentAppId = r.appId;
  }

  /// Create some zones
  static Map<String, AppZone> createZonesMap(List<String> zoneNames,
      {String appName}) {
    final z = <String, AppZone>{};
    zoneNames.forEach((n) {
      var prefix = "";
      if (appName != null) {
        prefix = "${appName}_";
      }
      final name = prefix + n;
      z[name] = AppZone(name);
    });
    return z;
  }

  WebxRoute _matchRoute(String uri) {
    WebxRoute route;
    for (final r in routes) {
      if (r.url == "/") {
        continue;
      }
      print("R ${r.matcher} | $uri");
      if (uri.startsWith(r.matcher)) {
        route = r;
        break;
      }
    }
    return route;
  }

  void _configureRoutes() {
    for (final route in routes) {
      _router.define(route.url,
          handler: route.routeHandler(index, store),
          transitionType: TransitionType.none);
    }
    _router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return const Text("not found");
    });
  }
}
