import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/login/googlesignin.dart';

class ProfileLogout extends StatefulWidget {
  const ProfileLogout({super.key});

  @override
  State<ProfileLogout> createState() => _ProfileLogoutState();
}

class _ProfileLogoutState extends State<ProfileLogout> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Colors.grey[300],
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevation: const MaterialStatePropertyAll(0),
        ),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          await provider.logout();
        },
        icon: const Icon(
          Ionicons.log_out,
          color: Colors.blue,
        ),
        label: const Text('Log Out', style: TextStyle(color: Colors.blue)),
      ),
    );
  }
}
