import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissions() async {
  final Location locationService = Location();
  await locationService.serviceEnabled();
  await locationService.requestService();
  bool locationGranted = await Permission.location.isGranted;
  bool smsGranted = await Permission.sms.isGranted;
  bool callGranted = await Permission.phone.isGranted;
  bool notifiGranted = await Permission.notification.isGranted;
  return locationGranted && smsGranted && callGranted && notifiGranted;
}
