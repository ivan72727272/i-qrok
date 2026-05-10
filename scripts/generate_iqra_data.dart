import 'dart:convert';
import 'dart:io';
import 'dart:math';

final baseLetters = ["ا", "ب", "ت", "ث", "ج", "ح", "خ", "د", "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط", "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م", "ن", "و", "ه", "ي"];
final baseLatin = ["a", "ba", "ta", "tsa", "ja", "ha", "kha", "da", "dza", "ra", "za", "sa", "sya", "sha", "dha", "tha", "zha", "a'", "gha", "fa", "qa", "ka", "la", "ma", "na", "wa", "ha", "ya"];

final rand = Random();

Map<String, String> getRandomLetter() {
  int idx = rand.nextInt(baseLetters.length);
  return {'ar': baseLetters[idx], 'lat': baseLatin[idx]};
}

void main() async {
  final outDir = Directory('assets/data/iqra');
  if (!await outDir.exists()) {
    await outDir.create(recursive: true);
  }

  void generateIqraJson(int level, int totalPages, String title) {
    List<Map<String, dynamic>> pages = [];

    for (int i = 1; i <= totalPages; i++) {
      String arText = "";
      String latText = "";

      int wordCount = 2 + (i ~/ 10);

      for (int w = 0; w < wordCount; w++) {
        var l1 = getRandomLetter();
        var l2 = getRandomLetter();

        if (level == 1) {
          arText += "${l1['ar']}َ ${l2['ar']}َ   ";
          latText += "${l1['lat']}-${l2['lat']}   ";
        } else if (level == 2) {
          arText += "${l1['ar']}َا ${l2['ar']}َ   ";
          latText += "${l1['lat']}a-${l2['lat']}   ";
        } else if (level == 3) {
          List<String> harakatAr = ["َ", "ِ", "ُ"];
          List<String> harakatLat = ["a", "i", "u"];
          int h1 = rand.nextInt(3);
          int h2 = rand.nextInt(3);
          arText += "${l1['ar']}${harakatAr[h1]} ${l2['ar']}${harakatAr[h2]}   ";
          String lat1 = l1['lat']!;
          String lat2 = l2['lat']!;
          latText += "${lat1.substring(0, lat1.length - 1)}${harakatLat[h1]}-${lat2.substring(0, lat2.length - 1)}${harakatLat[h2]}   ";
        } else if (level == 4) {
          arText += "${l1['ar']}َنْ ${l2['ar']}ٌ   ";
          String lat1 = l1['lat']!;
          String lat2 = l2['lat']!;
          latText += "${lat1.substring(0, lat1.length - 1)}an-${lat2.substring(0, lat2.length - 1)}un   ";
        } else if (level == 5) {
          arText += "اَلْ${l1['ar']}َ${l2['ar']}ُ   ";
          String lat1 = l1['lat']!;
          String lat2 = l2['lat']!;
          latText += "al-${lat1}${lat2.substring(0, lat2.length - 1)}u   ";
        } else {
          arText += "بِسْمِ ${l1['ar']}َ${l2['ar']}ِ   ";
          String lat1 = l1['lat']!;
          String lat2 = l2['lat']!;
          latText += "bismi ${lat1}${lat2.substring(0, lat2.length - 1)}i   ";
        }
      }

      pages.add({
        "page": i,
        "title": title,
        "arabic": arText.trim(),
        "latin": latText.trim(),
        "audio": "iqra${level}_page${i}.mp3"
      });
    }

    Map<String, dynamic> jsonObj = {
      "level": level,
      "title": title,
      "pages": pages
    };

    File('${outDir.path}/iqra$level.json').writeAsStringSync(jsonEncode(jsonObj));
    print('Generated iqra$level.json with $totalPages pages.');
  }

  generateIqraJson(1, 10, "Iqra 1");
  generateIqraJson(2, 20, "Iqra 2");
  generateIqraJson(3, 25, "Iqra 3");
  generateIqraJson(4, 30, "Iqra 4");
  generateIqraJson(5, 35, "Iqra 5");
  generateIqraJson(6, 40, "Iqra 6");
}
