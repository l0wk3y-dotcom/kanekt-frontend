import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/tweet_repo.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/tweet/logic/controller.dart';
import 'package:frontend/models/tweet_model.dart';
import 'package:provider/provider.dart';
import '../logic/utils.dart';
import 'package:image_picker/image_picker.dart';

class CreateTweet extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) {
          return const CreateTweet();
        },
      );
  const CreateTweet({super.key});

  @override
  State<CreateTweet> createState() => _CreateTweetState();
}

class _CreateTweetState extends State<CreateTweet> {
  final tweetInputController = TextEditingController();
  List imagesList = [];
  final tweetController = TweetController();

  Future<void> pickImage() async {
    try {
      List<XFile> images = await enablePicker();
      if (images.isNotEmpty) {
        setState(() {
          imagesList = images; // Notify Flutter to rebuild the UI
        });
      }
    } catch (e) {
      debugPrint("Error in picking images: $e");
    }
  }

  @override
  void dispose() {
    tweetInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              size: 30,
            )),
        actions: [
          ElevatedButton(
            onPressed: () {
              final tweet = TweetModel.createTweet({
                "body": tweetInputController.text,
                "images": imagesList.map((e) => File(e.path)).toList()
              });
              tweet.hasImages = imagesList.isNotEmpty;
              final api = TweetRepo();
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              tweetController.shareTweet(
                  tweet, api, authProvider.accesstoken!, context);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.grey),
            child: const Text(
              "Post",
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(authprovider.profilepicture.toString()),
                    radius: 25,
                  ),
                  Expanded(
                    child: TextField(
                      controller: tweetInputController,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20),
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "What's on the mind?",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
            CarouselSlider(
                items: imagesList
                    .map((file) => Image.file(File(file.path)))
                    .toList(),
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 400,
                  scrollDirection: Axis.horizontal,
                ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration:
            const BoxDecoration(border: Border(top: BorderSide(width: 0.3))),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                pickImage();
                setState(() {});
              },
              icon: const Icon(Icons.image, size: 30),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.gif_box, size: 30),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
