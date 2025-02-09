import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/features/search/controller/search_controller.dart';
import 'package:frontend/features/search/widgets/hashtag_tile.dart';
import 'package:frontend/features/search/widgets/usertile.dart';
import 'package:frontend/models/userdetailmodel.dart';
import 'package:http/http.dart' as http;

class SearchPageView extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => SearchPageView());

  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  final borderstyle = OutlineInputBorder(
      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20));
  final searchController = SearchControllerQuery();

  final TextEditingController SearchTextController = TextEditingController();

  Future<List<Userdetailmodel>>? _searchResults;

  Future<void> _performSearch(String query) async {
    final res = searchController.searchUser(query);
    setState(() {
      _searchResults = res;
    });
  }

  @override
  void dispose() {
    SearchTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 20),
              onSubmitted: (value) {
                if (value != "") {
                  setState(() {
                    _performSearch(value);
                  });
                }
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  hintText: "Search users",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  contentPadding:
                      const EdgeInsets.only(top: 10).copyWith(left: 20),
                  focusedBorder: borderstyle,
                  enabledBorder: borderstyle),
            ),
          ),
        ),
      ),
      body: _searchResults == null
          ? const _HashtagList()
          : FutureBuilder<List<Userdetailmodel>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No users found.",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  );
                }

                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserTile(user: user); // Assumes a `UserTile` widget
                  },
                );
              },
            ),
    );
  }
}

class _HashtagList extends StatefulWidget {
  const _HashtagList();

  @override
  State<_HashtagList> createState() => __HashtagListState();
}

class __HashtagListState extends State<_HashtagList> {
  Future<List<Map<String, dynamic>>> _getHashtags() async {
    final res = await http.get(
        Uri.parse("https://l0wk3ycracks.pythonanywhere.com/tweets/hashtag/"));
    final data = List<Map<String, dynamic>>.from(jsonDecode(res.body));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              const Icon(Icons.trending_up_outlined),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Trending",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: FutureBuilder(
              future: _getHashtags(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  List<Map<String, dynamic>> hashtags = snapshot.data!;
                  return ListView.builder(
                      itemCount: hashtags.length,
                      itemBuilder: (context, count) {
                        return HashtagTile(
                          hashtag: hashtags[count]["hashtag"],
                          count: hashtags[count]["tweet_count"],
                        );
                      });
                }
              }),
        ),
      ],
    );
  }
}
