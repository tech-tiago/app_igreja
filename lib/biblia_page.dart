import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class BibliaPage extends StatefulWidget {
  @override
  _BibliaPageState createState() => _BibliaPageState();
}

class _BibliaPageState extends State<BibliaPage> {
  List<dynamic>? bibliaData;
  String? selectedNome;
  int? selectedCapitulo;
  int? selectedVersiculoInicial; // Novo para versículo inicial
  int? selectedVersiculoFinal; // Novo para versículo final
  bool isLoading = true;
  double _fontSize = 16.0; // Variável para o tamanho da fonte

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
        bibliaData = data['antigoTestamento'];
        selectedNome = bibliaData!.first['nome'];
        selectedCapitulo = 1;
        selectedVersiculoInicial = 1; // Inicializa versículo inicial
        selectedVersiculoFinal = 10; // Inicializa versículo final
        isLoading = false;
      });
    } catch (error) {
      print('Erro ao carregar os dados da Bíblia: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<int> _getCapitulos() {
    if (selectedNome != null) {
      final livro = bibliaData!.firstWhere((livro) => livro['nome'] == selectedNome);
      return List<int>.generate(
        livro['capitulos'].length,
        (index) => index + 1,
      );
    }
    return [];
  }

  List<int> _getVersiculos() {
    if (selectedNome != null && selectedCapitulo != null) {
      final livro = bibliaData!.firstWhere((livro) => livro['nome'] == selectedNome);
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
      final livro = bibliaData!.firstWhere((livro) => livro['nome'] == selectedNome);
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
                // Bloco de seleção de Livro, Capítulo e Versículo
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Linha com Livro e Capítulo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Livro:',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Tamanho fixo
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedNome,
                                    items: bibliaData!.map<DropdownMenuItem<String>>((dynamic livro) {
                                      return DropdownMenuItem<String>(
                                        value: livro['nome'],
                                        child: Text(
                                          livro['nome'],
                                          style: TextStyle(fontSize: 14), // Tamanho fixo
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
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Capítulo:',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Tamanho fixo
                                  ),
                                  DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedCapitulo,
                                    items: _getCapitulos().map<DropdownMenuItem<int>>((int capitulo) {
                                      return DropdownMenuItem<int>(
                                        value: capitulo,
                                        child: Text(
                                          capitulo.toString(),
                                          style: TextStyle(fontSize: 14), // Tamanho fixo
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
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Versículo:',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Tamanho fixo
                                  ),
                                  DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedVersiculoInicial,
                                    items: _getVersiculos().map<DropdownMenuItem<int>>((int versiculo) {
                                      return DropdownMenuItem<int>(
                                        value: versiculo,
                                        child: Text(
                                          versiculo.toString(),
                                          style: TextStyle(fontSize: 14), // Tamanho fixo
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'até:',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Tamanho fixo
                                  ),
                                  DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedVersiculoFinal,
                                    items: _getVersiculos().map<DropdownMenuItem<int>>((int versiculo) {
                                      return DropdownMenuItem<int>(
                                        value: versiculo,
                                        child: Text(
                                          versiculo.toString(),
                                          style: TextStyle(fontSize: 14), // Tamanho fixo
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

                // Slider e ícones na mesma linha
                Row(
                  children: [
                    // Slider para regular o tamanho da fonte
                    Expanded(
                      child: Slider(
                        value: _fontSize,
                        min: 10,
                        max: 30,
                        divisions: 20,
                        label: _fontSize.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _fontSize = value; // Atualiza o tamanho da fonte
                          });
                        },
                      ),
                    ),
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

                SizedBox(height: 20),

                // Exibição do texto da passagem
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.grey),
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      child: Text(
                        _getTexto(),
                        style: TextStyle(fontSize: _fontSize), // Tamanho da fonte afetado pelo slider
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}


}