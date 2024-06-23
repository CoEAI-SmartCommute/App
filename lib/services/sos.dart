import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:smart_commute/services/contacts.dart';
import 'package:smart_commute/var.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future sosFunction() async {
  await _sentSms();
  _callNumber();
}

_sentSms() async {
  final contacts = await fetchContacts();
  var longitude = 49.46800006494457;
  var latitude = 17.11514008755796;
  final  msg = "Alert from Saarthi, username send Emergency request. Here is there current Location https://www.google.com/maps/place/$longitude,$latitude";
  for (int i = 0; i < contacts.length; i++) {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: '${contacts[i]['number']}',
        message: msg);
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
