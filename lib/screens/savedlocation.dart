import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:smart_commute/components/savelocation/savedlocwidget.dart';
import 'package:smart_commute/components/savelocation/savelocform.dart';
import 'package:smart_commute/components/toast/toast.dart';
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

    Map<String, String> resp =
        await getCityAndState(newLocation.latitude, newLocation.longitude);
    setState(() {
      selectedPoint = newLocation;
      selectedCity = resp['city']!;
      selectedState = resp['state']!;
    });
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Save Location', style: TextStyle(fontSize: 20)),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
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
                                  horizontal: 25,
                                  vertical: 25,
                                ),
                                child: IconButton(
                                  onPressed: _updateUserLocation,
                                  icon: Icon(
                                      FontAwesomeIcons.locationCrosshairs,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(25, 25),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Pinned Location',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text(
                        selectedPoint == null
                            ? 'Please select a point'
                            : '${selectedPoint!.latitude} , ${selectedPoint!.longitude}',
                      ),
                    ),
                    const SavedList(
                      isAdd: false,
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.tertiary,
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            elevation: const MaterialStatePropertyAll(0),
                          ),
                          onPressed: () async {
                            if (selectedPoint == null) {
                              errorToast("Please mark a point on the map");
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SaveLocForm(
                                  state: selectedState,
                                  city: selectedCity,
                                  point: cfs.GeoPoint(selectedPoint!.latitude,
                                      selectedPoint!.longitude),
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Ionicons.save,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text('Add Address',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CustomLocButton extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomLocButton({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              color: Colors.blue,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(60, 60),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Add',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }
}

class AddLocButton extends StatelessWidget {
  const AddLocButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SaveLocationScreen(),
                ),
              );
            },
            icon: const Icon(
              Ionicons.add,
              color: Colors.blue,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(60, 60),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Text(
            'Add',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.tertiary,
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevation: const MaterialStatePropertyAll(0),
        ),
        onPressed: () async {
          // Implement your saving functionality here
        },
        icon: Icon(
          Ionicons.save,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: Text('Add Address',
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }
}
