import 'package:background_sms/background_sms.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:smart_commute/var.dart';

Future sosFunction() async {
  await _sentSms();
  _callNumber();
}

_sentSms() async {
  List<String> helper = [
    "9022968752",
    // "8600282934",
    "6367222166",
    "7878018845"
  ];
  var longitude = 49.46800006494457;
  var latitude = 17.11514008755796;
  for (int i = 0; i < helper.length; i++) {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: helper[i],
        message:
            "Alert from Saarthi, Username send Emergency request. Here is there current Location https://www.google.com/maps/place/$longitude,$latitude");
    if (result == SmsStatus.sent) {
      // print("Sent");
    } else {
      // print("Failed");
    }
  }
}

_callNumber() async {
  await FlutterPhoneDirectCaller.callNumber(emergencyNumber);
}
