import 'dart:convert';
import 'dart:io';

void main() async {
  final dataDir = Directory('assets/data/iqra');
  final outDir = Directory('assets/audio/iqra');
  
  if (!await outDir.exists()) {
    await outDir.create(recursive: true);
  }

  final jsonFiles = dataDir.listSync().where((file) => file.path.endsWith('.json'));

  for (var file in jsonFiles) {
    print('Processing ${file.path}...');
    final content = await File(file.path).readAsString();
    final data = jsonDecode(content);
    final pages = data['pages'] as List;

    for (var page in pages) {
      final String filename = page['audio'];
      final String arabicText = page['arabic'];
      final File outFile = File('${outDir.path}/$filename');

      if (await outFile.exists() && await outFile.length() > 0) {
        print('Skipping $filename (already exists)');
        continue;
      }

      final encoded = Uri.encodeComponent(arabicText);
      final url = 'https://translate.google.com/translate_tts?ie=UTF-8&q=$encoded&tl=ar&client=tw-ob';

      try {
        final request = await HttpClient().getUrl(Uri.parse(url));
        request.headers.add('User-Agent', 'Mozilla/5.0');
        final response = await request.close();
        
        if (response.statusCode == 200) {
          final fileSink = outFile.openWrite();
          await response.pipe(fileSink);
          print('Downloaded $filename');
        } else {
          print('Failed to download $filename: HTTP ${response.statusCode}');
        }
      } catch (e) {
        print('Error downloading $filename: $e');
      }
      
      // Small delay to be polite to the server
      await Future.delayed(Duration(milliseconds: 200));
    }
  }
  print('Audio download complete.');
}
