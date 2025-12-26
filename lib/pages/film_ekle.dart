import 'package:flutter/material.dart';

import '../models/film_model.dart';
import '../data/film_data.dart';

class FilmEklePage extends StatefulWidget {
  const FilmEklePage({super.key});

  @override
  State<FilmEklePage> createState() => _FilmEklePageState();
}

class _FilmEklePageState extends State<FilmEklePage> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();

  @override
  void dispose() {
    _adController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  void _kaydet() {
    if (_adController.text.trim().isEmpty ||
        _aciklamaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    filmListesi.add(
      Film(
        ad: _adController.text.trim(),
        aciklama: _aciklamaController.text.trim(),
      ),
    );

    Navigator.pop(context); // FilmPage'e geri dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Film Ekle"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _adController,
              decoration: const InputDecoration(
                labelText: "Film Adı",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aciklamaController,
              decoration: const InputDecoration(
                labelText: "Açıklama",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _kaydet,
                child: const Text("Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
