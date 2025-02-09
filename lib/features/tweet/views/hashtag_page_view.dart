import 'package:flutter/material.dart';
import 'package:frontend/features/home/widgets/tweetcard.dart';
import 'package:frontend/features/tweet/logic/controller.dart';
import 'package:frontend/models/tweet_model.dart';

class HashtagPageView extends StatefulWidget {
  static route(String hashtag) {
    return MaterialPageRoute(
        builder: (context) => HashtagPageView(hashtag: hashtag));
  }

  final String hashtag;
  const HashtagPageView({super.key, required this.hashtag});

  @override
  State<HashtagPageView> createState() => _HashtagPageViewState();
}

class _HashtagPageViewState extends State<HashtagPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.hashtag,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      )),
      body: FutureBuilder(
          future: TweetController().searchHashtag(widget.hashtag.substring(1)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              final List<TweetClientModel> tweets = snapshot.data!;
              return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (context, count) {
                    return TweetCard(tweet: tweets[count]);
                  });
            }
          }),
    );
  }
}
