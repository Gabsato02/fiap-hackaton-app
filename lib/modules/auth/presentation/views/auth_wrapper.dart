import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiap_hackaton_app/main.dart';
import 'package:fiap_hackaton_app/modules/login/presentation/views/login.dart';
import 'package:fiap_hackaton_app/store/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fiap_hackaton_app/firebase_options.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as mudanças no estado de autenticação do Firebase
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto verifica, mostra um indicador de carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Se o snapshot tem dados, significa que o usuário está logado
        if (snapshot.hasData && snapshot.data != null) {
          // Garante que o estado global tenha as informações do usuário
          // e então mostra a tela principal (Home)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final user = snapshot.data!;
            context.read<GlobalState>().setUserInfoFromFirebase(user);
          });
          return const HomeTabs();
        }

        // Se não há dados, o usuário não está logado, então mostra a tela de Login
        return Login(clientId: DefaultFirebaseOptions.currentPlatform.apiKey);
      },
    );
  }
}
