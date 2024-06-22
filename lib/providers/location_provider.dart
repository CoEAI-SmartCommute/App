import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  LocationData? currentLocation;

  // LocationProvider({this.currentLocation=null});
  void updateCurrentLocation({required LocationData location}) async {
    currentLocation = location;
    notifyListeners();
  }
}
