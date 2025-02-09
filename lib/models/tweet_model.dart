import 'dart:io';

class TweetModel {
  String body;
  List<File>? images;
  bool hasImages = false;
  TweetModel({required this.body, this.images});
  factory TweetModel.createTweet(Map<String, dynamic> map) {
    return TweetModel(
        body: map["body"],
        // ignore: prefer_if_null_operators
        images: map["images"] != null ? map["images"] : null);
  }
}

class TweetClientModel {
  String body;
  List<String> images;
  bool hasImages;
  String tweetUsername;
  String profilePicture;
  List<String>? links;
  int views;
  int likes;
  int shares;
  int retweets;
  DateTime createdat;
  String name;
  String retweeted_by;
  String id;
  bool isliked;
  bool isretweeted;
  int replies;
  String repliedto;
  String user_picture;
  TweetClientModel(
      {required this.id,
      this.retweeted_by = "",
      this.isliked = false,
      this.links,
      this.likes = 0,
      required this.createdat,
      this.views = 0,
      this.shares = 0,
      this.retweets = 0,
      this.isretweeted = false,
      this.name = "Not Found",
      this.tweetUsername = "Not Found",
      this.profilePicture =
          "https://l0wk3ycracks.pythonanywhere.com/media/pp/default.jpg",
      this.hasImages = false,
      this.repliedto = "",
      this.replies = 0,
      required this.body,
      required this.images,
      // ignore: non_constant_identifier_names
      required this.user_picture});
  factory TweetClientModel.createTweet(Map<String, dynamic> tweet) {
    final List<String> images = (tweet["images_data"] as List)
        .map((img) => img["image"].toString().startsWith("http")
            ? img["image"].toString()
            : "https://l0wk3ycracks.pythonanywhere.com" +
                img["image"].toString())
        .toList();

    List<String> getLinks(String textinside) {
      List<String> links = [];
      textinside.split(" ").forEach((word) {
        if (word.startsWith("https://") ||
            word.startsWith("http://") ||
            word.startsWith("www.")) {
          links.add(word);
        }
      });
      return links;
    }

    return TweetClientModel(
        isliked: tweet["isliked"],
        body: tweet["body"],
        createdat: DateTime.parse(tweet["created_at"]),
        images: images,
        likes: tweet["likes"],
        retweeted_by: tweet["retweeted_by"],
        views: tweet["views"],
        isretweeted: tweet["isretweeted"],
        shares: tweet["shares"],
        retweets: tweet["retweets"],
        tweetUsername: tweet["user"],
        name: tweet["name"],
        replies: tweet["replies"],
        repliedto: tweet["replied_to"],
        id: tweet["id"].toString(),
        links: getLinks(tweet["body"]),
        user_picture:
            "https://l0wk3ycracks.pythonanywhere.com" + tweet["user_picture"],
        hasImages: images.isNotEmpty);
  }
}
