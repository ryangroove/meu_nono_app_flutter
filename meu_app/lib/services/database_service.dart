import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final _usuarios = FirebaseFirestore.instance.collection('usuarios');

  Future<void> salvarPerfilUsuario({
    required String uid,
    required String nomeCompleto,
    required String cpf,
    required String dataNascimento,
    required String email,
  }) async {
    final usuario = Usuario(
      id: null,
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      dataNascimento: dataNascimento,
      email: email,
      senhaHash: '', // pode ignorar/retirar depois
    );

    await _usuarios.doc(uid).set(usuario.toMap());
  }

  Future<Usuario?> buscarPerfil(String uid) async {
    final doc = await _usuarios.doc(uid).get();
    if (!doc.exists) return null;
    return Usuario.fromMap(doc.data()!);
  }
}
