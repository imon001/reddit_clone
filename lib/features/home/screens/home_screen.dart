import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_two/core/constants/constants.dart';

import '../../auth/controllers/auth_controller.dart';
import '../drawer/community_list_drawer.dart';
import '../drawer/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

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
                //showSearch(context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(Icons.search)),
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                displayEndDrawer(context);
              },
              child: CircleAvatar(
                minRadius: 17,
                backgroundImage: NetworkImage(user?.profilePic ?? Constants.avatarDefault),
              ),
            );
          }),
          IconButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logOut();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Center(
        child: Text(
          user?.karma.toString() ?? "0",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
