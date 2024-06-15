import 'package:flutter/material.dart';
import 'package:smart_commute/components/profile/logout.dart';
import 'package:smart_commute/components/profile/userdata.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserData(),
              ProfileLogout(),
            ],
          ),
        ),
      ),
    );
  }
}
