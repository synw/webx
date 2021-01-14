import 'dart:html' as html;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'route.dart';
import '../zones/models.dart';
import '../zones/store.dart';

final _router = FluroRouter();

/// A web app with subroutes
class WebxApp {
  /// Basic constructor
  WebxApp(
      {@required this.name,
      @required this.builder,
      this.zone = "main",
      this.url,
      this.routes = const <WebxRoute>[]}) {
    url ??= "/$name";
    _initRoutes();
    print(routes);
  }

  /// The app name
  final String name;

  /// The app's main widget builder
  final WidgetBuilder builder;

  /// The zone where this app is located
  final String zone;

  /// The app url: will be /[name] if not provided
  String url;

  /// The app routes
  List<WebxRoute> routes;

  /// The main route for the app
  WebxRoute get _mainRoute => WebxRoute(url, builders: <ZoneBuilder>[
        ZoneBuilder(
            zone: zone,
            alwaysBuild: true,
            builder: (BuildContext context, Map<String, String> params) {
              return builder(context);
            })
      ]);

  void _initRoutes() {
    routes = routes
        .map(
            (r) => WebxRoute(url + r.url, appId: r.appId, builders: r.builders))
        .toList()
          ..add(_mainRoute);
  }
}

/// The router
class WebxRouter {
  /// Provide the index widget and the zones store
  WebxRouter(
      {@required this.index,
      @required this.store,
      this.routes = const <WebxRoute>[],
      this.apps = const <WebxApp>[]}) {
    _configureRoutes();
  }

  /// The Webx apps
  final List<WebxApp> apps;

  /// The zones store
  final AppZoneStore store;

  /// The index widget
  final Widget index;

  /// The user defined roues
  List<WebxRoute> routes;

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
      print(
          "R '$uri' $r : m=${r.matcher} | ${r.nSegments} ${uri.split("/").sublist(1).length}");
      if (uri.startsWith(r.matcher)) {
        if (r.nSegments == uri.split("/").sublist(1).length) {
          print("Found route $r");
          route = r;
          break;
        }
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
    for (final app in apps) {
      routes.addAll(app.routes);
      // app subroutes
      for (final route in app.routes) {
        _router.define(route.url,
            handler: route.routeHandler(index, store),
            transitionType: TransitionType.none);
      }
      _router.notFoundHandler = Handler(handlerFunc:
          (BuildContext context, Map<String, List<String>> params) {
        print("ROUTE WAS NOT FOUND !!!");
        return const Text("not found");
      });
    }
  }
}
