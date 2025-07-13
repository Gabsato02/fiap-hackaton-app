import 'package:flutter/material.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:provider/provider.dart';
import 'package:fiap_hackaton_app/store/index.dart';

class Login extends StatelessWidget {
  const Login({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context) {
    void onSignedIn() {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        context.read<GlobalState>().setUserInfoFromFirebase(firebaseUser);
      }
    }

    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: clientId),
      ],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          onSignedIn();
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          onSignedIn();
        }),
      ],
    );
  }
}
