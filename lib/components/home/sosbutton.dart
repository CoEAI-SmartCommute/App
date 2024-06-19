import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_commute/screens/sos.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.15,
        horizontal: 20,
      ),
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SosScreen(),
          ),
        ),
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
