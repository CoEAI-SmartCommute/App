import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/login/googlesignin.dart';
import 'package:smart_commute/login/login.dart';

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
            Theme.of(context).colorScheme.tertiary,
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
          if (!context.mounted) return;
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        icon: Icon(
          Ionicons.log_out,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: Text('Log Out',
            style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }
}
