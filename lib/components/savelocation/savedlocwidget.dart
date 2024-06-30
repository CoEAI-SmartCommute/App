import 'package:cloud_firestore/cloud_firestore.dart' as cfs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/components/confirmdialog.dart';
import 'package:smart_commute/screens/savedlocation.dart';

class SavedList extends StatelessWidget {
  const SavedList({super.key, required this.isAdd});
  final bool isAdd;
  get user => FirebaseAuth.instance.currentUser;

  Stream<List<Map<String, String>>> streamSavedLocations() {
    return cfs.FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('saved_locations')
        .orderBy('tag')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] as String,
          'address': doc['address'] as String,
          'tag': doc['tag'] as String
        };
      }).toList();
    });
  }

  Future<void> deleteLocation(String locationId) async {
    await cfs.FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('saved_locations')
        .doc(locationId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, String>>>(
      stream: streamSavedLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!isAdd && (!snapshot.hasData || snapshot.data!.isEmpty)) {
          return const Center(
              child: Padding(
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
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    isAdd ? savedLocations.length + 1 : savedLocations.length,
                itemBuilder: (context, index) {
                  if (isAdd && index == savedLocations.length) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: AddLocButton(),
                    );
                  }
                  Map<String, String> location = savedLocations[index];
                  IconData icon = (location['tag'] == 'Home')
                      ? Icons.home
                      : (location['tag'] == 'Work')
                          ? Icons.work
                          : Icons.location_on_sharp;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CustomLocButton(
                        title: location['name'] ?? 'New Location',
                        icon: icon,
                        onDelete: () {
                          final id = location['id'];
                          if (id != null) {
                            deleteLocation(id);
                          } else {
                            print('Cannot delete location: ID is null');
                          }
                        }),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomLocButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final int maxCharacters = 10;
  final VoidCallback onDelete;

  const CustomLocButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onDelete,
  });

  @override
  _CustomLocButtonState createState() => _CustomLocButtonState();
}

class _CustomLocButtonState extends State<CustomLocButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showDeleteIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDeleteIcon() {
    setState(() {
      _showDeleteIcon = !_showDeleteIcon;
      if (_showDeleteIcon) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleDelete() async {
    bool? confirm = await showConfirmDialog(
        context, 'Do you want to remove this location?');
    if (confirm == true) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayTitle = widget.title.length > widget.maxCharacters
        ? '${widget.title.substring(0, widget.maxCharacters)}...'
        : widget.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onLongPress: _toggleDeleteIcon,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        color: Colors.blue,
                      ),
                      if (_showDeleteIcon)
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Opacity(
                            opacity: _animation.value,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: _handleDelete,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Text(
            displayTitle,
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
