import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:smart_commute/components/savelocation/savelocform.dart';
import 'package:smart_commute/services/getstatecity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cfs;

class SaveLocationScreen extends StatefulWidget {
  const SaveLocationScreen({super.key});

  @override
  SaveLocationScreenState createState() => SaveLocationScreenState();
}

class SaveLocationScreenState extends State<SaveLocationScreen> {
  final MapController _mapController =
      MapController(initPosition: GeoPoint(latitude: 20.5, longitude: 79));

  GeoPoint? selectedPoint;
  Location location = Location();
  String selectedCity = 's';
  String selectedState = 's';

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

    _updateUserLocation();

    _mapController.listenerMapSingleTapping.addListener(() async {
      GeoPoint? point = _mapController.listenerMapSingleTapping.value;
      Map<String, String> resp =
          await getCityAndState(point!.latitude, point.longitude);
      print(resp);
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
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const Text('Your Location'),
            SizedBox(
              height: 300,
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
                          minimumSize: const Size(25, 25),
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
            const Text(
              'Pinned Location',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: const Color(0xffEEEEEE),
                    borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text(
                  selectedPoint == null
                      ? 'Please select a point'
                      : '${selectedPoint!.latitude} , ${selectedPoint!.longitude}',
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SaveLocForm(
                        state: selectedState,
                        city: selectedCity,
                        point: cfs.GeoPoint(
                            selectedPoint!.latitude, selectedPoint!.longitude),
                      );
                    },
                  );
                },
                child: const Text('Add Address'))
          ],
        ),
      ),
    );
  }
}
