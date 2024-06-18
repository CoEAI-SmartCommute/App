import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_commute/components/home/bottomsheet.dart';
import 'package:smart_commute/components/home/floatingbutton.dart';
import 'package:smart_commute/components/home/homeoptionbutton.dart';
import 'package:smart_commute/components/home/map.dart';
import 'package:smart_commute/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const ProfileButton()
        ],
      ),
      body: const Stack(
        children: [
          HomeMap(),
          Align(alignment: Alignment.bottomLeft, child: FloatingButton()),
          Align(alignment: Alignment.bottomRight, child: HomeOptionButton()),
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
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      child: Hero(
        tag: 'profileImage',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user!.photoURL!,
              fit: BoxFit.cover,
              height: 42,
              width: 42,
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
