import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert'; // Para decodificar JSON

class OracoesPage extends StatefulWidget {
  @override
  _OracoesPageState createState() => _OracoesPageState();
}

class _OracoesPageState extends State<OracoesPage> {
  Map<String, dynamic>? oracoesData;
  bool isLoading = true;
  double _fontSize = 16.0; // Tamanho inicial da fonte

  @override
  void initState() {
    super.initState();
    _fetchOracoesData();
  }

  Future<void> _fetchOracoesData() async {
    try {
      // Carrega o arquivo JSON local da pasta assets
      String jsonString = await rootBundle.loadString('assets/json/oracoes.json');
      setState(() {
        oracoesData = json.decode(jsonString); // Decodifica o conteúdo JSON
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        oracoesData = null;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Número de abas para as 5 orações
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true, // Centraliza o título
          title: Text(
            'Orações Eucarísticas',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Define o texto como negrito
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'I'),
              Tab(text: 'II'),
              Tab(text: 'III'),
              Tab(text: 'IV'),
              Tab(text: 'V'),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : oracoesData != null
                ? Column(
                    children: [
                      Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 6,
                        label: _fontSize.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _fontSize = value;
                          });
                        },
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildOracaoView('oracao1'),
                            _buildOracaoView('oracao2'),
                            _buildOracaoView('oracao3'),
                            _buildOracaoView('oracao4'),
                            _buildOracaoView('oracao5'),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text('Oração não encontrada.')),
                    ],
                  ),
      ),
    );
  }

  Widget _buildOracaoView(String key) {
    final oracao = oracoesData?[key];
    if (oracao == null) {
      return Center(child: Text('Oração não encontrada.'));
    }

    // Aqui fazemos o tratamento para estilizar as partes do texto
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: oracao['texto']
            .split('\n')
            .map<Widget>((line) => _formatLine(line))
            .toList(),
      ),
    );
  }

  Widget _formatLine(String line) {
    if (line.startsWith('PR:')) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'PR: ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: _fontSize,
              ),
            ),
            TextSpan(
              text: line.replaceFirst('PR:', ''),
              style: TextStyle(
                color: Colors.black,
                fontSize: _fontSize,
              ),
            ),
          ],
        ),
      );
    } else if (line.startsWith('AS:')) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'AS: ',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: _fontSize,
              ),
            ),
            TextSpan(
              text: line.replaceFirst('AS:', ''),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: _fontSize,
              ),
            ),
          ],
        ),
      );
    } else if (line.contains(RegExp(r'^Santo, Santo, Santo|O céu e a terra proclamam|Hosana nas alturas!|Bendito o que vem em nome do Senhor!'))) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          line,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    } else if (line.contains(RegExp(r'^Mistério da fé!$|^Mistério da fé e do amor!$|^Mistério da fé para a salvação do mundo!$'))) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          line,
          style: TextStyle(
            fontSize: _fontSize + 2,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    } else if (line.contains(RegExp(r'^TOMAI, TODOS, E COMEI|^TOMAI, TODOS, E BEBEI'))) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          line,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    } else if (line.startsWith('“')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          line,
          style: TextStyle(
            fontSize: _fontSize,
            color: Colors.red,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          line,
          style: TextStyle(
            fontSize: _fontSize,
            color: Colors.black,
          ),
        ),
      );
    }
  }
}
