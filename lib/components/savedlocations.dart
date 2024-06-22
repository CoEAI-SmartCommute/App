import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({super.key});

  @override
  State<SavedLocations> createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your Saved Locations',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          GestureDetector(
            onTap: () {
              // Implement your "More" functionality here
            },
            child: const Text(
              'More',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLocButton(
            title: 'Home',
            icon: Ionicons.home,
          ),
          CustomLocButton(
            title: 'Work',
            icon: Ionicons.business,
          ),
          AddLocButton()
        ],
      )
    ]);
  }
}

class CustomLocButton extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomLocButton({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              color: Colors.blue,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(60, 60),
              backgroundColor: Colors.grey[200],
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Add',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }
}

class AddLocButton extends StatelessWidget {
  const AddLocButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Ionicons.add,
              color: Colors.blue,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(60, 60),
              backgroundColor: Colors.grey[200],
            ),
          ),
          const Text(
            'Add',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
