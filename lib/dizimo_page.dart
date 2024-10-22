import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart'; // Pacote para acessar diretórios temporários
import 'dart:io'; // Para manipular arquivos
import 'package:flutter/services.dart' show rootBundle; // Para carregar arquivos de assets

class DizimoPage extends StatelessWidget {
  // Função para copiar o código Pix
  void _copyPixCode(BuildContext context) {
    Clipboard.setData(ClipboardData(
        text:
            '00020126360014BR.GOV.BCB.PIX0114015324380036035204000053039865802BR5901N6001C62070503***6304D1FA'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código Pix copiado!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Função para compartilhar o QR code e o código Pix
  Future<void> _sharePixAndQRCode() async {
    final pixCode =
        '00020126360014BR.GOV.BCB.PIX0114015324380036035204000053039865802BR5901N6001C62070503***6304D1FA';

    // Carregar o arquivo de QR code dos assets
    final ByteData bytes = await rootBundle.load('assets/images/qrcode.png');
    final Uint8List list = bytes.buffer.asUint8List();

    // Obter o diretório temporário
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/qrcode.png').create();
    file.writeAsBytesSync(list);

    // Compartilhar tanto o QR code quanto o código Pix
    await Share.shareFiles(
      [file.path],
      text: 'Contribua com o Dízimo! \n\nEscaneie o QR Code ou utilize o código Pix abaixo:\n\n$pixCode',
      subject: 'Contribuição Dízimo - QR Code e Pix',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título principal
            Text(
              'Contribua com o Dízimo',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Card para o QR Code
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Escaneie o QR Code:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Image.asset(
                      'assets/images/qrcode.png',
                      height: 200,
                    ),
                    SizedBox(height: 20),

                    // Campo Pix Copia-e-cola
                    Text(
                      'Pix Copia-e-cola:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                '00020126360014BR.GOV.BCB.PIX0114015324380036035204000053039865802BR5901N6001C62070503***6304D1FA',
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.copy, color: Colors.teal),
                                onPressed: () => _copyPixCode(context),
                              ),
                            ),
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Botão de compartilhamento
                    ElevatedButton.icon(
                      icon: Icon(Icons.share),
                      label: Text(
                        'Compartilhar QR Code e Pix',
                        style: TextStyle(color: Colors.white), // Define a cor do texto como branco
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700], // Cor do botão
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _sharePixAndQRCode,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card para os dados bancários
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dados Bancários:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Estilização dos dados bancários
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBankInfoRow('CNPJ:', '01.532.438/0036-03'),
                          _buildBankInfoRow('Nome:', 'Diocese de Eunápolis'),
                          _buildBankInfoRow('Banco:', 'Caixa Econômica Federal'),
                          _buildBankInfoRow('Op:', '003'),
                          _buildBankInfoRow('Agência:', '3948'),
                          _buildBankInfoRow('C/C:', '1025-9'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para gerar as linhas de informações bancárias com estilo
  Widget _buildBankInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
