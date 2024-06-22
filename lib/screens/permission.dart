import 'package:flutter/material.dart';
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
    setState(() {});
    if (_allPermissionsGranted) {
      _proceed();
    }
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
      }
    });

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    if (_allPermissionsGranted) {
      _proceed();
    }
  }

  bool get _allPermissionsGranted {
    return _locationGranted && _smsGranted && _callGranted;
  }

  void _proceed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All permissions granted. Welcome...')),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      minimumSize: const Size(250, 50), // Fixed button size
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _requestPermission(Permission.location);
              },
              style: _locationGranted
                  ? buttonStyle.copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.green))
                  : buttonStyle,
              child: const Text('Request Location Permission',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _requestPermission(Permission.sms);
              },
              style: _smsGranted
                  ? buttonStyle.copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.green))
                  : buttonStyle,
              child: const Text('Request SMS Permission',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _requestPermission(Permission.phone);
              },
              style: _callGranted
                  ? buttonStyle.copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.green))
                  : buttonStyle,
              child: const Text('Request Call Permission',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 100),
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
              child:
                  const Text('Proceed', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
