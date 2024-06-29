import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RecentComments extends StatelessWidget {
  const RecentComments({super.key, required this.comments});
  final List<Map<String, String>> comments;

  @override
  Widget build(BuildContext context) {
    int commentsToShow = comments.length;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text(
          'Recent Updates',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ...List.generate(commentsToShow, (index) {
                Map<String, String> comment = comments[index];

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
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.4),
                      ),
                    ],
                  );
                }

                return commentWidget;
              }),
            ],
          ),
        ),
      ),
    );
  }
}
