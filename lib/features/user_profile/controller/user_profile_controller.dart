import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../repository/user_profile_repository.dart';

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _profileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository profileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _profileRepository = profileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required BuildContext context,
    required File? avatarFile,
    required File? bannerFile,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (avatarFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: avatarFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.msg),
        (r) => user = user.copyWith(profilePic: r),
      );
    }
    //
    //
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.msg),
        (r) => user = user.copyWith(banner: r),
      );
    }
    //
    //
    user = user.copyWith(name: name);
    //
    //
    final res = await _profileRepository.editUserProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.msg),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }
}

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    ref: ref,
    storageRepository: storageRepository,
    profileRepository: userProfileRepository,
  );
});
