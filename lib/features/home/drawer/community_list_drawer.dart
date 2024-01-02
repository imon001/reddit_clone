import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_two/core/common/sing_in_button.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../models/community_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../community/controller/community_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});
  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunityScreen(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          isGuest
              ? const SingInButton()
              : ListTile(
                  title: const Text('Create a Community'),
                  leading: const Icon(Icons.add),
                  onTap: () {
                    navigateToCreateCommunity(context);
                  },
                ),
          if (!isGuest)
            ref.watch(userCommunitiesProvider).when(
                  data: (data) => Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final community = data[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(community.avatar),
                                ),
                                title: Text('r/${community.name}'),
                                onTap: () {
                                  navigateToCommunityScreen(context, community);
                                },
                              ),
                              Divider(
                                thickness: 0.4,
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ],
                          );
                        }),
                  ),
                  error: (error, stacktrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const LoaderInd(),
                )
        ],
      )),
    );
  }
}
