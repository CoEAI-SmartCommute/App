import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  const UserData({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: user!.photoURL!,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          user.displayName!,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height:8,
        ),
        Text(
          user.email!,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xff868782),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          user.phoneNumber!,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xff868782),
          ),
        ),
      ],
    );
  }
}
