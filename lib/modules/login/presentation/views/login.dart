import 'package:flutter/material.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Login extends StatelessWidget {
  const Login({super.key, required this.clientId});

  final String clientId;

  @override
  Widget build(BuildContext context) {
    void onSignedIn() {
      Navigator.pushReplacementNamed(context, '/home');
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
