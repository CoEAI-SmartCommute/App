import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_commute/screens/home.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  PermissionScreenState createState() => PermissionScreenState();
}

class PermissionScreenState extends State<PermissionScreen> {
  bool _locationGranted = false;
  bool _smsGranted = false;
  bool _callGranted = false;
  bool _notifiGranted = false;
  final Location _locationService = Location();
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await _locationService.serviceEnabled();
    await _locationService.requestService();
    _locationGranted = await Permission.location.isGranted;
    _smsGranted = await Permission.sms.isGranted;
    _callGranted = await Permission.phone.isGranted;
    _notifiGranted = await Permission.notification.isGranted;
    setState(() {});
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    setState(() {
      if (permission == Permission.location) {
        _locationGranted = status.isGranted;
      } else if (permission == Permission.sms) {
        _smsGranted = status.isGranted;
      } else if (permission == Permission.phone) {
        _callGranted = status.isGranted;
      } else if (permission == Permission.notification) {
        _notifiGranted = status.isGranted;
      }
    });

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  bool get _allPermissionsGranted {
    return _locationGranted && _smsGranted && _callGranted && _notifiGranted;
  }

  void _proceed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  permissionCard(FontAwesomeIcons.mapLocation, 'Location',
                      Permission.location, _locationGranted),
                  permissionCard(FontAwesomeIcons.phone, 'Calls',
                      Permission.phone, _callGranted),
                  permissionCard(FontAwesomeIcons.commentSms, 'Messaging',
                      Permission.sms, _smsGranted),
                  permissionCard(FontAwesomeIcons.bell, 'Notifications',
                      Permission.notification, _notifiGranted),
                ],
              ),
              ElevatedButton(
                onPressed: _allPermissionsGranted ? _proceed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _allPermissionsGranted ? Colors.blue : Colors.grey,
                  minimumSize: const Size(250, 50), // Fixed button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text('Proceed',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget permissionCard(
    IconData icon,
    String title,
    dynamic service,
    bool isGranted,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              MaterialButton(
                elevation: 0,
                onPressed: () async {
                  await _requestPermission(service);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: isGranted ? Colors.green : const Color(0xffd9d9d9),
                child:
                    isGranted ? const Icon(Icons.check) : const Text('Allow'),
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
