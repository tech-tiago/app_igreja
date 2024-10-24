import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'liturgia_page.dart';
import 'biblia_page.dart';
import 'oracoes_page.dart';
import 'sobre_page.dart';
import 'dizimo_page.dart';
import 'secretaria_page.dart';
import 'loja_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _showDizimoPage = false;
  bool _showSecretariaPage = false;
  bool _showLojaPage = false;

  final List<Widget> _pages = [
    HomePageContent(),
    LiturgiaPage(),
    BibliaPage(),
    OracoesPage(),
    SobrePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _showDizimoPage = false;
      _showSecretariaPage = false;
      _showLojaPage = false; // Reseta a exibição da LojaPage
    });
  }

  void _showDizimo() {
    setState(() {
      _showDizimoPage = true;
      _showSecretariaPage = false;
      _showLojaPage = false;
    });
  }

  void _showSecretaria() {
    setState(() {
      _showSecretariaPage = true;
      _showDizimoPage = false;
      _showLojaPage = false;
    });
  }

  void _showLoja() {
    setState(() {
      _showLojaPage = true;
      _showDizimoPage = false;
      _showSecretariaPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003F4F),
        toolbarHeight: 70,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 70,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.phone),
            color: _showSecretariaPage
                ? const Color(0xFFB0C4DE)
                : const Color.fromARGB(255, 239, 225, 198),
            onPressed: _showSecretaria, // Chama a função para mostrar a SecretariaPage
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.handHoldingHeart),
            color: _showDizimoPage
                ? const Color(0xFFB0C4DE)
                : const Color.fromARGB(255, 239, 225, 198),
            onPressed: _showDizimo, // Chama a função para mostrar a DizimoPage
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shop),
            color: _showLojaPage
                ? const Color(0xFFB0C4DE)
                : const Color.fromARGB(255, 239, 225, 198),
            onPressed: _showLoja, // Chama a função para mostrar a LojaPage
          ),
        ],
      ),
      body: _showDizimoPage
          ? DizimoPage()
          : _showSecretariaPage
              ? SecretariaPage()
              : _showLojaPage
                  ? LojaPage()
                  : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_showDizimoPage || _showSecretariaPage || _showLojaPage) {
            setState(() {
              _showDizimoPage = false;
              _showSecretariaPage = false;
              _showLojaPage = false;
              _currentIndex = index;
            });
          } else {
            _onTabTapped(index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clock),
            label: 'Horários',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookOpen),
            label: 'Liturgia',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookBible),
            label: 'Bíblia',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.handsPraying),
            label: 'Orações',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.circleInfo),
            label: 'Sobre',
          ),
        ],
        selectedItemColor: (_showDizimoPage || _showSecretariaPage || _showLojaPage)
            ? const Color(0xFFB0C4DE).withOpacity(0.4)
            : const Color(0xFFB0C4DE),
        unselectedItemColor: const Color(0xFFB0C4DE).withOpacity(0.4),
        backgroundColor: const Color(0xFF003F4F),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildCard(
          'PARÓQUIA NOSSA SENHORA DA SAÚDE',
          'Domingo: 08:30 horas • 10:00 horas • 19:30 horas',
          'Quinta-feira: 18:00 horas',
          LatLng(-16.40452, -39.05223),
        ),
        buildCard(
          'COMUNIDADE SANTO ANTÔNIO',
          'Sábado: 19:00 horas\nDomingo: 07:00 horas',
          'Terça-feira: 18:00 horas',
          LatLng(-16.37891, -39.03338),
        ),
        buildCard(
          "COMUNIDADE SANT'ANA E SÃO JOAQUIM",
          'Domingo: 17:30 horas',
          'Quarta-feira: 18:00 horas',
          LatLng(-16.38521, -39.04952),
        ),
      ],
    );
  }

  Widget buildCard(String title, String massSchedule, String adorationSchedule, LatLng location) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Horários de Missas:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              massSchedule,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Adoração:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              adorationSchedule,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: FlutterMap(
                    options: MapOptions(
                      center: location,
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: location,
                            builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(location.latitude, location.longitude),
                    icon: Icon(Icons.map),
                    label: Text("Abrir no Maps"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(double lat, double lng) {
    MapsLauncher.launchCoordinates(lat, lng, 'Localização');
  }
}
