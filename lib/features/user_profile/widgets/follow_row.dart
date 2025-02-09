import 'package:flutter/material.dart';

class FollowRow extends StatelessWidget {
  final String label;
  final String count;
  const FollowRow({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          count,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 19),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 19),
        ),
      ],
    );
  }
}
