import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_commute/var.dart';

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
      child: TextButton.icon(
        onPressed: () {
          _callNumber();
        },
        style: IconButton.styleFrom(
          elevation: 15,
          shadowColor: Colors.grey,
          minimumSize: const Size(40, 40),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
        icon: const Icon(
          FontAwesomeIcons.exclamation,
          color: Colors.white,
          size: 15,
        ),
        label: const Text(
          'SOS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

_callNumber() async {
  await FlutterPhoneDirectCaller.callNumber(emergencyNumber);
}
