import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserData extends StatelessWidget {
  const UserData({super.key});

  User? get user => FirebaseAuth.instance.currentUser;

  Future<Map<String, String?>> getCurrentUserData() async {
    try {
      String? currentUserUid = user?.uid;

      if (currentUserUid == null) {
        throw Exception('No user is currently logged in');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }

      final userData = userDoc.data();

      return {
        'displayName': userData?['fullName'] as String?,
        'email': userData?['email'] as String?,
        'phoneNumber': userData?['phone'] as String?,
      };
    } catch (e) {
      print('Error retrieving user data: $e');
      return {
        'displayName': null,
        'email': null,
        'phoneNumber': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: getCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final userData = snapshot.data ?? {};

        return Column(
          children: [
            Hero(
              tag: 'profileImage',
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user?.photoURL ??
                      const Icon(Ionicons.person_circle).toString(),
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Ionicons.person_circle),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userData['displayName'] ?? user?.displayName ?? 'User Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userData['email'] ?? user?.email ?? 'user@xyyz.com',
              style: const TextStyle(
                fontSize: 15,
                decorationColor: Colors.grey,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userData['phoneNumber'] ?? user?.phoneNumber ?? '+91 xxxxx xxxxx',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
