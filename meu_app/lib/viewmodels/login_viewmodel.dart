import 'package:flutter/material.dart';

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

      final usuario = await DatabaseService().autenticarUsuario(
        email: emailController.text.trim(),
        senhaPura: senhaController.text,
      );

      carregando = false;

      if (usuario == null) {
        erroLogin = 'E-mail ou senha incorretos.';
      }

      notifyListeners();
      return usuario;
    } catch (e) {
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
