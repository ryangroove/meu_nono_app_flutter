import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool senhaVisivel = false;
  bool carregando = false;
  String? erroLogin;

  void alternarVisibilidadeSenha() {
    senhaVisivel = !senhaVisivel;
    notifyListeners();
  }

  bool get camposValidos =>
      emailController.text.trim().isNotEmpty &&
      senhaController.text.isNotEmpty &&
      !carregando;

  Future<Usuario?> autenticar() async {
    if (!camposValidos) return null;

    try {
      carregando = true;
      erroLogin = null;
      notifyListeners();

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      final usuario = await DatabaseService().buscarPerfil(cred.user!.uid);

      carregando = false;
      notifyListeners();
      return usuario;
    } on FirebaseAuthException catch (e) {
      carregando = false;

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        erroLogin = 'E-mail ou senha incorretos.';
      } else {
        erroLogin = 'Erro ao realizar login. Tente novamente.';
      }

      notifyListeners();
      return null;
    } catch (_) {
      carregando = false;
      erroLogin = 'Erro ao realizar login. Tente novamente.';
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
