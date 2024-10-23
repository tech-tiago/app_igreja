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
                    onPressed: () => _launchWhatsApp('+5573981700371'), 
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
                  // _buildButton(
                  //   onPressed: () {
                  //     // Ação de abrir configurações
                  //   },
                  //   icon: Icons.settings,
                  //   label: 'Configurações',
                  //   color: Colors.grey,
                  // ),
                ],
              ),
            ),

            // Versão e Copyright
            Column(
              children: const [
                Text(
                  'Versão do aplicativo: 1.0.0',
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
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white), // Ícone em branco
        label: Text(
          label,
          style: const TextStyle(color: Colors.white), // Texto em branco
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
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
    const phoneNumber = '+5573981700371'; // Número de telefone com código do país
    final url = 'https://wa.me/$phoneNumber'; // URL do WhatsApp

    try {
      await launch(url); // Tenta abrir o WhatsApp diretamente
    } catch (e) {
      print('Não foi possível abrir o WhatsApp: $e');
    }
}

  // Exibir termos de uso
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Termos de Uso'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Última atualização: 22/10/2024\n\n'
                  'Estes Termos de Uso regem o acesso e uso do aplicativo "Paróquia Nossa Senhora da Saúde". Ao acessar ou utilizar o App, você concorda em cumprir e estar vinculado a estes Termos de Uso.\n\n'
                  '1. Aceitação dos Termos\n'
                  'Você declara que tem pelo menos 18 anos ou que possui o consentimento de um responsável legal.\n\n'
                  '2. Alterações aos Termos\n'
                  'Reservamo-nos o direito de modificar estes Termos de Uso a qualquer momento.\n\n'
                  '3. Uso do App\n'
                  'Você concorda em usar o App apenas para fins legais.\n\n'
                  '4. Propriedade Intelectual\n'
                  'Todos os conteúdos do App são de propriedade da Paróquia Nossa Senhora da Saúde.\n\n'
                  '5. Limitação de Responsabilidade\n'
                  'A Paróquia Nossa Senhora da Saúde não será responsável por quaisquer danos decorrentes do uso do App.\n\n'
                  '6. Indenização\n'
                  'Você concorda em indenizar a Paróquia Nossa Senhora da Saúde por qualquer reclamação decorrente do uso do App.\n\n'
                  '7. Contato\n'
                  'E-mail: t.souzart@gmail.com\n'
                  'Instagram: @tech.tiago\n\n'
                  '8. Legislação Aplicável\n'
                  'Estes Termos de Uso serão regidos pelas leis do Brasil.\n\n'
                  '9. Aceitação\n'
                  'Ao utilizar o App, você concorda em cumprir estes Termos de Uso.'
                ),
              ],
            ),
          ),
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
