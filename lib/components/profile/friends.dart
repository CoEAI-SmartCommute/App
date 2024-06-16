import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/var.dart';

class ProfileFriends extends StatefulWidget {
  const ProfileFriends({super.key});

  @override
  State<ProfileFriends> createState() => _ProfileFriendsState();
}

class _ProfileFriendsState extends State<ProfileFriends> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContactCard(),
              Divider(
                color: Colors.grey[300],
              ),
              const AddFriendButton()
            ],
          ),
        ),
      ],
    );
  }
}

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: tempImage,
              height: 50,
              width: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Text(
                  'Hayao Miyazaki',
                  // .substring(0, 18),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                Text(
                  '+81 xxx xxx xxxx',
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

class AddFriendButton extends StatefulWidget {
  const AddFriendButton({super.key});

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
