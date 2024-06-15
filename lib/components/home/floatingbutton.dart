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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.tertiary,
          ),
          shape: const MaterialStatePropertyAll(
            CircleBorder(),
          ),
        ),
        onPressed: () {},
        child: const Icon(
          Ionicons.chatbox,
          color: Colors.black,
        ),
      ),
    );
  }
}
