import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(
          Ionicons.chatbox,
          color: Colors.blue,
        ),
        style: IconButton.styleFrom(
          minimumSize: const Size(50, 50),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
