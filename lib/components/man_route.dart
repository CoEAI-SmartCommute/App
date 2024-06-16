import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ManualRoutes extends StatefulWidget {
  const ManualRoutes({super.key});

  @override
  State<ManualRoutes> createState() => _ManualRoutesState();
}

class _ManualRoutesState extends State<ManualRoutes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add Destination',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Implement "More" functionality here
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
        const SizedBox(height: 10),
        Row(
          children: [
            Column(
              children: [
                const Icon(Ionicons.ellipse, size: 10, color: Colors.blue),
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.blue,
                ),
                const Icon(Ionicons.ellipse, size: 10, color: Colors.blue),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Choose starting point',
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: Colors.grey[200],
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Ionicons.location_sharp,
                          color: Colors.blue, size: 18),
                      suffixIcon: IconButton(
                        icon: const Icon(Ionicons.locate,
                            color: Colors.blue, size: 18),
                        onPressed: () {
                          // Implement set current location functionality here
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Choose Destination',
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: Colors.grey[200],
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Ionicons.flag,
                          color: Colors.blue, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
