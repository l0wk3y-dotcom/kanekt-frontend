import 'package:flutter/material.dart';
import 'package:frontend/features/tweet/views/hashtag_page_view.dart';

class HashtagTile extends StatefulWidget {
  final String hashtag;
  final int count;
  const HashtagTile({super.key, required this.hashtag, required this.count});

  @override
  State<HashtagTile> createState() => _HashtagTileState();
}

class _HashtagTileState extends State<HashtagTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, HashtagPageView.route("#" + widget.hashtag));
      },
      leading: Icon(
        Icons.tag,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        widget.hashtag,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary, fontSize: 20),
      ),
      subtitle: Text(
        widget.count.toString() + "post",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
