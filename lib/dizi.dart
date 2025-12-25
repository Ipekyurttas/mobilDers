import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dizi_model.dart';

class DiziPage extends StatefulWidget {
  const DiziPage({super.key});

  @override
  State<DiziPage> createState() => _DiziPageState();
}

class _DiziPageState extends State<DiziPage> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _yonetmenController = TextEditingController();
  final TextEditingController _turController = TextEditingController();
  final TextEditingController _puanController = TextEditingController();

  late Box<Dizi> diziBox;

  @override
  void initState() {
    super.initState();
    diziBox = Hive.box<Dizi>('diziler');
  }

  void _islemPenceresiAc({Dizi? mevcutDizi}) {
    if (mevcutDizi != null) {
      _adController.text = mevcutDizi.ad;
      _yonetmenController.text = mevcutDizi.yonetmen;
      _turController.text = mevcutDizi.tur;
      _puanController.text = mevcutDizi.puan.toString();
    } else {
      _adController.clear();
      _yonetmenController.clear();
      _turController.clear();
      _puanController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            mevcutDizi == null ? "Yeni Dizi Ekle" : "Diziyi Güncelle",
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _adController,
                  decoration: const InputDecoration(labelText: "Dizi Adı"),
                ),
                TextField(
                  controller: _yonetmenController,
                  decoration: const InputDecoration(labelText: "Yönetmen"),
                ),
                TextField(
                  controller: _turController,
                  decoration: const InputDecoration(labelText: "Türü"),
                ),
                TextField(
                  controller: _puanController,
                  decoration: const InputDecoration(labelText: "Puanı"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (mevcutDizi == null) {
                  _yeniKaydet();
                } else {
                  _guncelle(mevcutDizi);
                }
              },
              child: Text(mevcutDizi == null ? "Kaydet" : "Güncelle"),
            ),
          ],
        );
      },
    );
  }

  void _yeniKaydet() {
    if (_adController.text.isNotEmpty) {
      final yeniDizi = Dizi(
        ad: _adController.text,
        yonetmen: _yonetmenController.text,
        tur: _turController.text,
        puan: double.tryParse(_puanController.text) ?? 0.0,
      );
      diziBox.add(yeniDizi);
      Navigator.pop(context);
      _bilgiMesaji("Dizi başarıyla eklendi!");
    }
  }

  void _guncelle(Dizi dizi) {
    if (_adController.text.isNotEmpty) {
      dizi.ad = _adController.text;
      dizi.yonetmen = _yonetmenController.text;
      dizi.tur = _turController.text;
      dizi.puan = double.tryParse(_puanController.text) ?? 0.0;

      dizi.save();

      Navigator.pop(context);
      _bilgiMesaji("Dizi güncellendi!");
    }
  }

  void _diziSil(Dizi dizi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Silinsin mi?"),
        content: Text("${dizi.ad} silinecek. Emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              dizi.delete();
              Navigator.pop(context);
              _bilgiMesaji("Dizi silindi.");
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _bilgiMesaji(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dizilerim'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: diziBox.listenable(),
        builder: (context, Box<Dizi> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                'Henüz liste boş.\nSağ alttan ekleme yapın.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          List<Dizi> diziler = box.values.toList().reversed.toList();

          return ListView.builder(
            itemCount: diziler.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final dizi = diziler[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                dizi.puan.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detaySatiri("Dizi Adı", dizi.ad, isBold: true),
                                const SizedBox(height: 4),
                                _detaySatiri("Yönetmen", dizi.yonetmen),
                                const SizedBox(height: 4),
                                _detaySatiri("Tür", dizi.tur),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () =>
                                    _islemPenceresiAc(mevcutDizi: dizi),
                                tooltip: "Düzenle",
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(height: 10),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _diziSil(dizi),
                                tooltip: "Sil",
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _islemPenceresiAc(),
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _detaySatiri(String baslik, String icerik, {bool isBold = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        children: [
          TextSpan(
            text: "$baslik: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: icerik,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isBold ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
