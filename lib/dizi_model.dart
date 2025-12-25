import 'package:hive/hive.dart';

part 'dizi_model.g.dart';

@HiveType(typeId: 1)
class Dizi extends HiveObject {
  @HiveField(0)
  String ad;

  @HiveField(1)
  String yonetmen;

  @HiveField(2)
  String tur;

  @HiveField(3)
  double puan;

  Dizi({
    required this.ad,
    required this.yonetmen,
    required this.tur,
    required this.puan,
  });
}
