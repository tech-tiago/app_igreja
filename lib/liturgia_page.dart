import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class LiturgiaPage extends StatefulWidget {
  @override
  _LiturgiaPageState createState() => _LiturgiaPageState();
}

class _LiturgiaPageState extends State<LiturgiaPage> {
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic>? liturgiaData; // Permitir que seja nulo inicialmente
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLiturgiaData(selectedDate);
  }

  Future<void> _fetchLiturgiaData(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    final int dia = date.day;
    final int mes = date.month;
    final response = await http.get(
      Uri.parse('https://liturgiadiaria.site/?dia=$dia&mes=$mes'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Verificando o conteúdo dos dados recebidos
      print("Liturgia Data: $data");

      setState(() {
        liturgiaData = data is Map<String, dynamic> ? data : {};
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        liturgiaData = null; // Definir como nulo se a solicitação falhar
      });
      throw Exception('Failed to load liturgy');
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
    if (liturgiaData == null) return 0; // Retorna 0 se liturgiaData for nulo
    int count = 3; // 1 Leitura, Salmo, Evangelho

    // Verifique se 'segundaLeitura' não é uma string vazia ou a mensagem padrão de ausência de segunda leitura
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

    if (_getTabCount() == 4) { // Se houver segunda leitura, insira após o Salmo
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

    if (_getTabCount() == 4) { // Se houver segunda leitura, insira após o Salmo
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
