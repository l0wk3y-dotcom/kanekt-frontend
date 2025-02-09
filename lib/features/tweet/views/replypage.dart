import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/tweet_repo.dart';
import 'package:frontend/common/custom_snackbar.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/home/widgets/tweetcard.dart';
import 'package:frontend/features/tweet/logic/controller.dart';
import 'package:frontend/features/tweet/logic/utils.dart';
import 'package:frontend/models/tweet_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Replypage extends StatefulWidget {
  static MaterialPageRoute route(TweetClientModel tweet) {
    return MaterialPageRoute(builder: (context) {
      return Replypage(tweet: tweet);
    });
  }

  final TweetClientModel tweet;
  const Replypage({super.key, required this.tweet});

  @override
  State<Replypage> createState() => _ReplypageState();
}

class _ReplypageState extends State<Replypage> {
  TextEditingController replytextcontroller = TextEditingController();
  List<XFile> imageslist = [];
  Future<void> pickimages() async {
    try {
      final List<XFile> images = await enablePicker();
      if (images.isNotEmpty) {
        setState(() {
          imageslist = images;
        });
      }
    } on Exception {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Images could not be pickeds"));
    }
  }

  @override
  void dispose() {
    replytextcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tweetcontroller = TweetController();
    return FutureBuilder(
        future: tweetcontroller.getReplies(widget.tweet.id),
        builder: (context, snapsot) {
          if (snapsot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapsot.hasError) {
            return Center(
              child: Text(snapsot.error.toString()),
            );
          } else {
            final List<TweetClientModel> tweets = snapsot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Post",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              body: Column(
                children: [
                  SingleChildScrollView(child: TweetCard(tweet: widget.tweet)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Repiles",
                        style: TextStyle(
                            fontSize: 23,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: (context, count) {
                          tweets[count].images = tweets[count]
                              .images
                              .map((image) =>
                                  "https://l0wk3ycracks.pythonanywhere.com/$image")
                              .toList();
                          return TweetCard(
                            tweet: tweets[count],
                          );
                        }),
                  )
                ],
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imageslist.isNotEmpty)
                    CarouselSlider(
                        items: imageslist
                            .map(
                              (e) => Image.file(File(e.path)),
                            )
                            .toList(),
                        options: CarouselOptions(
                            enableInfiniteScroll: false,
                            scrollDirection: Axis.horizontal,
                            height: 100)),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0, right: 10, left: 10),
                    child: TextField(
                      controller: replytextcontroller,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18),
                      decoration: InputDecoration(
                          hintText: "Enter your Reply..",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  pickimages();
                                },
                                icon: const Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                color: Colors.blue,
                              ),
                              IconButton(
                                onPressed: () async {
                                  final tweet = TweetModel.createTweet({
                                    "body": replytextcontroller.text,
                                    "images": imageslist
                                        .map((e) => File(e.path))
                                        .toList()
                                  });
                                  tweet.hasImages = imageslist.isNotEmpty;
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (
                                        context,
                                      ) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  await tweetcontroller.sharereply(
                                      tweet,
                                      TweetRepo(),
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .accesstoken!,
                                      context,
                                      widget.tweet.id);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.send,
                                  size: 30,
                                ),
                                color: Colors.blue,
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
