import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/components/home/homeoptionbutton.dart';
import 'package:smart_commute/providers/location_provider.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  HomeMapState createState() => HomeMapState();
}

class HomeMapState extends State<HomeMap> {
  late MapController mapController;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initMapWithUserPosition: const UserTrackingOption(enableTracking: true),
    );
    _checkPermissions();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _updateUserLocation();
  }

  Future<void> _updateUserLocation() async {
    var userLocation = await location.getLocation();
    GeoPoint newLocation = GeoPoint(
      latitude: userLocation.latitude!,
      longitude: userLocation.longitude!,
    );
    mapController.changeLocation(newLocation);
    mapController.setZoom(zoomLevel: 14);
    if (mounted) {
      context.read<LocationProvider>().updateCurrentLocation(
            location: newLocation,
          );
    }
  }

  void reloadMap() async {
    await _updateUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            osmOption: const OSMOption(
                zoomOption: ZoomOption(
                    initZoom: 3,
                    minZoomLevel: 5,
                    maxZoomLevel: 19,
                    stepZoom: 1.0),
                userTrackingOption: UserTrackingOption(enableTracking: true)),
            controller: mapController,
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: HomeOptionButton(
                  onPressed: reloadMap,
                ),
              )),
        ],
      ),
    );
   }
}
