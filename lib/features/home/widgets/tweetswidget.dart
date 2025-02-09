import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/home/widgets/tweetcard.dart';
import 'package:frontend/models/tweet_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Tweetswidget extends StatefulWidget {
  const Tweetswidget({super.key});

  @override
  State<Tweetswidget> createState() => _TweetswidgetState();
}

class _TweetswidgetState extends State<Tweetswidget> {
  List<TweetClientModel> _tweets = [];
  bool newTweet = false;
  late WebSocketChannel _channel;

  Future<List> getTweets(String authtoken) async {
    final uri =
        Uri.parse("https://l0wk3ycracks.pythonanywhere.com/tweets/list/");
    final res =
        await http.get(uri, headers: {"Authorization": "Bearer $authtoken"});
    List data = jsonDecode(res.body);
    newTweet = false;
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
        Uri.parse("ws://192.168.1.3:8000/ws/connect/"));

    _channel.stream.listen((message) {
      final msg = jsonDecode(message);
      print("Recieved some message $msg");
      if (msg["action"] == "new_tweet") {
        setState(() {
          newTweet = true; // Update the message when data is received
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    authprovider.registerToken();
    return Stack(children: [
      FutureBuilder(
          future: getTweets(authprovider.accesstoken!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              final data = snapshot.data;
              _tweets =
                  data!.map((e) => TweetClientModel.createTweet(e)).toList();
              return RefreshIndicator(
                onRefresh: () async {
                  // Fetch new tweets here (replace with your actual logic)
                  final newData = await getTweets(authprovider.accesstoken!);
                  final refreshedTweets = newData
                      .map((e) => TweetClientModel.createTweet(e))
                      .toList();
                  // Update the state with the new tweets (optional)
                  setState(() {
                    _tweets.clear();
                    _tweets.addAll(refreshedTweets);
                    newTweet = false;
                  });
                  return; // Important: Return after fetching new data
                },
                child: ListView.builder(
                  itemCount: _tweets.length,
                  itemBuilder: (context, count) {
                    debugPrint(_tweets[count].body);
                    return TweetCard(tweet: _tweets[count]);
                  },
                ),
              );
            }
          }),
      if (newTweet)
        Positioned(
            left: MediaQuery.of(context).size.width / 2 - 55,
            top: 20,
            child: TextButton(
                onPressed: () async {
                  // Fetch new tweets here (replace with your actual logic)
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  final newData = await getTweets(authprovider.accesstoken!);
                  final refreshedTweets = newData
                      .map((e) => TweetClientModel.createTweet(e))
                      .toList();
                  // Update the state with the new tweets (optional)
                  Navigator.pop(context);
                  setState(() {
                    _tweets.clear();
                    _tweets.addAll(refreshedTweets);
                    newTweet = false;
                  });
                  // Important: Return after fetching new data
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        "New Posts",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 20,
                      )
                    ],
                  ),
                )))
    ]);
  }
}
