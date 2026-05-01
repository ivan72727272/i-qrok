import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DetailHurufScreen extends StatefulWidget {
  final String char;
  final String name;
  final Color color;

  const DetailHurufScreen({
    super.key,
    required this.char,
    required this.name,
    required this.color,
  });

  @override
  State<DetailHurufScreen> createState() => _DetailHurufScreenState();
}

class _DetailHurufScreenState extends State<DetailHurufScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // Dengarkan status pemutaran untuk mengubah icon
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      // Pastikan nama file sesuai (kecil semua, misal: alif.mp3)
      String fileName = '${widget.name.toLowerCase()}.mp3';
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memutar suara: File $fileName tidak ditemukan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text('Detail Huruf ${widget.name}'),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kontainer Huruf Besar
            Container(
              width: 250,
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                widget.char,
                style: TextStyle(
                  fontSize: 150,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Nama Huruf
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: widget.color.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Putar Suara
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              onPressed: _playSound,
              icon: Icon(
                _isPlaying ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                size: 30,
              ),
              label: Text(
                _isPlaying ? 'Sedang Memutar...' : 'Putar Suara',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Kembali
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
