import 'package:cloud_firestore/cloud_firestore.dart' as cfs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/screens/savedlocation.dart';

class SavedList extends StatelessWidget {
  const SavedList({super.key, required this.isAdd});
  final bool isAdd;
  get user => FirebaseAuth.instance.currentUser;

  Future<List<Map<String, String>>> fetchSavedLocations() async {
    cfs.QuerySnapshot querySnapshot = await cfs.FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('saved_locations')
        .orderBy('tag')
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'name': doc['name'] as String,
        'address': doc['address'] as String,
        'tag': doc['tag'] as String
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: fetchSavedLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!isAdd && (!snapshot.hasData || snapshot.data!.isEmpty)) {
          return const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('No saved locations'),
          ));
        }

        List<Map<String, String>> savedLocations = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Saved Locations',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    savedLocations.length > 3 && isAdd
                        ? 3
                        : savedLocations.length,
                    (index) {
                      Map<String, String> location = savedLocations[index];
                      IconData icon = (location['tag'] == 'Home')
                          ? Icons.home
                          : (location['tag'] == 'Work')
                              ? Icons.work
                              : Icons.location_on_sharp;
                      return CustomLocButton(
                        title: location['name'] ?? 'New Location',
                        icon: icon,
                      );
                    },
                  ),
                  if (isAdd) const AddLocButton()
                ],
              ),
            )
          ],
        );
      },
    );
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
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SaveLocationScreen(),
                ),
              );
            },
            icon: const Icon(
              Ionicons.add,
              color: Colors.blue,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(60, 60),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
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
