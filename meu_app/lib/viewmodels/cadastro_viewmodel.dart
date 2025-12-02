import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroViewModel extends ChangeNotifier {
  // Controllers dos campos
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  // Estado de visibilidade das senhas
  bool senhaVisivel = false;
  bool confirmarSenhaVisivel = false;

  // Flags de validação
  bool _nomeValido = false;
  bool _cpfValido = false;
  bool _dataNascimentoValida = false;
  bool _emailValido = false;
  bool _senhaValida = false;
  bool _confirmarSenhaValida = false;

  // Regras da senha (check-list visual)
  bool regraMaiuscula = false;
  bool regraMinuscula = false;
  bool regraNumero = false;
  bool regraEspecial = false;

  // Estado de carregamento/erro
  bool carregando = false;
  String? erroCadastro;

  bool get cpfValido => _cpfValido;

  bool get podeCadastrar =>
      _nomeValido &&
      _cpfValido &&
      _dataNascimentoValida &&
      _emailValido &&
      _senhaValida &&
      _confirmarSenhaValida &&
      !carregando;

  void alternarVisibilidadeSenha() {
    senhaVisivel = !senhaVisivel;
    notifyListeners();
  }

  void alternarVisibilidadeConfirmarSenha() {
    confirmarSenhaVisivel = !confirmarSenhaVisivel;
    notifyListeners();
  }

  void validarNome(String valor) {
    _nomeValido = valor.trim().split(' ').length > 1;
    notifyListeners();
  }

  void validarCpf(String valor) {
    final somenteDigitos = UtilBrasilFields.removeCaracteres(valor);
    _cpfValido = UtilBrasilFields.isCPFValido(somenteDigitos);
    notifyListeners();
  }

  void validarDataNascimento(String valor) {
    _dataNascimentoValida = valor.isNotEmpty;
    notifyListeners();
  }

  void validarEmail(String valor) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    _emailValido = regex.hasMatch(valor.trim());
    notifyListeners();
  }

  void validarSenha(String valor) {
    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'[0-9]');
    final special = RegExp(r'[!@#$%^&*()]');

    regraMaiuscula = upper.hasMatch(valor);
    regraMinuscula = lower.hasMatch(valor);
    regraNumero = digit.hasMatch(valor);
    regraEspecial = special.hasMatch(valor);

    _senhaValida =
        regraMaiuscula && regraMinuscula && regraNumero && regraEspecial;

    validarConfirmarSenha(valor, confirmarSenhaController.text);
    notifyListeners();
  }

  void validarConfirmarSenha(String senha, String confirmar) {
    _confirmarSenhaValida = confirmar.isNotEmpty && senha == confirmar;
    notifyListeners();
  }

  // 🚀 Cadastro direto no FirebaseAuth
  Future<bool> cadastrarUsuario() async {
    if (!podeCadastrar) return false;

    try {
      carregando = true;
      erroCadastro = null;
      notifyListeners();

      // Cadastro no Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      carregando = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      carregando = false;
      if (e.code == 'email-already-in-use') {
        erroCadastro = 'Este e-mail já está em uso.';
      } else if (e.code == 'invalid-email') {
        erroCadastro = 'E-mail inválido.';
      } else if (e.code == 'weak-password') {
        erroCadastro = 'Senha muito fraca.';
      } else {
        erroCadastro = 'Erro ao cadastrar usuário: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      carregando = false;
      erroCadastro = 'Erro inesperado: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    dataNascimentoController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }
}
