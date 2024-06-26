import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';

class SaveLocationScreen extends StatefulWidget {
  const SaveLocationScreen({super.key});

  @override
  SaveLocationScreenState createState() => SaveLocationScreenState();
}

class SaveLocationScreenState extends State<SaveLocationScreen> {
  late MapController controller;
  GeoPoint? selectedPoint;
  Location location = Location();

  Future<void> _updateUserLocation() async {
    var userLocation = await location.getLocation();
    GeoPoint newLocation = GeoPoint(
      latitude: userLocation.latitude!,
      longitude: userLocation.longitude!,
    );
    controller.changeLocation(newLocation);
    controller.setZoom(zoomLevel: 14);
  }

  @override
  void initState() {
    super.initState();
    controller =
        MapController(initPosition: GeoPoint(latitude: 20.5, longitude: 79));

    _updateUserLocation();

    controller.listenerMapSingleTapping.addListener(() async {
      GeoPoint? point = controller.listenerMapSingleTapping.value;
      if (point != null) {
        setState(() {
          selectedPoint = point;
          // print(
          //     'You clicked on ${selectedPoint!.latitude}, ${selectedPoint!.longitude}');
        });
        controller.changeLocation(selectedPoint!);
      }
    });
  }

  @override
  void dispose() {
    controller.listenerMapSingleTapping.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Location'),
      ),
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
              markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                    ),
                  )),
              userTrackingOption: const UserTrackingOption(
                  enableTracking: false, unFollowUser: true),
              zoomOption: const ZoomOption(
                initZoom: 8,
                minZoomLevel: 2,
                maxZoomLevel: 18,
                stepZoom: 1,
              ),
              showZoomController: true,
              showDefaultInfoWindow: true,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 36,
              ),
              child: IconButton(
                onPressed: _updateUserLocation,
                icon: Icon(FontAwesomeIcons.locationCrosshairs,
                    color: Theme.of(context).colorScheme.primary),
                style: IconButton.styleFrom(
                  minimumSize: const Size(50, 50),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
