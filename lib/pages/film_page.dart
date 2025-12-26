import 'package:flutter/material.dart';

import '../data/film_data.dart';
import '../models/film_model.dart';
import 'film_ekle.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  // ------------------ GÜNCELLE ------------------
  void _filmGuncelle(Film film) {
    final TextEditingController adController = TextEditingController(
      text: film.ad,
    );
    final TextEditingController aciklamaController = TextEditingController(
      text: film.aciklama,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Film Güncelle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adController,
                decoration: const InputDecoration(labelText: "Film Adı"),
              ),
              TextField(
                controller: aciklamaController,
                decoration: const InputDecoration(labelText: "Açıklama"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  film.ad = adController.text;
                  film.aciklama = aciklamaController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  // ------------------ SİL ------------------
  void _filmSil(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Film Sil"),
          content: Text("${filmListesi[index].ad} silmek istiyor musunuz?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hayır"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  filmListesi.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Evet"),
            ),
          ],
        );
      },
    );
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filmler"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            // ❗❗ const KALDIRILDI ❗❗
            MaterialPageRoute(builder: (context) => FilmEklePage()),
          );
          setState(() {}); // geri dönünce listeyi yenile
        },
      ),
      body: filmListesi.isEmpty
          ? const Center(
              child: Text(
                "Henüz film eklenmedi",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filmListesi.length,
              itemBuilder: (context, index) {
                final Film film = filmListesi[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(film.ad),
                    subtitle: Text(film.aciklama),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _filmGuncelle(film),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _filmSil(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
