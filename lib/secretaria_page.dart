import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir o WhatsApp
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecretariaPage extends StatelessWidget {
  // Função para abrir o WhatsApp
  void _openWhatsApp() async {
    const phoneNumber = '+557336792302'; // Número de telefone com código do país
    final url = 'https://wa.me/$phoneNumber'; // URL do WhatsApp

    try {
      await launch(url); // Tenta abrir o WhatsApp diretamente
    } catch (e) {
      print('Não foi possível abrir o WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título principal
            Text(
              'Secretaria Paroquial',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Container para Horário de Funcionamento
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.teal[50], // Cor de fundo leve
                border: Border.all(color: Colors.teal[700]!, width: 2), // Borda
                borderRadius: BorderRadius.circular(10), // Cantos arredondados
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.teal[700], size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Horário de funcionamento:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Segunda a Sexta: 8:00 às 12:00 | 13:00 às 17:00\nSábado: 8:00 às 12:00',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Container para Contato
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.teal[50], // Cor de fundo leve
                border: Border.all(color: Colors.teal[700]!, width: 2), // Borda
                borderRadius: BorderRadius.circular(10), // Cantos arredondados
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.teal[700], size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Telefone para contato:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '(73) 3679-2302',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Botão de WhatsApp
            ElevatedButton.icon(
              icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
              label: Text(
                'Entrar em contato via WhatsApp',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor do botão
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _openWhatsApp, // Abre o WhatsApp quando clicado
            ),
          ],
        ),
      ),
    );
  }
}
