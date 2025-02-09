import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/home/widgets/carouselimages.dart';
import 'package:frontend/features/home/widgets/tweeticon.dart';
import 'package:frontend/features/home/widgets/tweettext.dart';
import 'package:frontend/features/tweet/views/replypage.dart';
import 'package:frontend/models/tweet_model.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class TweetCard extends StatefulWidget {
  final TweetClientModel tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    final tweet = widget.tweet;
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(tweet.user_picture),
                  radius: 25,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tweet.retweeted_by != "")
                      Row(
                        children: [
                          const Icon(
                            Icons.repeat,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "retweeted by ",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          tweet.retweeted_by == tweet.tweetUsername
                              ? const Text(
                                  "You",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  tweet.retweeted_by,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                )
                        ],
                      ),
                    if (tweet.repliedto != "")
                      Row(
                        children: [
                          const Text(
                            "replied to ",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          tweet.repliedto == tweet.tweetUsername
                              ? Text(
                                  tweet.repliedto,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  tweet.repliedto,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                )
                        ],
                      ),
                    Row(
                      children: [
                        Text(
                          tweet.name,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(" @${tweet.tweetUsername}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 129, 129, 129))),
                        Text(
                            "- ${timeago.format(tweet.createdat, locale: "en_short")}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 129, 129, 129))),
                      ],
                    ),
                    Tweettext(text: tweet.body),
                    if (tweet.hasImages) Carouselimages(images: tweet.images),
                    const SizedBox(height: 6),
                    if (tweet.links != null && tweet.links!.isNotEmpty)
                      AnyLinkPreview(
                        link: tweet.links![0],
                        displayDirection: UIDirection.uiDirectionHorizontal,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tweeticon(
                              onTap: () {},
                              active: false,
                              icon: Icons.bar_chart,
                              count: NumberFormat.compact().format(
                                  tweet.replies +
                                      tweet.likes +
                                      tweet.retweets)),
                          Tweeticon(
                              onTap: () {
                                Navigator.of(context)
                                    .push(Replypage.route(tweet));
                              },
                              active: false,
                              icon: Icons.comment,
                              count:
                                  NumberFormat.compact().format(tweet.replies)),
                          LikeButton(
                            isLiked: tweet.isliked,
                            onTap: (isLiked) async {
                              authprovider.likeTweet(tweet.id, isLiked);
                              return !isLiked;
                            },
                            size: 25, // Adjusted size
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                  : const Icon(Icons.favorite,
                                      color: Colors.grey);
                            },
                            likeCount: tweet.likes,
                            countBuilder: (likeCount, isLiked, text) {
                              return Text(
                                text,
                                style: TextStyle(
                                    color: isLiked ? Colors.red : Colors.white,
                                    fontSize: 16),
                              );
                            },
                          ),
                          Tweeticon(
                              onTap: () {
                                authprovider.retweet(tweet.id, context);
                                setState(() {
                                  tweet.isretweeted = !tweet.isretweeted;
                                  tweet.isretweeted == true
                                      ? tweet.retweets += 1
                                      : tweet.retweets -= 1;
                                });
                              },
                              active: tweet.isretweeted,
                              icon: Icons.repeat,
                              count: NumberFormat.compact()
                                  .format(tweet.retweets)),
                          const Icon(
                            Icons.share,
                            size: 19,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey)
        ],
      ),
    );
  }
}
