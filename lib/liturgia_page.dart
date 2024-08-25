import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class DiaSemana {
  final DateTime data;

  DiaSemana(String dataStr)
      : data = DateFormat('dd/MM/yyyy').parse(dataStr);

  String diaDaSemana() {
    final List<String> diasDaSemana = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado'
    ];
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
  double fontSize = 16.0; // Tamanho inicial do texto

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
    final int dia = date.day;
    final int mes = date.month;
    final response = await http.get(
      Uri.parse('https://liturgiadiaria.site/?dia=$dia&mes=$mes'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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

  void _zoomIn() {
    setState(() {
      fontSize += 2;
    });
  }

  void _zoomOut() {
    setState(() {
      if (fontSize > 10) fontSize -= 2;
    });
  }

  void _shareText(String text) {
    Share.share(text);
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Texto copiado para a área de transferência")),
    );
  }

  Widget _buildLiturgiaHeader() {
    final String corLiturgia = liturgiaData?['cor'] ?? 'Cor não disponível';
    final String tempoSemana = liturgiaData?['liturgia'] ?? 'Liturgia não disponível';
    final String dataLeitura = liturgiaData?['data'] ?? 'Data não disponível';

    String diaSemana = DiaSemana(dataLeitura).diaDaSemana();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => _shareText('$titulo ($referencia)\n\n$texto'),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => _copyText('$titulo ($referencia)\n\n$texto'),
                ),
              ],
            ),
            Text(
              '$titulo ($referencia)',
              style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(height: 20),
            Text(
              '- Palavra do Senhor.',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Graças a Deus.',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => _shareText('Responsório ($referencia)\n\n$refrao\n\n$texto'),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => _copyText('Responsório ($referencia)\n\n$refrao\n\n$texto'),
                ),
              ],
            ),
            Text(
              'Responsório ($referencia)',
              style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '— $refrao',
              style: TextStyle(fontSize: fontSize, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(fontSize: fontSize),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => _shareText('$titulo ($referencia)\n\n$texto'),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => _copyText('$titulo ($referencia)\n\n$texto'),
                ),
              ],
            ),
            Text(
              '$titulo ($referencia)',
              style: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              texto,
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(height: 20),
            Text(
              '- Palavra da Salvação.',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Glória a vós, Senhor.',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return Center(child: Text('Formato de dados inválido.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
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
    int count = 3;

    if (liturgiaData != null &&
        liturgiaData!.containsKey('segundaLeitura') &&
        liturgiaData!['segundaLeitura'] != null &&
        liturgiaData!['segundaLeitura'] is Map &&
        liturgiaData!['segundaLeitura']['texto'] != 'Não há segunda leitura hoje!') {
      count = 4;
    }

    return count;
  }

List<Widget> _buildTabs() {
  List<Widget> tabs = [
    Tab(child: Text('1 LEITURA', style: TextStyle(fontSize: 10))),
    Tab(child: Text('SALMO', style: TextStyle(fontSize: 10))),
  ];

  if (_getTabCount() == 4) {
    tabs.add(Tab(child: Text('2 LEITURA', style: TextStyle(fontSize: 10))));
  }

  tabs.add(Tab(child: Text('EVANGELHO', style: TextStyle(fontSize: 10))));

  return tabs;
}


  List<Widget> _buildTabViews() {
    List<Widget> views = [
      _buildLeituraView('primeiraLeitura'),
      _buildSalmoView(),
    ];

    if (_getTabCount() == 4) {
      views.add(_buildLeituraView('segundaLeitura'));
    }

    views.add(_buildEvangelhoView());

    return views;
  }
}
