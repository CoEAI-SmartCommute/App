import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserData extends StatelessWidget {
  const UserData({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          user?.displayName ?? 'User',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          user?.email ?? 'user@xyyz.com',
          style: const TextStyle(
            fontSize: 15,
            decorationColor: Colors.grey,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          user?.phoneNumber ?? '+91 xxxxx xxxxx',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
