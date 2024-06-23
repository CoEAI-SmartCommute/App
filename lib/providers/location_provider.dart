import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationProvider extends ChangeNotifier {
  GeoPoint? currentLocation;

  // LocationProvider({this.currentLocation=null});
  void updateCurrentLocation({required GeoPoint location}) async {
    currentLocation = location;
    notifyListeners();
  }
}
