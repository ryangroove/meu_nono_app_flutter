import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usuario.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final _usuarios = FirebaseFirestore.instance.collection('usuarios');

  String gerarHashSenha(String senhaPura) {
    final bytes = utf8.encode(senhaPura);
    return sha256.convert(bytes).toString();
  }

  Future<void> cadastrarUsuario({
    required String nomeCompleto,
    required String cpf,
    required String dataNascimento,
    required String email,
    required String senhaPura,
  }) async {
    final senhaHash = gerarHashSenha(senhaPura);

    final usuario = Usuario(
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      dataNascimento: dataNascimento,
      email: email,
      senhaHash: senhaHash,
    );

    // verifica se já existe usuário com esse e-mail
    final jaExiste = await _usuarios
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (jaExiste.docs.isNotEmpty) {
      throw Exception('E-mail já cadastrado');
    }

    // grava usando o toMap(), que já usa 'senha_hash'
    await _usuarios.add(usuario.toMap());
  }

  Future<Usuario?> autenticarUsuario({
    required String email,
    required String senhaPura,
  }) async {
    final senhaHash = gerarHashSenha(senhaPura);

    // mesmos campos usados no toMap(): email e senha_hash
    final query = await _usuarios
        .where('email', isEqualTo: email)
        .where('senha_hash', isEqualTo: senhaHash)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null; // e-mail ou senha incorretos
    }

    final data = query.docs.first.data();
    return Usuario.fromMap(data);
  }
}
