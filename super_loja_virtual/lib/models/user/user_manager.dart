import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:super_loja_virtual/helpers/firebase_errors.dart';
import 'package:super_loja_virtual/models/user/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;
  User user;

  bool _loading = false;
  bool _loadingFacebook = false;

  bool get loadingFacebook => _loadingFacebook;

  set loadingFacebook(bool value) {
    _loadingFacebook = value;
    notifyListeners();
  }

  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn(
      {@required User user, Function onSuccess, Function onFail}) async {
    try {
      loading = true;
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.pass);

      _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp(
      {@required User user, Function onSuccess, Function onFail}) async {
    try {
      loading = true;
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.pass);

      user.id = result.user.uid;
      this.user = user;

      await user.saveDate();
      user.saveToken();
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot doc =
          await firestore.collection("users").document(currentUser.uid).get();
      user = User.fromDocument(doc);
      final docAdmin =
          await firestore.collection('admins').document(user.id).get();
      if (docAdmin.exists) {
        user.admin = true;
      }

      user.saveToken();
      notifyListeners();
    }
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get adminEnabled => user != null && user.admin;

  Future<void> facebookLogin({Function onSuccess, Function onFail}) async {
    loadingFacebook = true;
    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );

        final authResult = await auth.signInWithCredential(credential);

        if (authResult.user != null) {
          final firebaseUser = authResult.user;

          user = User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email);

          await user.saveDate();
          user.saveToken();
        }

        onSuccess();
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    loadingFacebook = false;
  }
}
