import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/user_model.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _user => _firestore.collection(FireBaseConstants.usersCollection);
  void singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User customeUser = userCredential.user!;

      if (userCredential.additionalUserInfo!.isNewUser) {
        UserModel userModel = UserModel(
          name: customeUser.displayName ?? "User",
          profilePic: customeUser.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: customeUser.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );
        await _user.doc(customeUser.uid).set(userModel.toMap());
      }
      print(customeUser.email);
    } catch (e) {
      print(e.toString());
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(fireStoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(
      googleSingInProvider,
    )));
