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
  String? selectedTestamento = 'antigoTestamento'; // Novo: Armazena o testamento selecionado
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
        bibliaData = data; // Armazena ambos os testamentos
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
    return bibliaData![selectedTestamento!]; // Retorna os livros do testamento selecionado
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
            texto += '${versiculo['texto']} \n'; // Adiciona o texto do versículo ao resultado
          }
        }
        return texto.trim(); // Retorna o texto formatado
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
                                      value: selectedTestamento,
                                      items: <String>['antigoTestamento', 'novoTestamento']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value == 'antigoTestamento' ? 'Antigo Testamento' : 'Novo Testamento'),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Até:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    DropdownButton<int>(
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

                  // Exibe o texto da Bíblia
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Texto:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              SelectableText(
                                _getTexto(),
                                style: TextStyle(fontSize: _fontSize), 
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Botões de Compartilhar e Copiar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _shareText(_getTexto()),
                        child: Text('Compartilhar'),
                      ),
                      ElevatedButton(
                        onPressed: () => _copyText(_getTexto()),
                        child: Text('Copiar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
