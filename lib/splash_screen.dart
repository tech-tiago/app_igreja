import 'package:flutter/material.dart';
import 'horarios_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;
  int _progressPercentage = 0;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _progressValue += 0.02;
        _progressPercentage = (_progressValue * 100).round();
      });
      if (_progressValue < 1.0) {
        _simulateLoading(); // Continua o carregamento
      } else {
        // Após o carregamento, navega para a HomePage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003F4F), // Cor de fundo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/load_img.png',
              height: 150.0, // Ajuste o tamanho conforme necessário
            ),
            SizedBox(height: 20.0),
            Container(
              width: 200.0, // Largura da barra de progresso
              height: 20.0, // Altura da barra de progresso
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Cantos arredondados
                child: LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '$_progressPercentage%', // Mostra a porcentagem
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 20.0),
            Text(
              'Carregando horários e leituras...',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}