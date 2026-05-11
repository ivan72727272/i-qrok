import json
import urllib.request
import os
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

BASE_URL = "https://equran.id/api/v2/surat"
AUDIO_DIR = "assets/audio/surah"
OUTPUT_FILE = "lib/data/juz_amma_data.dart"

os.makedirs(AUDIO_DIR, exist_ok=True)

# Surah 1 and Surah 78-114
target_surahs = [1] + list(range(78, 115))

dart_content = """import 'package:flutter/material.dart';

class JuzAmmaData {
  static const List<Map<String, dynamic>> surahs = [
"""

# Pastel colors for cards
COLORS = [
    "Color(0xFF66BB6A)", # Green
    "Color(0xFF42A5F5)", # Blue
    "Color(0xFFFFA726)", # Orange
    "Color(0xFFAB47BC)", # Purple
    "Color(0xFF26C6DA)", # Cyan
    "Color(0xFFEF5350)", # Red
    "Color(0xFF8D6E63)", # Brown
    "Color(0xFF78909C)", # BlueGrey
]

color_idx = 0

for s_num in target_surahs:
    print(f"Fetching Surah {s_num}...")
    try:
        req = urllib.request.Request(f"{BASE_URL}/{s_num}", headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())['data']
            
        surah_name = data['namaLatin']
        surah_arabic = data['nama']
        jumlah_ayat = data['jumlahAyat']
        audio_url = data['audioFull']['01']
        
        # Format filename e.g. 001_al_fatihah.mp3
        safe_name = surah_name.lower().replace('-', '_').replace('\'', '').replace(' ', '_')
        filename = f"{str(s_num).zfill(3)}_{safe_name}.mp3"
        filepath = os.path.join(AUDIO_DIR, filename)
        
        if not os.path.exists(filepath) or os.path.getsize(filepath) == 0:
            print(f"Downloading audio for {surah_name}...")
            req_audio = urllib.request.Request(audio_url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req_audio) as response, open(filepath, 'wb') as out_file:
                out_file.write(response.read())
        else:
            print(f"Audio {filename} exists.")
            
        color = COLORS[color_idx % len(COLORS)]
        color_idx += 1
        
        dart_content += f"""    {{
      'name': '{surah_name.replace("'", "\\'")}',
      'arabic': '{surah_arabic}',
      'number': {s_num},
      'ayat': {jumlah_ayat},
      'color': {color},
      'audio': 'audio/surah/{filename}',
      'verses': [
"""
        for verse in data['ayat']:
            arabic = verse['teksArab'].replace("'", "\\'")
            latin = verse['teksLatin'].replace("'", "\\'")
            indo = verse['teksIndonesia'].replace("'", "\\'")
            dart_content += f"""        {{'arabic': '{arabic}', 'latin': '{latin}', 'arti': '{indo}'}},
"""
        dart_content += """      ],
    },
"""
    except Exception as e:
        print(f"Failed to fetch surah {s_num}: {e}")

dart_content += """  ];
}
"""

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.write(dart_content)

print(f"Generated {OUTPUT_FILE} successfully.")
