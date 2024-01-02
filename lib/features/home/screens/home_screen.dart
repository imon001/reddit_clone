import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_two/core/constants/constants.dart';

import '../../../theme/pallete.dart';
import '../../auth/controllers/auth_controller.dart';
import '../delegates/search_community_delegate.dart';
import '../drawer/community_list_drawer.dart';
import '../drawer/profile_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                displayDrawer(context);
              },
              icon: const Icon(Icons.menu));
        }),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(Icons.search)),
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                displayEndDrawer(context);
              },
              child: CircleAvatar(
                minRadius: 17,
                backgroundImage: NetworkImage(user.profilePic),
              ),
            );
          })
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: isGuest
          ? null
          : BottomNavigationBar(
              selectedItemColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.backgroundColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: '',
                ),
              ],
              onTap: onPageChange,
              currentIndex: _page,
            ),
    );
  }
}
