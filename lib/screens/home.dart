import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/components/home/bottomsheet.dart';
import 'package:smart_commute/components/home/floatingbutton.dart';
import 'package:smart_commute/components/home/homeoptionbutton.dart';
import 'package:smart_commute/components/home/map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingButton(),
      body: Stack(
        alignment: Alignment.topRight,
        children: [HomeMap(), HomeOptionButton(), HomeBottomSheet()],
      ),
    );
  }
}
