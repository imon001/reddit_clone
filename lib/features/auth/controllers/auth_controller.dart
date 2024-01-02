import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void singInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.singInWithGoogle(isFromLogin);
    state = false;

    user.fold(
      (l) => showSnackBar(context, l.msg),
      (usermodel) => _ref.read(userProvider.notifier).update((state) => usermodel),
    );
  }

  //
  ////
  ///
  ///
  ///
  //
  void singInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.singInAsGuest();
    state = false;

    user.fold(
      (l) => showSnackBar(context, l.msg),
      (usermodel) => _ref.read(userProvider.notifier).update((state) => usermodel),
    );
  }

  ///
  ///
  ///
  ///
  ///
  ///

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}

//
//

//
//
//

//
final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});
//
final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});
//
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
//
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.getUserData(uid);
});
