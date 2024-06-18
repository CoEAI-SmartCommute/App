import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.15,
        horizontal: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1.5,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.exclamation,
            color: Colors.white,
            size: 30,
          ),
          style: IconButton.styleFrom(
            minimumSize: const Size(35, 35),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
