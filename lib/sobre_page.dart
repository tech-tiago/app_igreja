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
                'Introdução\n\n'
                'Nossa política de privacidade ajudará você a entender quais informações coletamos no Bit Infotech, como a Bit Infotech as utiliza e quais são as suas opções. A Bit Infotech desenvolveu o aplicativo Paróquia Nossa Sra. da Saúde como um app gratuito. Este SERVIÇO é fornecido pela Bit Infotech sem custo e é destinado ao uso como está.\n\n'
                'Se você optar por usar nosso Serviço, então você concorda com a coleta e uso de informações relacionadas a esta política. As Informações Pessoais que coletamos são usadas para fornecer e melhorar o Serviço. Não usaremos ou compartilharemos suas informações com ninguém, exceto conforme descrito nesta Política de Privacidade.\n\n'
                'Coleta e Uso de Informações\n\n'
                'Para uma melhor experiência ao usar nosso Serviço, podemos solicitar que você nos forneça certas informações pessoalmente identificáveis, incluindo, mas não se limitando a, nome, endereço de e-mail, gênero, localização e fotos dos usuários. As informações que solicitamos serão retidas por nós e usadas conforme descrito nesta política de privacidade. O aplicativo utiliza serviços de terceiros que podem coletar informações usadas para identificá-lo.\n\n'
                'Cookies\n\n'
                'Cookies são arquivos com uma pequena quantidade de dados que geralmente incluem um identificador único anônimo. Esses arquivos são enviados para o seu navegador a partir do site que você visita e são armazenados na memória interna do seu dispositivo.\n\n'
                'Este Serviço não usa esses “cookies” explicitamente. No entanto, o aplicativo pode usar códigos e bibliotecas de terceiros que utilizam “cookies” para coletar informações e melhorar seus serviços. Você tem a opção de aceitar ou recusar esses cookies e saber quando um cookie está sendo enviado ao seu dispositivo. Se você optar por recusar nossos cookies, pode não conseguir usar algumas partes deste Serviço.\n\n'
                'Informações de Localização\n\n'
                'Alguns dos serviços podem usar informações de localização transmitidas dos telefones celulares dos usuários. Usamos essas informações apenas dentro do escopo necessário para o serviço designado.\n\n'
                'Informações do Dispositivo\n\n'
                'Coletamos informações do seu dispositivo em alguns casos. Essas informações serão utilizadas para a prestação de um serviço melhor e para prevenir atos fraudulentos. Além disso, tais informações não incluirão dados que identifiquem o usuário individual.\n\n'
                'Provedores de Serviço\n\n'
                'Podemos empregar empresas e indivíduos terceirizados devido aos seguintes motivos:\n'
                '* Para facilitar o nosso Serviço;\n'
                '* Para fornecer o Serviço em nosso nome;\n'
                '* Para realizar serviços relacionados ao Serviço;\n'
                '* Para nos ajudar a analisar como nosso Serviço é utilizado.\n\n'
                'Queremos informar aos usuários deste Serviço que esses terceiros têm acesso às suas Informações Pessoais. O motivo é para realizar as tarefas atribuídas a eles em nosso nome. No entanto, eles são obrigados a não divulgar ou usar as informações para qualquer outro propósito.\n\n'
                'Segurança\n\n'
                'Valorizamos sua confiança em nos fornecer suas Informações Pessoais, por isso estamos nos esforçando para usar meios comercialmente aceitáveis de protegê-las. Mas lembre-se de que nenhum método de transmissão pela internet ou método de armazenamento eletrônico é 100% seguro e confiável, e não podemos garantir sua segurança absoluta.\n\n'
                'Privacidade das Crianças\n\n'
                'Este Serviço não atende a ninguém com menos de 13 anos. Não coletamos intencionalmente informações pessoalmente identificáveis de crianças com menos de 13 anos. Caso descubramos que uma criança com menos de 13 anos nos forneceu informações pessoais, imediatamente as excluímos de nossos servidores. Se você for um pai ou responsável e souber que seu filho nos forneceu informações pessoais, entre em contato conosco para que possamos tomar as medidas necessárias.\n\n'
                'Alterações a Esta Política de Privacidade\n\n'
                'Podemos atualizar nossa Política de Privacidade de tempos em tempos. Assim, você é aconselhado a revisar esta página periodicamente para quaisquer alterações. Notificaremos você de quaisquer mudanças publicando a nova Política de Privacidade nesta página. Essas alterações são efetivas imediatamente após serem publicadas nesta página.\n\n'
                'Contato\n\n'
                'Se você tiver alguma dúvida ou sugestão sobre nossa Política de Privacidade, não hesite em nos contatar.\n'
                'Email: bytinfotech@gmail.com'
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
