import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_two/core/constants/constants.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void nevigateProfileScreen(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(user?.profilePic ?? Constants.avatarDefault),
            radius: 70,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'u/${user?.name ?? "User"}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Divider(
            thickness: 0.3,
            color: Colors.red.withOpacity(0.3),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My profile'),
            onTap: () {
              nevigateProfileScreen(context, user!.uid);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            title: const Text('Log out'),
            onTap: () {
              logOut(ref);
            },
          ),
          Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
              onChanged: (v) {
                toggleTheme(ref);
              })
        ],
      )),
    );
  }
}
