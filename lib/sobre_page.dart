import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container para os botões
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão para avaliar aplicativo
                  _buildButton(
                    onPressed: () => _launchURL('https://play.google.com/store/apps/details?id=your.app.id'),
                    icon: Icons.star,
                    label: 'Avalie nosso aplicativo',
                    color: const Color(0xFF2DAA9C),
                  ),
                  const SizedBox(height: 20),

                  // Botão para enviar sugestões via WhatsApp
                  _buildButton(
                    onPressed: () => _launchWhatsApp('73981700371'),
                    icon: Icons.chat,
                    label: 'Enviar sugestões',
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),

                  // Botão para termos de uso
                  _buildButton(
                    onPressed: () => _showTermsDialog(context),
                    icon: Icons.description,
                    label: 'Termos de uso',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 20),

                  // Botão para configurações
                  _buildButton(
                    onPressed: () {
                      // Ação de abrir configurações
                    },
                    icon: Icons.settings,
                    label: 'Configurações',
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // Versão e Copyright
            Column(
              children: const [
                Text(
                  'Versão do aplicativo: 1.2.8',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Copyright - @tech.tiago',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required void Function() onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity, // Define a largura do botão como infinita
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0), // Define padding vertical para o botão
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // Função para abrir a URL no navegador
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  // Função para abrir o WhatsApp
  void _launchWhatsApp(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp';
    }
  }

  // Exibir termos de uso
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Termos de Uso'),
          content: const Text('Aqui você pode adicionar os termos de uso...'),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
