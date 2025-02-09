import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api/tweet_repo.dart';
import 'package:frontend/common/custom_snackbar.dart';
import 'package:frontend/models/tweet_model.dart';
import 'package:http/http.dart' as http;

class TweetController {
  Future<void> shareTweet(
      TweetModel tweet, TweetRepo api, String accessToken, context) async {
    bool res = false;
    if (tweet.hasImages == true) {
      debugPrint(
          "-------------------------------------------tweet with images");
      res =
          await api.createTweetWImages(tweet.body, tweet.images!, accessToken);
    } else {
      debugPrint(
          "-------------------------------------------tweet without images");
      res = await api.createTweet(tweet.body, accessToken);
    }
    if (res == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Tweet could not be created"));

      throw Exception("Tweet could not be made");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Tweet created"));
    }
  }

  Future<void> sharereply(TweetModel tweet, TweetRepo api, String accessToken,
      BuildContext context, String tweetid) async {
    bool res = false;
    if (tweet.hasImages == true) {
      debugPrint(
          "-------------------------------------------tweet with images");
      res = await api.createReplyWImages(
          tweet.body, tweet.images!, accessToken, tweetid);
    } else {
      debugPrint(
          "-------------------------------------------tweet without images");
      res = await api.createReply(tweet.body, accessToken, tweetid);
    }
    if (res == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Tweet created"));

      throw Exception("Tweet could not be made");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackbar("Tweet could not be created"));
    }
  }

  Future<List<TweetClientModel>> getReplies(String tweetid) async {
    final url = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/$tweetid/replies");
    final res = await http.get(url);
    final List tweetsdict = jsonDecode(res.body);
    List<TweetClientModel> tweets =
        tweetsdict.map((e) => TweetClientModel.createTweet(e)).toList();
    return tweets;
  }

  Future<List<TweetClientModel>> getTweetsUser(int userid) async {
    final url = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/user/$userid");
    final res = await http.get(url);
    final List tweetsdict = jsonDecode(res.body);
    List<TweetClientModel> tweets =
        tweetsdict.map((e) => TweetClientModel.createTweet(e)).toList();
    return tweets;
  }

  Future<List<TweetClientModel>> searchHashtag(String hashtag) async {
    final url = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/hashtag/$hashtag");
    final res = await http.get(url);
    final List tweetsdict = jsonDecode(res.body);
    List<TweetClientModel> tweets =
        tweetsdict.map((e) => TweetClientModel.createTweet(e)).toList();
    return tweets;
  }
}
