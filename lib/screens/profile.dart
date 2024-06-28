import 'package:flutter/material.dart';
import 'package:smart_commute/components/profile/friends.dart';
import 'package:smart_commute/components/profile/logout.dart';
import 'package:smart_commute/components/profile/userdata.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserData(),
              SizedBox(
                height: 10,
              ),
              ProfileFriends(),
              Expanded(child: SizedBox()),
            ],
          ),
          ProfileLogout(),
        ]),
      ),
    );
  }
}
