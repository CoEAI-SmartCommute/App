import 'package:flutter/material.dart';
import 'package:smart_commute/components/profile/friends.dart';
import 'package:smart_commute/components/profile/logout.dart';
import 'package:smart_commute/components/profile/userdata.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F6),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const UserData(),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Friend Contacts',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const ProfileFriends(),
            const Expanded(child: SizedBox()),
            const ProfileLogout(),
          ],
        ),
      ),
    );
  }
}
