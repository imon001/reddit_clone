import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../../models/post_model.dart';
import '../controller/post_controller.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends ConsumerStatefulWidget {
  const CommentScreen({required this.postId, super.key});
  final String postId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(context: context, text: commentController.text.trim(), post: post);
    setState(() {
      commentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ref.watch(getPostByIdProvider(widget.postId)).when(
              data: (data) {
                return Column(
                  children: [
                    PostCard(post: data),
                    TextFormField(
                      onFieldSubmitted: (val) => addComment(data),
                      controller: commentController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Comment",
                        border: InputBorder.none,
                      ),
                    ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                          data: (data) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final comment = data[index];

                                  return CommentCard(comment: comment);
                                },
                              ),
                            );
                          },
                          error: (error, stackTrace) => ErrorText(error: error.toString()),
                          loading: () => const LoaderInd(),
                        ),
                  ],
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const LoaderInd(),
            ));
  }
}
