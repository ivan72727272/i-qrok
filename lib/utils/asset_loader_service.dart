import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AssetLoaderService {
  /// Membaca file gambar dari AssetManifest berdasarkan prefix folder tertentu.
  /// Contoh prefix: 'assets/images/doa/'
  static Future<List<String>> loadImagesFromFolder(String folderPath) async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      final imagePaths = manifestMap.keys
          .where((String key) => key.startsWith(folderPath) && (key.endsWith('.png') || key.endsWith('.jpg') || key.endsWith('.jpeg')))
          .toList();
          
      // Sort alphabetically
      imagePaths.sort();
      
      return imagePaths;
    } catch (e) {
      debugPrint('Error loading assets from $folderPath: $e');
      return [];
    }
  }

  /// Mengekstrak judul/nama bersih dari path file gambar.
  /// Contoh: 'assets/images/doa/doa_makan.png' -> 'Doa Makan'
  static String extractTitleFromPath(String path) {
    final fileName = path.split('/').last;
    final nameWithoutExtension = fileName.split('.').first;
    
    // Ganti underscore dengan spasi dan kapitalisasi kata
    final words = nameWithoutExtension.split('_');
    final title = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
    
    return title;
  }
}
