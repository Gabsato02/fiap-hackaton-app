import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:fiap_hackaton_app/domain/entities/index.dart';

class GlobalState with ChangeNotifier {
  UserInfo? _userInfo;

  UserInfo? get userInfo => _userInfo;

  void setUserInfoFromFirebase(User firebaseUser) {
    _userInfo = UserInfo(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
    notifyListeners();
  }
}
