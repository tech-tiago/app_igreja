import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class BibliaPage extends StatefulWidget {
  @override
  _BibliaPageState createState() => _BibliaPageState();
}

class _BibliaPageState extends State<BibliaPage> {
  Map<String, dynamic>? bibliaData;
  String? selectedTestamento = 'antigoTestamento';
  String? selectedNome;
  int? selectedCapitulo;
  int? selectedVersiculoInicial; 
  int? selectedVersiculoFinal; 
  bool isLoading = true;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadBibliaData();
  }

  Future<void> _loadBibliaData() async {
    try {
      final String response = await rootBundle.loadString('assets/json/bibliaAveMaria.json');
      final data = json.decode(response);

      setState(() {
        bibliaData = data;
        selectedNome = bibliaData![selectedTestamento!]!.first['nome'];
        selectedCapitulo = 1;
        selectedVersiculoInicial = 1; 
        selectedVersiculoFinal = 10; 
        isLoading = false;
      });
    } catch (error) {
      print('Erro ao carregar os dados da Bíblia: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> _getLivros() {
    return bibliaData![selectedTestamento!];
  }

  List<int> _getCapitulos() {
    if (selectedNome != null) {
      final livro = _getLivros().firstWhere((livro) => livro['nome'] == selectedNome);
      return List<int>.generate(
        livro['capitulos'].length,
        (index) => index + 1,
      );
    }
    return [];
  }

  List<int> _getVersiculos() {
    if (selectedNome != null && selectedCapitulo != null) {
      final livro = _getLivros().firstWhere((livro) => livro['nome'] == selectedNome);
      final capitulos = livro['capitulos'];
      if (capitulos.isNotEmpty) {
        final versiculos = capitulos[selectedCapitulo! - 1]['versiculos'];
        return List<int>.generate(versiculos.length, (index) => versiculos[index]['versiculo']);
      }
    }
    return [];
  }

  List<int> _getVersiculosIntervalo() {
    final versiculos = _getVersiculos();
    if (selectedVersiculoInicial != null && selectedVersiculoFinal != null) {
      return versiculos.where((versiculo) => versiculo >= selectedVersiculoInicial! && versiculo <= selectedVersiculoFinal!).toList();
    }
    return [];
  }

  String _getTexto() {
    if (selectedNome != null && selectedCapitulo != null) {
      final livro = _getLivros().firstWhere((livro) => livro['nome'] == selectedNome);
      final capitulos = livro['capitulos'];
      if (capitulos.isNotEmpty) {
        final versiculos = capitulos[selectedCapitulo! - 1]['versiculos'];
        String texto = '';
        for (var versiculo in versiculos) {
          if (versiculo['versiculo'] >= selectedVersiculoInicial! && versiculo['versiculo'] <= selectedVersiculoFinal!) {
            texto += '${versiculo['texto']} \n';
          }
        }
        return texto.trim();
      }
    }
    return 'Texto não encontrado';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bloco de seleção de Testamento, Livro, Capítulo e Versículo
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Testamento e Livro em uma linha
                          Row(
                            children: [
                              // Testamento
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Testamento:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedTestamento,
                                      items: <String>['antigoTestamento', 'novoTestamento']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value == 'antigoTestamento' ? 'Antigo Testamento' : 'Novo Testamento',
                                          style: TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedTestamento = newValue!;
                                          selectedNome = bibliaData![selectedTestamento!]!.first['nome'];
                                          selectedCapitulo = 1;
                                          selectedVersiculoInicial = 1;
                                          selectedVersiculoFinal = 10;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              // Livro
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Livro:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedNome,
                                      items: _getLivros().map<DropdownMenuItem<String>>((dynamic livro) {
                                        return DropdownMenuItem<String>(
                                          value: livro['nome'],
                                          child: Text(
                                            livro['nome'],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedNome = newValue!;
                                          selectedCapitulo = 1;
                                          selectedVersiculoInicial = 1;
                                          selectedVersiculoFinal = 10;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Linha com Capítulo, Versículo e Até
                          Row(
                            children: [
                              // Primeiro select (Capítulo)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Capítulo:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    DropdownButton<int>(
                                      isExpanded: true,
                                      value: selectedCapitulo,
                                      items: _getCapitulos().map<DropdownMenuItem<int>>((int capitulo) {
                                        return DropdownMenuItem<int>(
                                          value: capitulo,
                                          child: Text(
                                            capitulo.toString(),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedCapitulo = newValue;
                                          selectedVersiculoInicial = 1;
                                          selectedVersiculoFinal = 10;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),

                              // Segundo select (Versículo Inicial)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Versículo:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    DropdownButton<int>(
                                      isExpanded: true,
                                      value: selectedVersiculoInicial,
                                      items: _getVersiculos().map<DropdownMenuItem<int>>((int versiculo) {
                                        return DropdownMenuItem<int>(
                                          value: versiculo,
                                          child: Text(
                                            versiculo.toString(),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedVersiculoInicial = newValue;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),

                              // Último select 
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0,
                                      child: Text(
                                        'Versículo:',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'a',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(width: 10), 
                                        Expanded( 
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            value: selectedVersiculoFinal,
                                            items: _getVersiculos().map<DropdownMenuItem<int>>((int versiculo) {
                                              return DropdownMenuItem<int>(
                                                value: versiculo,
                                                child: Text(
                                                  versiculo.toString(),
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                selectedVersiculoFinal = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Texto, controle de slider e botões de ação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Slider para controle do tamanho do texto
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.text_fields),
                            Slider(
                              value: _fontSize,
                              min: 12.0,
                              max: 32.0,
                              onChanged: (double value) {
                                setState(() {
                                  _fontSize = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // Botões de compartilhamento e cópia
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () => _shareText(_getTexto()),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () => _copyText(_getTexto()),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Texto bíblico com o tamanho ajustável
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _getTexto(),
                        style: TextStyle(fontSize: _fontSize),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
