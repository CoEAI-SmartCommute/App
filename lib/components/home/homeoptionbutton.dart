import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeOptionButton extends StatelessWidget {
  const HomeOptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              '8.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.locationArrow)),
          ],
        ),
      ),
    );
  }
}
