import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:smart_commute/var.dart';

Future sosFunction() async {
  _callNumber();
}

_callNumber() async {
  await FlutterPhoneDirectCaller.callNumber(emergencyNumber);
}
