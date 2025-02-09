import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/tweet/views/hashtag_page_view.dart';

class Tweettext extends StatefulWidget {
  final String text;
  const Tweettext({super.key, required this.text});

  @override
  State<Tweettext> createState() => _TweettextState();
}

class _TweettextState extends State<Tweettext> {
  List<TextSpan> textspans = [];

  @override
  Widget build(BuildContext context) {
    widget.text.split(' ').forEach((word) {
      if (word.startsWith("#")) {
        textspans.add(TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context, HashtagPageView.route(word));
              },
            text: word, // Remove the extra space
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 19)));
      } else if (word.startsWith("www") ||
          word.startsWith("https://") ||
          word.startsWith("http://")) {
        textspans.add(TextSpan(
            text: word, // Remove the extra space
            style: const TextStyle(color: Colors.blue, fontSize: 18)));
      } else {
        textspans.add(TextSpan(
            text: "$word ", // Remove the extra space
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontFamilyFallback: <String>[
                  'Noto Color Emoji',
                  'Android Emoji'
                ])));
      }
    });
    return RichText(
        text: TextSpan(
      children: textspans,
      style: DefaultTextStyle.of(context).style,
    ));
  }
}
