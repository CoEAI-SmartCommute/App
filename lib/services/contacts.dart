
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> fetchContacts() async {
  var currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> contactsList = [];

  if (currentUser != null) {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.displayName)
        .collection('friend_contacts')
        .get();

    contactsList = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
  return contactsList;
}
