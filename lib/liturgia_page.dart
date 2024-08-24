import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:intl/intl.dart';

class DiaSemana {
  final DateTime data;

  DiaSemana(String dataStr)
      : data = DateFormat('dd/MM/yyyy').parse(dataStr);

  String diaDaSemana() {
    // Lista com os dias da semana em português
    final List<String> diasDaSemana = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado'
    ];

    // Retorna o nome do dia da semana correspondente
    return diasDaSemana[data.weekday % 7];
  }
}

class LiturgiaPage extends StatefulWidget {
  @override
  _LiturgiaPageState createState() => _LiturgiaPageState();
}

class _LiturgiaPageState extends State<LiturgiaPage> {
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic>? liturgiaData;
  bool isLoading = true;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _fetchLiturgiaData(selectedDate);
  }

  Future<void> _fetchLiturgiaData(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    final String formattedDate = dateFormat.format(date);
    print("Data formatada: $formattedDate");

    final int dia = date.day;
    final int mes = date.month;
    final response = await http.get(
      Uri.parse('https://liturgiadiaria.site/?dia=$dia&mes=$mes'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("Liturgia Data: $data");

      setState(() {
        liturgiaData = data is Map<String, dynamic> ? data : {};
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        liturgiaData = null;
      });
      throw Exception('Falha ao carregar a liturgia');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _fetchLiturgiaData(selectedDate);
    }
  }

Widget _buildLiturgiaHeader() {
  final String corLiturgia = liturgiaData?['cor'] ?? 'Cor não disponível';
  final String tempoSemana = liturgiaData?['liturgia'] ?? 'Liturgia não disponível';
  final String dataLeitura = liturgiaData?['data'] ?? 'Data não disponível';

  // Converte a data para o dia da semana
  String diaSemana = DiaSemana(dataLeitura).diaDaSemana();

  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,  // Centraliza todos os textos
      children: [
        Text(
          dataLeitura,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          'Cor Litúrgica: $corLiturgia',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        SizedBox(height: 8),
        Text(
          '$tempoSemana | $diaSemana',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : liturgiaData != null
              ? DefaultTabController(
                  length: _getTabCount(),
                  child: Column(
                    children: [
                      _buildLiturgiaHeader(),
                      TabBar(
                        tabs: _buildTabs(),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: _buildTabViews(),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text('No data available for the selected date.'),
                ),
    );
  }

  int _getTabCount() {
    if (liturgiaData == null) return 0;
    int count = 3;

    if (liturgiaData!.containsKey('segundaLeitura') &&
        liturgiaData!['segundaLeitura'] != null &&
        liturgiaData!['segundaLeitura'] is Map &&
        liturgiaData!['segundaLeitura']['texto'] != 'Não há segunda leitura hoje!') {
      count = 4;
    }
    return count;
  }

  List<Widget> _buildTabs() {
    if (liturgiaData == null) return [];
    List<Widget> tabs = [
      Tab(text: '1 LEITURA'),
      Tab(text: 'SALMO'),
      Tab(text: 'EVANGELHO'),
    ];

    if (_getTabCount() == 4) {
      tabs.insert(1, Tab(text: '2 LEITURA'));
    }

    return tabs;
  }

  List<Widget> _buildTabViews() {
    if (liturgiaData == null) return [];
    List<Widget> views = [
      _buildLeituraView('primeiraLeitura'),
      _buildSalmoView(),
      _buildEvangelhoView(),
    ];

    if (_getTabCount() == 4) {
      views.insert(1, _buildLeituraView('segundaLeitura'));
    }

    return views;
  }

  Widget _buildLeituraView(String leituraKey) {
    if (liturgiaData == null || !liturgiaData!.containsKey(leituraKey)) {
      return Center(child: Text('No data available.'));
    }

    final leitura = liturgiaData![leituraKey];

    if (leitura is Map) {
      final referencia = leitura['referencia'] ?? '';
      final titulo = leitura['titulo'] ?? 'Sem título';
      final texto = leitura['texto'] ?? 'Sem texto disponível';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$titulo ($referencia)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '- Palavra do Senhor.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Graças a Deus.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return Center(child: Text('Formato de dados inválido.'));
    }
  }

  Widget _buildSalmoView() {
    if (liturgiaData == null || !liturgiaData!.containsKey('salmo')) {
      return Center(child: Text('No data available.'));
    }

    final salmo = liturgiaData!['salmo'];

    if (salmo is Map) {
      final referencia = salmo['referencia'] ?? '';
      final refrao = salmo['refrao'] ?? 'Sem refrão';
      final texto = salmo['texto'] ?? 'Sem texto disponível';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsório ($referencia)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '— $refrao',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    } else {
      return Center(child: Text('Formato de dados inválido.'));
    }
  }

  Widget _buildEvangelhoView() {
    if (liturgiaData == null || !liturgiaData!.containsKey('evangelho')) {
      return Center(child: Text('No data available.'));
    }

    final evangelho = liturgiaData!['evangelho'];

    if (evangelho is Map) {
      final referencia = evangelho['referencia'] ?? '';
      final titulo = evangelho['titulo'] ?? 'Sem título';
      final texto = evangelho['texto'] ?? 'Sem texto disponível';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$titulo ($referencia)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '- Palavra da Salvação.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Glória a vós, Senhor.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return Center(child: Text('Formato de dados inválido.'));
    }
  }
}
