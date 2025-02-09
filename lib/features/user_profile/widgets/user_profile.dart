import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/home/widgets/tweetcard.dart';
import 'package:frontend/features/tweet/logic/controller.dart';
import 'package:frontend/features/user_profile/views/User_profile_edit_view.dart';
import 'package:frontend/features/user_profile/widgets/follow_row.dart';
import 'package:frontend/models/userdetailmodel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final Userdetailmodel user;
  const UserProfile({super.key, required this.user});
  @override
  State<UserProfile> createState() => _UserProfileState();
}

String status = "Follow";

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return NestedScrollView(
        headerSliverBuilder: (context, count) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                      child: Image.network(
                    widget.user.banner,
                    fit: BoxFit.cover,
                  )),
                  Positioned(
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(widget.user.picture),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton(
                        onPressed: () async {
                          if (widget.user.username == authprovider.username) {
                            Navigator.push(context,
                                UserProfileEditView.route(widget.user));
                          } else {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .toggleFollow(widget.user.username);
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(141, 245, 245, 245),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: widget.user.username == authprovider.username
                            ? Text(
                                "Edit profile",
                                style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              )
                            : FutureBuilder(
                                future: Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .getFollow(widget.user.username),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      "Follow",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    );
                                  } else {
                                    debugPrint(
                                        "THis is going to be snapshot data!! ${snapshot.data!}");
                                    return Text(
                                      snapshot.data!,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    );
                                  }
                                })),
                  )
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                Text(
                  widget.user.name,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
                Text(
                  "@${widget.user.username}",
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
                Text(
                  widget.user.bio,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    FollowRow(
                        label: "Following",
                        count: widget.user.following.toString()),
                    SizedBox(
                      width: 20,
                    ),
                    FollowRow(
                        label: "Follower",
                        count: widget.user.followers.toString())
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.grey,
                )
              ])),
            )
          ];
        },
        body: FutureBuilder(
            future: TweetController().getTweetsUser(widget.user.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                final tweets = snapshot.data;
                return ListView.builder(
                    itemCount: tweets!.length,
                    itemBuilder: (context, count) {
                      return TweetCard(tweet: tweets[count]);
                    });
              }
            }));
  }
}
