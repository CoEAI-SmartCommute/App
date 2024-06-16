import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RecentUpdates extends StatefulWidget {
  const RecentUpdates({super.key});

  @override
  RecentUpdatesState createState() => RecentUpdatesState();
}

class RecentUpdatesState extends State<RecentUpdates> {
  bool showAll = false;

  final List<Map<String, String>> placeholderComments = [
    {
      'name': 'Sushobhan Nayak',
      'comment': 'Rash driving. Be careful',
      'location': 'Pune',
    },
    {
      'name': 'Sumit Darshanala',
      'comment':
          'Street not well lit.',
      'location': 'San Francisco',
    },
    {
      'name': 'Deepanshu Garg',
      'comment':
          'I want my Oracle PPO. I am not interested in any other company.',
      'location': 'Bangalore',
    },
    {
      'name': 'Piyush Soni',
      'comment': 'Nothing',
      'location': 'SpaceX',
    },
  ];

  @override
  Widget build(BuildContext context) {
    int commentsToShow = showAll ? placeholderComments.length : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Updates',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Text(
                showAll ? 'Show Less' : 'More',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(commentsToShow, (index) {
          Map<String, String> comment = placeholderComments[index];
    
          Widget commentWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Ionicons.alert_circle_outline,
                            color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(comment['comment']!),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Ionicons.location_outline,
                            color: Colors.grey, size: 16),
                        Text(
                          comment['location']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
    
          // Add divider after each comment except the last one
          if (index < commentsToShow - 1) {
            commentWidget = Column(
              children: [
                commentWidget,
                Divider(
                  color: Colors.grey[300],
                ),
              ],
            );
          }
    
          return commentWidget;
        }),
      ],
    );
  }
}