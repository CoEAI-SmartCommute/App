import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

class ForegroundTaskInitializer {
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.DEFAULT,
        priority: NotificationPriority.DEFAULT,
        iconData: const NotificationIconData(
          resType: ResourceType.drawable,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
    );
  }

  static void startForegroundTask() {
    FlutterForegroundTask.startService(
      notificationTitle: 'Navigation Running',
      notificationText: 'Your navigation is active in the background.',
      callback: startCallback,
    );
  }

  static void stopForegroundTask() {
    FlutterForegroundTask.stopService();
  }

  static void startCallback() {
    FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
  }
}

class LocationTaskHandler implements TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // Initialize location updates
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) {
      // Handle the location update
      print('Current Position: ${position.latitude}, ${position.longitude}');
      // You can also send the updated position to the main isolate using sendPort
    });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // No-op: We are handling location updates directly in onStart
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Clean up resources
  }

  @override
  void onButtonPressed(String id) {
    // Handle notification button press if needed
  }

  @override
  void onNotificationPressed() {
    // Handle notification press if needed
  }

  @override
  void onNotificationButtonPressed(String id) {
    // TODO: implement onNotificationButtonPressed
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onRepeatEvent
  }
}
