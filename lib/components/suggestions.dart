import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SuggestionsAi extends StatelessWidget {
  const SuggestionsAi({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions by AI',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SuggestCard(
            color: Colors.blue,
            title: 'Nearby Public Transport',
            description: 'Options for all nearby departures'),
        SuggestCard(
            color: Colors.red,
            title: 'SM Street',
            description:
                'SM Street.Calicut'),
      ],
    );
  }
}

class SuggestCard extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  const SuggestCard(
      {super.key,
      required this.title,
      required this.description,
      required this.color});

  @override
  State<SuggestCard> createState() => _SuggestCardState();
}

class _SuggestCardState extends State<SuggestCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration:
                BoxDecoration(color: widget.color, shape: BoxShape.circle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title.length > 18
                      ? widget.title.substring(0, 18)
                      : widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                Text(
                  widget.description.length > 32
                      ? widget.description.substring(0, 32)
                      : widget.description,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Ionicons.add,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
