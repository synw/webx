import 'models.dart';

/// The class that holds the zones state
class AppZoneState {
  /// All the zones
  Map<String, AppZone> zones = <String, AppZone>{};

  /// App state for links handling
  bool isLoaded = false;
}
