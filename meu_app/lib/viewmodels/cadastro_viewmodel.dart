import 'package:firebase_auth/firebase_auth.dart';
import 'package:brasil_fields/brasil_fields.dart';
import '../services/database_service.dart';

// resto da classe...

Future<bool> cadastrarUsuario() async {
  if (!podeCadastrar) return false;

  try {
    carregando = true;
    erroCadastro = null;
    notifyListeners();

    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: senhaController.text,
    );

    await DatabaseService().salvarPerfilUsuario(
      uid: cred.user!.uid,
      nomeCompleto: nomeController.text.trim(),
      cpf: UtilBrasilFields.removeCaracteres(cpfController.text.trim()),
      dataNascimento: dataNascimentoController.text.trim(),
      email: emailController.text.trim(),
    );

    carregando = false;
    notifyListeners();
    return true;
  } on FirebaseAuthException catch (e) {
    carregando = false;

    if (e.code == 'email-already-in-use') {
      erroCadastro = 'Este e-mail já está em uso.';
    } else if (e.code == 'weak-password') {
      erroCadastro = 'Senha muito fraca.';
    } else {
      erroCadastro = 'Erro ao cadastrar. Tente novamente.';
    }

    notifyListeners();
    return false;
  } catch (_) {
    carregando = false;
    erroCadastro = 'Erro ao cadastrar. Tente novamente.';
    notifyListeners();
    return false;
  }
}
