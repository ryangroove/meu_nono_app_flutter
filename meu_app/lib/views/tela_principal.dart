import 'package:flutter/material.dart';

import '../models/usuario.dart';
import 'tela_resultados.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  const TelaPrincipal({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController _controladorTexto = TextEditingController();
  Map<String, dynamic>? _analiseResultados;

  static const Set<String> _stopWords = {
    'a',
    'o',
    'que',
    'de',
    'para',
    'com',
    'sem',
    'mas',
    'e',
    'ou',
    'entre',
    'em',
    'por',
    'da',
    'do',
    'as',
    'os',
    'se',
    'no',
    'na',
  };

  static const int _wpm = 250;

  Map<String, dynamic> _realizarAnalise(String textoParaAnalise) {
    final textoNormalizado = textoParaAnalise.toLowerCase();

    final numCaracteresTotal = textoParaAnalise.length;

    final numCaracteresSemEspaco =
        textoParaAnalise.replaceAll(RegExp(r'\s'), "").length;

    final palavrasLista = textoNormalizado.split(RegExp(r'\s+'));

    final palavrasValidas =
    palavrasLista.where((p) => p.isNotEmpty).toList();

    final numPalavras = palavrasValidas.length;

    final numFrases = textoParaAnalise
        .split(RegExp(r'[.!?](?=\s+|$)'))
        .where((s) => s.trim().isNotEmpty)
        .length;

    final Map<String, int> frequencia = {};

    final RegExp pontuacaoRegex =
    RegExp(r'[^\w\s\u00C0-\u017F]', unicode: true);

    for (var palavra in palavrasValidas) {
      final palavraLimpa = palavra.replaceAll(pontuacaoRegex, "");

      if (palavraLimpa.isNotEmpty && !_stopWords.contains(palavraLimpa)) {
        frequencia[palavraLimpa] =
            (frequencia[palavraLimpa] ?? 0) + 1;
      }
    }

    final listaFrequenciaOrdenada = frequencia.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top10Frequencia = listaFrequenciaOrdenada.take(10).toList();

    final tempoLeituraMinutos = numPalavras / _wpm;
    final tempoFormatado = numPalavras == 0
        ? 0.0
        : double.parse(tempoLeituraMinutos.toStringAsFixed(2));

    final tempoLeitura = tempoFormatado < 0.01 && numPalavras > 0
        ? '<0.01'
        : '$tempoFormatado';

    return {
      'caracteres_total': numCaracteresTotal,
      'caracteres_sem_espaco': numCaracteresSemEspaco,
      'palavras_total': numPalavras,
      'frases_total': numFrases,
      'top_frequencia': top10Frequencia,
      'tempo_leitura': tempoLeitura,
      'texto_original': textoParaAnalise,
    };
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _analisarTexto() {
    final texto = _controladorTexto.text.trim();

    if (texto.isEmpty) {
      _analiseResultados = null;
      _showSnackBar(
        'O campo de texto está vazio. Digite algo para analisar.',
        color: Colors.orange,
      );
      setState(() {});
      return;
    }

    final resultado = _realizarAnalise(texto);

    setState(() {
      _analiseResultados = resultado;
    });

    _showSnackBar('Análise de texto concluída com sucesso!');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaResultados(
          resultados: resultado,
          nomeUsuario: widget.usuario.nomeCompleto,
        ),
      ),
    );
  }

  void _limparTexto() {
    if (_controladorTexto.text.isEmpty && _analiseResultados == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Limpeza'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Tem certeza que deseja limpar todo o texto e os resultados da análise?',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Esta ação não pode ser desfeita.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _controladorTexto.clear();
                _analiseResultados = null;
              });
              _showSnackBar(
                'Texto e resultados da análise foram limpos.',
                color: Colors.red,
              );
            },
            child: const Text(
              'Limpar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisador de Texto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo, ${widget.usuario.nomeCompleto}!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: TextField(
                controller: _controladorTexto,
                decoration: const InputDecoration(
                  hintText: "Digite seu texto aqui...",
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analisarTexto,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Analisar'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _limparTexto,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text(
                'Limpar Texto',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 30,
        alignment: Alignment.center,
        color: Colors.blue.shade50,
        child: const Text(
          "Produzido por Luiz Alberto",
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
    );
  }
}
