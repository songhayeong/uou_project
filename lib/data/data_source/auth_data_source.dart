import 'package:detail_location_detector/di/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthDataSource {
  final FirebaseService _firebaseService;

  const AuthDataSource(this._firebaseService);

  // user class 중복발생 여기서는 firebase auth의 user를 사용해야함.
  Future<User> registerUser(String email, String password, String name) async {
    final UserCredential userCredential = await _firebaseService.auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
      User? updateUser = _firebaseService.auth.currentUser;

      if (updateUser == null) throw Exception('User registration failed');
      return updateUser;
    } else {
      throw Exception('User registration failed');
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseService.auth
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;

    if (user != null) {
      return user;
    } else {
      throw Exception('Sign in failed');
    }
  }

  Future<User> getCurrentUser() async {
    final User? user = _firebaseService.auth.currentUser;

    if (user != null) {
      return user;
    } else {
      throw Exception('No user logged in');
    }
  }


  Future<bool> isSignedIn() async {
    final User? user = _firebaseService.auth.currentUser;
    return user != null;
  }

  Future<void> signOut() => _firebaseService.auth.signOut();
}
