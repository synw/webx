import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';
import 'state.dart';

/// The app zones state
///
/// Use this when you want to access the app zones
/// state without a context
final AppZoneState appZoneState = AppZoneState();

final _appZoneStateUpdateController = StreamController<AppZoneStore>();

/// The state updates stream
Stream<AppZoneStore> appZoneStateStream = _appZoneStateUpdateController.stream;

/// The function to update a zone with a new widget
void updateAppZone(AppZone zone, Widget widget) =>
    _appZoneStateUpdateController.sink
        .add(AppZoneStore.updateZone(zone, widget));

/// The store that manage state mutations
class AppZoneStore {
  /// Main constructor
  AppZoneStore(Map<String, AppZone> zones) {
    _init(zones);
  }

  /// The store update constructor
  AppZoneStore.updateZone(AppZone zone, Widget widget) {
    print("Update app zone $zone $widget");
    state.zones[zone.name].widget = widget;
  }

  /// The zones state
  final AppZoneState state = appZoneState;

  /// Initialize the store: run this before using
  void _init(Map<String, AppZone> zones) {
    assert(zones != null);
    assert(zones.isNotEmpty);
    //print("Initializing app zones");
    state.zones = zones;
    //print("Appzones initialized");
  }

  /// Access the current widget of a zone
  Widget widgetForZone(String name) {
    return state.zones[name].widget;
  }

  /// The main update function
  void update(String name, Widget widget) {
    AppZone zone;
    zone = state.zones[name];
    assert(zone != null, "Did not find zone $name");
    //print("Updating zone $name");
    updateAppZone(zone, widget);
  }

  /// The stream of zones change
  static Stream<AppZoneStore> stream() {
    return _appZoneStateUpdateController.stream;
  }
}
