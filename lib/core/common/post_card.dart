import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/community/controller/community_controller.dart';
import '../../features/post/controller/post_controller.dart';
import '../../models/post_model.dart';
import '../../theme/pallete.dart';
import '../constants/constants.dart';
import 'error_text.dart';
import 'loader.dart';

class PostCard extends ConsumerWidget {
  const PostCard({required this.post, super.key});
  final Post post;
  void deletePost(BuildContext context, WidgetRef ref) {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upVote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upVote(post);
  }

  void downVote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  void deleteDialogBox(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete post?'),
              actions: [
                IconButton(
                    onPressed: () {
                      Routemaster.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel)),
                IconButton(
                    onPressed: () {
                      deletePost(context, ref);
                      Routemaster.of(context).pop();
                    },
                    icon: const Icon(Icons.delete)),
              ],
            ));
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.userUid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToCommentScreen(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void awardPost(WidgetRef ref, BuildContext context, String award) {
    ref.read(postControllerProvider.notifier).awardPost(
          award: award,
          context: context,
          post: post,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 16,
                        ).copyWith(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(post.communityProfilePic),
                                        radius: 26,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => navigateToCommunity(context),
                                            child: Text(
                                              'r/${post.communityName}',
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () => navigateToUser(context),
                                            child: Text(
                                              'u/${post.userName}',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (user.uid == post.userUid)
                                  IconButton(
                                      onPressed: () {
                                        deleteDialogBox(context, ref);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Pallete.redColor,
                                      ))
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Image.asset(
                                      Constants.awards[post.awards[index]]!,
                                      height: 23,
                                    );
                                  },
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Container(
                                padding: const EdgeInsets.all(4),
                                height: MediaQuery.of(context).size.height * 0.20,
                                width: double.infinity,
                                child: AnyLinkPreview(displayDirection: UIDirection.uiDirectionHorizontal, link: post.link!),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  post.description!,
                                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                                  //textAlign: TextAlign.justify,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  splashRadius: 1,
                                  onPressed: isGuest ? null : () => upVote(ref),
                                  icon: Icon(
                                    Constants.up,
                                    size: 30,
                                    color: post.upVote.contains(user.uid) ? Pallete.redColor : null,
                                  )),
                              Text(
                                '${post.upVote.length - post.downVote.length == 0 ? '0' : post.upVote.length - post.downVote.length}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                  splashRadius: 1,
                                  onPressed: isGuest ? null : () => downVote(ref),
                                  icon: Icon(
                                    Constants.down,
                                    size: 30,
                                    color: post.downVote.contains(user.uid) ? Pallete.blueColor : null,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  splashRadius: 1,
                                  onPressed: () {
                                    navigateToCommentScreen(context);
                                  },
                                  icon: const Icon(Icons.comment)),
                              Text('${post.commentCount == 0 ? '0' : post.commentCount}'),
                            ],
                          ),
                          ref.watch(getCommunityByNameProvider(post.communityName)).when(
                                data: (data) {
                                  if (data.mods.contains(user.uid)) {
                                    return IconButton(
                                      onPressed: () {
                                        deleteDialogBox(context, ref);
                                      },
                                      icon: const Icon(
                                        Icons.admin_panel_settings,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                                error: (error, stackTrace) {
                                  return ErrorText(
                                    error: error.toString(),
                                  );
                                },
                                loading: () => const LoaderInd(),
                              ),
                          if (post.userUid != user.uid && !isGuest)
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                ),
                                                itemCount: user.awards.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final award = user.awards[index];
                                                  return GestureDetector(
                                                    onTap: () => awardPost(ref, context, award),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.asset(Constants.awards[award]!),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ));
                                },
                                icon: const Icon(Icons.card_giftcard))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../models/post_model.dart';

// class PostCard extends ConsumerWidget {
//   const PostCard({required this.post, super.key});
//   final Post post;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return const Center(
//         child: Text(
//       'hello world',
//       style: TextStyle(color: Colors.red, fontSize: 40),
//     ));
//   }
// }
