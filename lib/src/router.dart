import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:webx/src/zones/models.dart';
import 'package:webx/webx.dart';

import 'zones/store.dart';

final _router = FluroRouter();

/// A method to navigate to a route
Future<void> navigateTo(BuildContext context, String route) async {
  appZoneState.isLoaded = true;
  await _router.navigateTo(context, route, transition: TransitionType.none);
}

/// A base route
class WebxRoute {
  /// Route to update a given zone
  const WebxRoute(this.url,
      {@required this.zone,
      @required this.widgetBuilder,
      this.handler,
      this.zonesBuilder})
      : redirectUrl = null;

  /// Provide an url and a handler
  const WebxRoute.withHandler(this.url,
      {@required this.handler, this.zonesBuilder})
      : zone = null,
        widgetBuilder = null,
        redirectUrl = null;

  const WebxRoute.redirect(this.url, this.redirectUrl)
      : zone = null,
        widgetBuilder = null,
        zonesBuilder = null,
        handler = null;

  /// The route url
  final String url;

  final String redirectUrl;

  /// The zone for the route
  final String zone;

  /// The route widget builder
  final WidgetBuilder widgetBuilder;

  /// The route handler
  final void Function(BuildContext, Map<String, dynamic>) handler;

  final List<ZoneBuilder> zonesBuilder;

  /// Define the route handler
  Handler routeHandler(Widget index, AppZoneStore store) {
    return Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      final isLocalRoute = store.state.isLoaded;
      print("Route handler $params, IS LOCAL ROUTE: $isLocalRoute");
      if (zonesBuilder == null || !isLocalRoute) {
        print("BUILDING WIDGET FOR ZONE $zone");
        store.update(zone, widgetBuilder(context));
      } else {
        print("NOT BUILDING WIDGET FOR ZONE $zone");
      }
      if (handler != null) {
        handler(context, params);
      }
      if (zonesBuilder != null) {
        zonesBuilder.forEach((zoneBuilder) {
          var buildZone = true;
          // always build all from direct routes
          if (isLocalRoute) {
            if (!zoneBuilder.alwaysBuild) {
              buildZone = false;
            }
          }
          print("Zone ${zoneBuilder.zone}: $buildZone");
          if (buildZone) {
            store.update(
                zoneBuilder.zone, zoneBuilder.builder(context, params));
          }
        });
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
    for (final route in routes) {
      if (route.redirectUrl == null) {
        _router.define(route.url,
            handler: route.routeHandler(index, store),
            transitionType: TransitionType.none);
      } else {
        final r = routes.firstWhere((_r) => _r.url == route.redirectUrl);
        if (r == null) {
          throw Exception(
              "Null redirect route ${route.url} ${route.redirectUrl}");
        }
        print("Redirect route ${route.url} ${route.redirectUrl}");
        _router.define(route.url,
            handler: r.routeHandler(index, store),
            transitionType: TransitionType.none);
      }
    }
    _router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return const Text("not found");
    });
  }
}
