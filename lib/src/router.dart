import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'zones/store.dart';

final _router = FluroRouter();

/// A method to navigate to a route
void navigateTo(BuildContext context, String route) {
  _router.navigateTo(context, route, transition: TransitionType.none);
}

/// A base route
class WebxRoute {
  /// Provide an url and a handler
  const WebxRoute(this.url, {@required this.handler})
      : zone = null,
        widgetBuilder = null;

  /// Route to update a given zone
  const WebxRoute.toZone(this.url,
      {@required this.zone, @required this.widgetBuilder, this.handler});

  /// The route url
  final String url;

  /// The zone for the route
  final String zone;

  /// The route widget builder
  final WidgetBuilder widgetBuilder;

  /// The route handler
  final void Function(BuildContext, Map<String, dynamic>) handler;

  /// Define the route handler
  Handler routeHandler(Widget index, AppZoneStore store) {
    return Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      if (zone != null) {
        store.update(zone, widgetBuilder(context));
      }
      if (handler != null) {
        handler(context, params);
      }
      return index;
    });
  }
}

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

  void _configureRoutes() {
    _router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return const Text("not found");
    });
    for (final route in routes) {
      _router.define(route.url,
          handler: route.routeHandler(index, store),
          transitionType: TransitionType.none);
    }
  }
}
