import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_commute/components/forum/recent_updates.dart';

class RecentUpdates extends StatefulWidget {
  const RecentUpdates({super.key});

  @override
  RecentUpdatesState createState() => RecentUpdatesState();
}

class RecentUpdatesState extends State<RecentUpdates> {
  // bool showAll = false;

  final List<Map<String, String>> placeholderComments = [
    {
      'name': 'Sushobhan Nayak',
      'comment': 'Rash driving. Be careful',
      'location': 'Pune',
    },
    {
      'name': 'Sumit Darshanala',
      'comment': 'Street not well lit.',
      'location': 'San Francisco',
    },
    {
      'name': 'Deepanshu Garg',
      'comment': 'There is no food stall nearby. Even momos are not available.',
      'location': 'Bangalore',
    },
    {
      'name': 'Piyush Soni',
      'comment': 'Elon be like, "I am going to Mars."',
      'location': 'SpaceX',
    },
  ];

  @override
  Widget build(BuildContext context) {
    int commentsToShow = 2;

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
                  // showAll = !showAll;
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          RecentComments(comments: placeholderComments),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              child: Text(
                'More',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
