from gtts import gTTS
import os
import time

letters = {
    "alif": "أ",
    "ba": "ب",
    "ta": "ت",
    "tha": "ث",
    "jim": "ج",
    "hha": "ح",
    "kha": "خ",
    "dal": "د",
    "dhal": "ذ",
    "ra": "ر",
    "zay": "ز",
    "sin": "س",
    "shin": "ش",
    "sad": "ص",
    "dad": "ض",
    "tta": "ط",
    "za": "ظ",
    "ain": "ع",
    "ghain": "غ",
    "fa": "ف",
    "qaf": "ق",
    "kaf": "ك",
    "lam": "ل",
    "mim": "م",
    "nun": "ن",
    "waw": "و",
    "ha": "ه",
    "hamzah": "ء",
    "ya": "ي"
}

harakats = {
    "fathah": "َ",
    "kasrah": "ِ",
    "dhammah": "ُ"
}

for h_name, h_mark in harakats.items():
    os.makedirs(f"assets/audio/{h_name}", exist_ok=True)
    for l_name, l_char in letters.items():
        text = l_char + h_mark
        filename = f"assets/audio/{h_name}/{l_name}_{h_name}.mp3"
        if not os.path.exists(filename) or os.path.getsize(filename) == 0:
            try:
                tts = gTTS(text, lang='ar')
                tts.save(filename)
                print(f"Generated {filename}")
                time.sleep(0.5)
            except Exception as e:
                print(f"Error on {filename}: {e}")
        else:
            print(f"Exists {filename}")
