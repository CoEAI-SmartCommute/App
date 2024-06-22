import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:smart_commute/Theme/theme.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  late MapController _mapController;
  LocationData? _currentLocation;
  final Location _locationService = Location();
  final bool _liveUpdate = true;

  @override
  void initState() {
    initLocationService();
    _mapController = MapController();
    super.initState();
  }

  void initLocationService() async {
    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        location = await _locationService.getLocation();
        _currentLocation = location;
        _locationService.onLocationChanged.listen((LocationData result) async {
          if (mounted) {
            setState(() {
              _currentLocation = result;

              // If Live Update is enabled, move map center
              if (_liveUpdate) {
                _mapController.move(
                    LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    15);
              }
            });
          }
        });
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = const LatLng(0, 0);
    }

    MarkerLayer markerLayer() => MarkerLayer(
          markers: [
            Marker(
              point: LatLng(currentLatLng.latitude, currentLatLng.longitude),
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Icon(
                Icons.circle,
                size: MediaQuery.of(context).size.width * 0.04,
                color: appTheme.colorScheme.primary,
              ),
            )
          ],
        );

    return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter:
              LatLng(currentLatLng.latitude, currentLatLng.longitude),
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          markerLayer()
        ]);
  }
}
