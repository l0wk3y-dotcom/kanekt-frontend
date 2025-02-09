import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/home_repo.dart';
import 'package:frontend/features/auth/logic/auth_provider.dart';
import 'package:frontend/features/auth/pages/widgets/widget_const.dart';
import 'package:frontend/features/home/pages/theme_page.dart';
import 'package:frontend/features/home/widgets/tweetswidget.dart';
import 'package:frontend/features/search/pages/searchpageview.dart';
import 'package:frontend/features/tweet/views/tweetpage.dart';
import 'package:frontend/features/user_profile/views/user_profile_view.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const Homepage();
      });
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final homeapi = HomeRepo();
    final authprovider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
        future: homeapi.getHome(authprovider.accesstoken!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Scaffold(
              body: Center(child: Tweetswidget()),
            );
          }
        });
  }
}

class HomeNavigation extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const HomeNavigation();
      });
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<HomeNavigation> {
  void pushCreateTweet() {
    Navigator.of(context).push(CreateTweet.route());
  }

  final appbar = UIConstants.authAppbar();
  int _currentpage = 0;
  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: _currentpage == 0 ? appbar : null,
      body: IndexedStack(
        index: _currentpage,
        children: [
          const Homepage(),
          const SearchPageView(),
          UserProfileView(
            user: authprovider.self!,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushCreateTweet();
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add,
            color: Theme.of(context).colorScheme.surface, size: 45),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTile(
                onTap: () {
                  Navigator.push(context, ThemePage.route());
                },
                leading: Icon(
                  Icons.nightlight_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  "Theme",
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  "Verify",
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListTile(
                onTap: () {
                  authprovider.logout(context);
                },
                leading: Icon(
                  Icons.logout,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(HomeNavigation.route());
                },
                leading: Icon(
                  Icons.replay_outlined,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  "Reload",
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          ),
          Icon(
            Icons.search_rounded,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          ),
          Icon(
            Icons.account_circle,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          )
        ],
        onTap: (index) {
          setState(() {
            _currentpage = index;
          });
        },
      ),
    );
  }
}
