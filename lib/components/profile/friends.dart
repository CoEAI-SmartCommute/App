import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/components/profile/addfriend.dart';
import 'package:smart_commute/var.dart';

class ProfileFriends extends StatefulWidget {
  const ProfileFriends({super.key});

  @override
  State<ProfileFriends> createState() => _ProfileFriendsState();
}

class _ProfileFriendsState extends State<ProfileFriends> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Friend Contacts',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1.5,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]),
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ContactsList(userId: user!.displayName!)),
                Divider(
                  color: Colors.grey[300],
                ),
                AddFriendButton(
                  username: user!.displayName!,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCard extends StatefulWidget {
  final String name;
  final String number;
  final dynamic imgUrl;
  const ContactCard(
      {super.key,
      required this.name,
      required this.number,
      required this.imgUrl});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.imgUrl ?? tempImage,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              height: 50,
              width: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  widget.name,
                  // .substring(0, 18),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                Text(
                  widget.number,
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Ionicons.call,
              color: Color(0xff4CB93A),
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}

class ContactsList extends StatelessWidget {
  final String userId;

  const ContactsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friend_contacts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text('No contacts found.'),
          ));
        }

        final contacts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            final contactData = contact.data() as Map<String, dynamic>;
            final name = contactData['name'] ?? 'No Name';
            final number = contactData['number'] ?? 'No Number';
            final imageUrl = contactData['image_url'];
            return ContactCard(
              imgUrl: imageUrl,
              name: name,
              number: number,
            );
          },
        );
      },
    );
  }
}

class AddFriendButton extends StatefulWidget {
  final String username;
  const AddFriendButton({super.key, required this.username});

  @override
  State<AddFriendButton> createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends State<AddFriendButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddContactDialog(userId: widget.username);
                },
              );
            },
            icon: const Icon(
              Ionicons.add,
              color: Colors.blue,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(50, 50),
              backgroundColor: Colors.grey[200],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Add Contact',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
