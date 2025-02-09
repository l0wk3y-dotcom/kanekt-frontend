import 'package:flutter/material.dart';

class Tweeticon extends StatefulWidget {
  final IconData icon;
  final bool active;
  final String count;
  final VoidCallback onTap;
  const Tweeticon(
      {super.key,
      required this.icon,
      required this.count,
      required this.onTap,
      required this.active});

  @override
  State<Tweeticon> createState() => _TweeticonState();
}

class _TweeticonState extends State<Tweeticon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        children: [
          Icon(widget.icon,
              size: 20, color: widget.active ? Colors.blue : Colors.grey),
          Text(
            widget.count,
            style: TextStyle(
                fontSize: 13,
                color: widget.active
                    ? Colors.blue
                    : Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}
