import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  void singInWithGoogle() async {
    _authRepository.singInWithGoogle();
  }
}

final authControllerProvider = Provider((ref) => AuthController(authRepository: ref.read(authRepositoryProvider)));
