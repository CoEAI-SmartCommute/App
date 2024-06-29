import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/Theme/changethemebutton.dart';
import 'package:smart_commute/components/home/bottomsheet.dart';
import 'package:smart_commute/components/home/sosbutton.dart';
import 'package:smart_commute/components/home/map.dart';
import 'package:smart_commute/providers/shake_provider.dart';
import 'package:smart_commute/providers/theme_provider.dart';
import 'package:smart_commute/screens/profile.dart';
import 'package:smart_commute/screens/sos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    final shakeProvider =
        Provider.of<ShakeDetectorProvider>(context, listen: false);

    shakeProvider.setShakeCallback(() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SosScreen()),
      );
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
        actions: const [ChangeThemeButton(), ProfileButton()],
      ),
      body: const Stack(
        children: [
          HomeMap(),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: SOSButton(),
              )),
          HomeBottomSheet()
        ],
      ),
    );
  }
}

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
                themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user!.photoURL!,
                  fit: BoxFit.cover,
                  height: 38,
                  width: 38,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
              ),
              const Hero(
                tag: 'profileImage',
                child: SizedBox(
                  height: 38,
                  width: 36,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Icon(
                      FontAwesomeIcons.chevronDown,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
