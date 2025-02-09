import 'package:flutter/material.dart';
import 'package:frontend/features/user_profile/views/user_profile_view.dart';
import 'package:frontend/models/userdetailmodel.dart';

class UserTile extends StatefulWidget {
  final Userdetailmodel user;
  const UserTile({super.key, required this.user});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, UserProfileView.route(widget.user));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.user.picture),
      ),
      title: Text(
        widget.user.name,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("@${widget.user.username}",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(widget.user.bio,
              style: TextStyle(
                color: Colors.grey,
              )),
        ],
      ),
    );
  }
}
