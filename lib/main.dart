import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'liturgia_page.dart';  
import 'pastorais_page.dart';  
import 'oracoes_page.dart';  
import 'sobre_page.dart';  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    LiturgiaPage(),
    PastoraisPage(),
    OracoesPage(),
    SobrePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003F4F),
        toolbarHeight: 70,
        title: Row(
          children: [
            Image.asset(
              '../img/logo.png',
              height: 70,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.video),
            color: const Color.fromARGB(255, 239, 225, 198),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.phone),
            color: const Color.fromARGB(255, 239, 225, 198),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.handHoldingHeart),
            color: const Color.fromARGB(255, 239, 225, 198),
            onPressed: () {},
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.shop),
            color: const Color.fromARGB(255, 239, 225, 198),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
            icon: FaIcon(FontAwesomeIcons.users),
            label: 'Pastorais',
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
        selectedItemColor: const Color(0xFFB0C4DE),
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
          'Quinta-feira: 19:30 horas',
          LatLng(-16.40445, -39.05224), // Coordenadas do local
        ),
        buildCard(
          'COMUNIDADE SANTO ANTÔNIO',
          'Sábado: 19:00 horas\nDomingo: 07:00 horas',
          'Terça-feira: 19:30 horas',
          LatLng(-16.40445, -39.05224), // Coordenadas do local
        ),
        buildCard(
          'SANTANA E SÃO JOAQUIN',
          'Sábado: 19:00 horas\nDomingo: 07:00 horas',
          'Terça-feira: 19:30 horas',
          LatLng(-16.40445, -39.05224), // Coordenadas do local
        ),
      ],
    );
  }

  void _launchURL(double lat, double lng) async {
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Widget buildCard(String title, String massSchedule, String adorationSchedule, LatLng location) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Horários de Missas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(massSchedule),
            const SizedBox(height: 10),
            const Text(
              'Adoração:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(adorationSchedule),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _launchURL(location.latitude, location.longitude),  // Abre o Google Maps com as coordenadas
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
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
          icon: FaIcon(FontAwesomeIcons.users),
          label: 'Pastorais',
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
      selectedItemColor: const Color(0xFFB0C4DE),
      unselectedItemColor: const Color(0xFFB0C4DE).withOpacity(0.4),
      backgroundColor: const Color(0xFF003F4F),
      type: BottomNavigationBarType.fixed,
    );
  }
