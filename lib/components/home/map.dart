import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as back_sms;
import 'package:provider/provider.dart';
import 'package:smart_commute/Theme/theme.dart';
import 'package:smart_commute/providers/location_provider.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  late MapController _mapController;
  // LocationData? _currentLocation;
  final Location _locationService = Location();
  bool _liveUpdate = true;
  bool _permission = false;
  String? _serviceError = '';

  @override
  void initState() {
    initLocationService();
    initSmsService();
    _mapController = MapController();
    super.initState();
  }

  void initSmsService() async {
    var status = await back_sms.Permission.sms.status;

    if (status.isDenied) {
      await back_sms.Permission.sms.request();
    }
  }

  void initLocationService() async {
    final permission = await _locationService.requestPermission();
    _permission = permission == PermissionStatus.granted;

    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        // final permission = await _locationService.requestPermission();
        // _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          if (!mounted) return;
          context
              .read<LocationProvider>()
              .updateCurrentLocation(location: location);
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              context
                  .read<LocationProvider>()
                  .updateCurrentLocation(location: result);

              if (_liveUpdate) {
                _mapController.move(
                    LatLng(
                        context
                            .watch<LocationProvider>()
                            .currentLocation!
                            .latitude!,
                        context
                            .watch<LocationProvider>()
                            .currentLocation!
                            .longitude!),
                    15);
              }
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = Provider.of<LocationProvider>(context);
    LatLng currentLatLng;
    if (currentLocationProvider.currentLocation != null) {
      currentLatLng = LatLng(currentLocationProvider.currentLocation!.latitude!,
          currentLocationProvider.currentLocation!.longitude!);
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
