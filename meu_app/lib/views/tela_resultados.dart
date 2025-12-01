import 'package:flutter/material.dart';

class TelaResultados extends StatelessWidget {
  final Map<String, dynamic> resultados;
  final String nomeUsuario;

  const TelaResultados({
    super.key,
    required this.resultados,
    required this.nomeUsuario,
  });

  @override
  Widget build(BuildContext context) {
    final int caracteresTotal =
    resultados['caracteres_total'] as int;
    final int caracteresSemEspaco =
    resultados['caracteres_sem_espaco'] as int;
    final int palavrasTotal = resultados['palavras_total'] as int;
    final int frasesTotal = resultados['frases_total'] as int;
    final String tempoLeitura =
    resultados['tempo_leitura'] as String;
    final String textoOriginal =
    resultados['texto_original'] as String;
    final List<MapEntry<String, int>> topFrequencia =
    (resultados['top_frequencia'] as List<MapEntry<String, int>>);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Análise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Olá, $nomeUsuario!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aqui estão os resultados da sua análise de texto:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildResultItem('Palavras Totais', '$palavrasTotal'),
            _buildResultItem('Frases Totais', '$frasesTotal'),
            const Divider(),
            _buildResultItem(
              'Caracteres (com espaços)',
              '$caracteresTotal',
            ),
            _buildResultItem(
              'Caracteres (sem espaços)',
              '$caracteresSemEspaco',
            ),
            const Divider(),
            _buildResultItem(
              'Tempo Médio de Leitura (250 WPM)',
              '$tempoLeitura min',
            ),
            const Divider(height: 30),
            const Text(
              'Top 10 Palavras (Mais Comuns)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(),
            if (topFrequencia.isEmpty)
              const Text(
                'Nenhuma palavra relevante encontrada.',
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            else
              Column(
                children: topFrequencia.map((item) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.key,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${item.value}x',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            const Text(
              'Texto original analisado:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(textoOriginal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
