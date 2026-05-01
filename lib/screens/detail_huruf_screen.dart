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

class _DetailHurufScreenState extends State<DetailHurufScreen> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (_isPlaying) {
            _controller.repeat(reverse: true);
          } else {
            _controller.stop();
            _controller.reset();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      String fileName = '${widget.name.toLowerCase()}.mp3';
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suara ${widget.name} segera hadir!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.color.withOpacity(0.1),
              const Color(0xFFF1F8E9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.color, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const Spacer(),
              // Kontainer Huruf Besar dengan Hero Animation
              Hero(
                tag: 'letter-${widget.char}',
                child: Container(
                  width: 280,
                  height: 280,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.char,
                      style: TextStyle(
                        fontSize: 180,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Nama Huruf
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: widget.color.withOpacity(0.8),
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              // Tombol Putar Suara dengan Efek Animasi
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.1).animate(_controller),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 10,
                    shadowColor: widget.color.withOpacity(0.5),
                  ),
                  onPressed: _playSound,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                    size: 40,
                  ),
                  label: Text(
                    _isPlaying ? 'Mendengarkan...' : 'Putar Suara',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
