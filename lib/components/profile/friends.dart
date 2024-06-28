import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/components/profile/addfriend.dart';
import 'package:smart_commute/components/toast/toast.dart';
import 'package:smart_commute/var.dart';

class ProfileFriends extends StatefulWidget {
  const ProfileFriends({super.key});

  @override
  State<ProfileFriends> createState() => _ProfileFriendsState();
}

class _ProfileFriendsState extends State<ProfileFriends> {
  int noOfContacts = 0;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('friend_contacts')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          noOfContacts = snapshot.docs.length;
        });
      });
    }
  }

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
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: ContactsList(userId: user!.uid)),
                Divider(
                  color: Colors.grey[300],
                ),
                if (noOfContacts < maxNoOfContacts)
                  AddFriendButton(
                    userid: user!.uid,
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
  final String id;
  final String name;
  final String number;
  const ContactCard({
    super.key,
    required this.name,
    required this.number,
    required this.id,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('friend_contacts')
                .doc(widget.id)
                .delete();
            successfulToast('Contact deleted successfully.');
          } catch (e) {
            errorToast(e.toString());
          }
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.delete),
        ),
        child: Row(
          children: [
            ProfilePicture(
              name: widget.name,
              radius: 24,
              fontsize: 16,
              count: 2,
              random: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name.length > 16
                        ? '${widget.name.substring(0, 16)}..'
                        : widget.name,
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
                size: 25,
              ),
            )
          ],
        ),
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
            final id = contact.id;
            return ContactCard(
              id: id,
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
  final String userid;
  const AddFriendButton({super.key, required this.userid});

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
                  return AddContactDialog(userId: widget.userid);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddContactDialog(userId: widget.userid);
                    },
                  );
                },
                style: const ButtonStyle(
                    textStyle: MaterialStatePropertyAll(
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.blue,
                  ),
                )),
                child: const Text(' Add Contact')),
          )
        ],
      ),
    );
  }
}
