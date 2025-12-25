import 'package:flutter/material.dart';
import 'dizi.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dizi_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DiziAdapter());
  await Hive.openBox<Dizi>('diziler');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}

// --- SPLASH SCREEN (Aynı kalıyor) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset('assets/ortakraf.png', width: 250),
        ),
      ),
    );
  }
}

// --- HOME SCREEN (Güncellendi) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle(Color color) {
      return ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Ortakraf'a Hoşgeldiniz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 50),

              // Kitap Butonu
              ElevatedButton.icon(
                onPressed: () {
                  debugPrint("Kitap butonuna tıklandı");
                },
                style: buttonStyle(const Color(0xFF1565C0)),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Kitap'),
              ),
              const SizedBox(height: 20),

              // Dizi Butonu - GÜNCELLENDİ
              ElevatedButton.icon(
                onPressed: () {
                  // <--- 2. EKLEME: Sayfa Yönlendirmesi Buraya Yapıldı
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiziPage()),
                  );
                },
                style: buttonStyle(const Color(0xFF1976D2)),
                icon: const Icon(Icons.tv_rounded),
                label: const Text('Dizi'),
              ),
              const SizedBox(height: 20),

              // Film Butonu
              ElevatedButton.icon(
                onPressed: () {
                  debugPrint("Film butonuna tıklandı");
                },
                style: buttonStyle(const Color(0xFF42A5F5)),
                icon: const Icon(Icons.movie_creation_rounded),
                label: const Text('Film'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
