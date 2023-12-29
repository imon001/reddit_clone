import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../models/post_model.dart';
import '../../theme/pallete.dart';
import '../constants/constants.dart';

class PostCard extends ConsumerWidget {
  const PostCard({required this.post, super.key});
  final Post post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
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
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(post.communityProfilePic),
                                      radius: 26,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'u/${post.userName}',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (user.uid == post.userUid)
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.delete,
                                        color: Pallete.redColor,
                                      ))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.30,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.26,
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
                                  onPressed: () {},
                                  icon: Icon(
                                    Constants.up,
                                    size: 30,
                                    color: post.upVote.contains(user.uid) ? Pallete.redColor : null,
                                  )),
                              Text(
                                '${post.upVote.length - post.downVote.length == 0 ? 'vote' : post.upVote.length - post.downVote.length}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Constants.down,
                                    size: 30,
                                    color: post.downVote.contains(user.uid) ? Pallete.blueColor : null,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
                              Text('${post.commentCount == 0 ? 'Comment' : post.commentCount}'),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
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
