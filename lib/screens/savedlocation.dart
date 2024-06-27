import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:smart_commute/services/getstatecity.dart';
import 'package:group_button/group_button.dart';

class SaveLocationScreen extends StatefulWidget {
  const SaveLocationScreen({super.key});

  @override
  SaveLocationScreenState createState() => SaveLocationScreenState();
}

class SaveLocationScreenState extends State<SaveLocationScreen> {
  late MapController _mapController;
  GeoPoint? selectedPoint;
  Location location = Location();
  String selectedCity = '';
  String selectedState = '';
  

  Future<void> _updateUserLocation() async {
    var userLocation = await location.getLocation();
    GeoPoint newLocation = GeoPoint(
      latitude: userLocation.latitude!,
      longitude: userLocation.longitude!,
    );
    _mapController.changeLocation(newLocation);
    _mapController.setZoom(zoomLevel: 14);
  }

  @override
  void initState() {
   
    super.initState();
    _mapController =
        MapController(initPosition: GeoPoint(latitude: 20.5, longitude: 79));

    _updateUserLocation();

    _mapController.listenerMapSingleTapping.addListener(() async {
      GeoPoint? point = _mapController.listenerMapSingleTapping.value;
      Map<String, String> resp =
          await getCityAndState(point!.latitude, point.longitude);

      setState(() {
        selectedPoint = point;
        selectedCity = resp['city']!;
        selectedState = resp['state']!;
      });
      _mapController.changeLocation(selectedPoint!);
    });
  }

  @override
  void dispose() {
    _mapController.listenerMapSingleTapping.removeListener(() {});
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Location'),
      ),
      body: Column(
        children: [
          const Text('Your Location'),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                OSMFlutter(
                  controller: _mapController,
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
                        minimumSize: const Size(30, 30),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          
        ],
      ),
    );
  }
}

