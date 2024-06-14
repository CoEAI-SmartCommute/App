import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/login/googlesignin.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World'),
      ),
      body: Column(
        children: [
          Text('Hello,${user!.displayName} '),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  });
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.logout();
              Navigator.pop(context);
            },
            child: const Text('Logout'),
          )
        ],
      ),
    );
  }
}
