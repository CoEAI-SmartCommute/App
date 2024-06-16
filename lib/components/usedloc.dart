import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UsedLocationCard extends StatelessWidget {
  final String title;
  final String description;
  const UsedLocationCard(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Ionicons.location,
            color: Colors.blue,
          ),
          style: IconButton.styleFrom(
            minimumSize: const Size(36, 36),
            backgroundColor: Colors.grey[200],
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        )
      ],
    );
  }
}

class SetLocationCard extends StatelessWidget {
  const SetLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Ionicons.locate,
            color: Colors.blue,
          ),
          style: IconButton.styleFrom(
            minimumSize: const Size(36, 36),
            backgroundColor: Colors.grey[200],
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        const Text(
          'Set location on map',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
