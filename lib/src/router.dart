import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'zones/store.dart';

final _router = FluroRouter();

void navigateTo(BuildContext context, String route) {
  _router.navigateTo(context, route, transition: TransitionType.none);
}

class WebxRoute {
  const WebxRoute(this.url, {@required this.handler})
      : zone = null,
        widgetBuilder = null;

  const WebxRoute.toZone(this.url,
      {@required this.zone, @required this.widgetBuilder, this.handler});

  final String url;
  final String zone;
  final WidgetBuilder widgetBuilder;
  final void Function(BuildContext, Map<String, dynamic>) handler;

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

class WebxRouter {
  WebxRouter(
      {@required this.routes, @required this.index, @required this.store}) {
    _configureRoutes();
  }

  final AppZoneStore store;

  final Widget index;

  final List<WebxRoute> routes;

  Route<dynamic> Function(RouteSettings routeSettings) get generator =>
      _router.generator;

  void _configureRoutes() {
    _router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return Text("not found");
    });
    for (final route in routes) {
      _router.define(route.url,
          handler: route.routeHandler(index, store),
          transitionType: TransitionType.none);
    }
  }
}
