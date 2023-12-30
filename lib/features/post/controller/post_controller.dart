import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';
import '../../auth/controllers/auth_controller.dart';
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
