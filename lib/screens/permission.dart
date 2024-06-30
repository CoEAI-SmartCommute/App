import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_commute/screens/home.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

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
    _locationGranted = await Permission.location.isGranted;
    _smsGranted = await Permission.sms.isGranted;
    _callGranted = await Permission.phone.isGranted;
    _notifiGranted = await Permission.notification.isGranted;

    if (_locationGranted) {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      await _locationService.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
      );
    }
    // await _requestPermissionForAndroid();
    setState(() {});
  }

  // Future<void> _requestPermissionForAndroid() async {
  //   if (!Platform.isAndroid) {
  //     return;
  //   }

  //   // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  //   // onNotificationPressed function to be called.
  //   //
  //   // When the notification is pressed while permission is denied,
  //   // the onNotificationPressed function is not called and the app opens.
  //   //
  //   // If you do not use the onNotificationPressed or launchApp function,
  //   // you do not need to write this code.
  //   if (!await FlutterForegroundTask.canDrawOverlays) {
  //     // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
  //     await FlutterForegroundTask.openSystemAlertWindowSettings();
  //   }

  //   // Android 12 or higher, there are restrictions on starting a foreground service.
  //   //
  //   // To restart the service on device reboot or unexpected problem, you need to allow below permission.
  //   if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
  //     // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
  //     await FlutterForegroundTask.requestIgnoreBatteryOptimization();
  //   }

  //   // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
  //   final NotificationPermission notificationPermissionStatus =
  //       await FlutterForegroundTask.checkNotificationPermission();
  //   if (notificationPermissionStatus != NotificationPermission.granted) {
  //     await FlutterForegroundTask.requestNotificationPermission();
  //   }
  // }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      if (permission == Permission.location) {
        _locationGranted = status.isGranted;
      }
      if (permission == Permission.sms) {
        _smsGranted = status.isGranted;
      }
      if (permission == Permission.phone) {
        _callGranted = status.isGranted;
      }
      if (permission == Permission.notification) {
        _notifiGranted = status.isGranted;
      }
    });

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  bool get _allPermissionsGranted {
    return _locationGranted && _smsGranted && _callGranted;
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
    Permission permission,
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
                  if (!isGranted) await _requestPermission(permission);
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
