import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir o WhatsApp

class LojaPage extends StatelessWidget {
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
            // Texto informativo
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50], // Cor de fundo leve
                border: Border.all(color: Colors.teal[700]!, width: 2), // Borda
                borderRadius: BorderRadius.circular(10), // Cantos arredondados
              ),
              child: Text(
                'Para mais informações sobre a lojinha, entre em contato via WhatsApp.',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20), // Espaçamento entre o texto e o botão

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
