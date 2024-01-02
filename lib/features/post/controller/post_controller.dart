import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/enums/enums.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/comment_model.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../user_profile/controller/user_profile_controller.dart';
import '../repository/post_repository.dart';

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider);
    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      userName: user!.name,
      userUid: user.uid,
      type: 'text',
      commentCount: 0,
      createdAt: DateTime.now(),
      upVote: [],
      downVote: [],
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.textPost);

    state = false;
    res.fold((l) => showSnackBar(context, l.msg), (r) {
      showSnackBar(context, 'Posted successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider);
    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      userName: user!.name,
      userUid: user.uid,
      type: 'link',
      commentCount: 0,
      createdAt: DateTime.now(),
      upVote: [],
      downVote: [],
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.linkPost);

    state = false;
    res.fold((l) => showSnackBar(context, l.msg), (r) {
      showSnackBar(context, 'Posted successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider);
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.msg), (r) async {
      final post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        userName: user!.name,
        userUid: user.uid,
        type: 'image',
        commentCount: 0,
        createdAt: DateTime.now(),
        upVote: [],
        downVote: [],
        awards: [],
        link: r,
      );

      final res = await _postRepository.addPost(post);
      _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.imagePost);

      state = false;
      res.fold((l) => showSnackBar(context, l.msg), (r) {
        showSnackBar(context, 'Posted successfully');
        Routemaster.of(context).pop();
      });
    });
  }

  //
  //
  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPost(communities);
    }
    return Stream.value([]);
  }

  //
  void deletePost(BuildContext context, Post post) async {
    final res = await _postRepository.deletePost(post);
    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.deletePost);

    res.fold((l) => showSnackBar(context, l.msg), (r) => showSnackBar(context, "Post deleted successfully."));
  }

//
  void upVote(
    Post post,
  ) async {
    final uId = _ref.read(userProvider)!.uid;
    _postRepository.upVote(post, uId);
  }

  void downVote(
    Post post,
  ) async {
    final uId = _ref.read(userProvider)!.uid;
    _postRepository.downVote(post, uId);
  }

  //
  //
  //
  //
  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  //
  //
  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();

    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      userName: user.name,
      profilePic: user.profilePic,
    );
    final res = await _postRepository.addComment(comment);

    _ref.watch(userProfileControllerProvider.notifier).updateKarma(UserKarma.comment);

    res.fold((l) => showSnackBar(context, l.msg), (r) => null);
  }

  //
  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.getPostComments(postId);
  }

  //
  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);
    res.fold((l) => showSnackBar(context, l.msg), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }

  //
  //
  Stream<List<Post>> fetchGuestPost() {
    return _postRepository.fetchGuestPosts();
  }
}

//
//
//
//
final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    ref: ref,
    storageRepository: storageRepository,
    postRepository: postRepository,
  );
});
//

final userPostsProvider = StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPost(communities);
});

//
final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchPostComments(postId);
});
//
//
final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPost();
});
