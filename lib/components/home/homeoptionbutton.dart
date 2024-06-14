import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomeOptionButton extends StatelessWidget {
  const HomeOptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.map)),
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
