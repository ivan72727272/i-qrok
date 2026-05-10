import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';

class MenuSurahScreen extends StatefulWidget {
  const MenuSurahScreen({super.key});

  @override
  State<MenuSurahScreen> createState() => _MenuSurahScreenState();
}

class _MenuSurahScreenState extends State<MenuSurahScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingSurah;

  static const List<Map<String, dynamic>> _surahs = [
    {
      'name': 'Al-Fatihah',
      'arabic': 'الفاتحة',
      'number': 1,
      'ayat': 7,
      'color': Color(0xFF66BB6A),
      'audio': 'audio/surah/al_fatihah.mp3',
      'verses': [
        {'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'latin': 'Bismillāhir-raḥmānir-raḥīm', 'arti': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.'},
        {'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'latin': 'Al-ḥamdu lillāhi rabbil-\'ālamīn', 'arti': 'Segala puji bagi Allah, Tuhan seluruh alam.'},
        {'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ', 'latin': 'Ar-raḥmānir-raḥīm', 'arti': 'Yang Maha Pengasih, Maha Penyayang.'},
        {'arabic': 'مَالِكِ يَوْمِ الدِّينِ', 'latin': 'Māliki yawmid-dīn', 'arti': 'Pemilik hari pembalasan.'},
        {'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', 'latin': 'Iyyāka na\'budu wa iyyāka nasta\'īn', 'arti': 'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan.'},
        {'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'latin': 'Ihdinaṣ-ṣirāṭal-mustaqīm', 'arti': 'Tunjukilah kami jalan yang lurus.'},
        {'arabic': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', 'latin': 'Ṣirāṭal-lażīna an\'amta \'alaihim gairil-magḍūbi \'alaihim wa laḍ-ḍāllīn', 'arti': '(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai dan bukan (pula jalan) mereka yang sesat.'},
      ],
    },
    {
      'name': 'Al-Ikhlas',
      'arabic': 'الإخلاص',
      'number': 112,
      'ayat': 4,
      'color': Color(0xFF42A5F5),
      'audio': 'audio/surah/al_ikhlas.mp3',
      'verses': [
        {'arabic': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'latin': 'Qul huwallāhu aḥad', 'arti': 'Katakanlah (Muhammad), "Dialah Allah, Yang Maha Esa.'},
        {'arabic': 'اللَّهُ الصَّمَدُ', 'latin': 'Allāhuṣ-ṣamad', 'arti': 'Allah tempat meminta segala sesuatu.'},
        {'arabic': 'لَمْ يَلِدْ وَلَمْ يُولَدْ', 'latin': 'Lam yalid wa lam yūlad', 'arti': '(Allah) tidak beranak dan tidak pula diperanakkan.'},
        {'arabic': 'وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌ', 'latin': 'Wa lam yakul lahū kufuwan aḥad', 'arti': 'Dan tidak ada sesuatu yang setara dengan Dia."'},
      ],
    },
    {
      'name': 'Al-Falaq',
      'arabic': 'الفلق',
      'number': 113,
      'ayat': 5,
      'color': Color(0xFFFFA726),
      'audio': 'audio/surah/al_falaq.mp3',
      'verses': [
        {'arabic': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', 'latin': 'Qul a\'ūżu birabbil-falaq', 'arti': 'Katakanlah, "Aku berlindung kepada Tuhan yang menguasai subuh (fajar),'},
        {'arabic': 'مِن شَرِّ مَا خَلَقَ', 'latin': 'Min syarri mā khalaq', 'arti': 'dari kejahatan (makhluk yang) Dia ciptakan,'},
        {'arabic': 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', 'latin': 'Wa min syarri gāsiqin iżā waqab', 'arti': 'dan dari kejahatan malam apabila telah gelap gulita,'},
        {'arabic': 'وَمِن شَرِّ النَّفَّاثَاتِ فِى الْعُقَدِ', 'latin': 'Wa min syarrin-naffāṡāti fil-\'uqad', 'arti': 'dan dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul (talinya),'},
        {'arabic': 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', 'latin': 'Wa min syarri ḥāsidin iżā ḥasad', 'arti': 'dan dari kejahatan orang yang dengki apabila dia dengki."'},
      ],
    },
    {
      'name': 'An-Nas',
      'arabic': 'الناس',
      'number': 114,
      'ayat': 6,
      'color': Color(0xFFAB47BC),
      'audio': 'audio/surah/an_nas.mp3',
      'verses': [
        {'arabic': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', 'latin': 'Qul a\'ūżu birabbin-nās', 'arti': 'Katakanlah, "Aku berlindung kepada Tuhannya manusia,'},
        {'arabic': 'مَلِكِ النَّاسِ', 'latin': 'Malikin-nās', 'arti': 'Raja manusia,'},
        {'arabic': 'إِلَٰهِ النَّاسِ', 'latin': 'Ilāhin-nās', 'arti': 'Sembahan manusia,'},
        {'arabic': 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ', 'latin': 'Min syarril-waswāsil-khannās', 'arti': 'dari kejahatan (bisikan) setan yang bersembunyi,'},
        {'arabic': 'الَّذِى يُوَسْوِسُ فِى صُدُورِ النَّاسِ', 'latin': 'Allażī yuwaswisu fī ṣudūrin-nās', 'arti': 'yang membisikkan (kejahatan) ke dalam dada manusia,'},
        {'arabic': 'مِنَ الْجِنَّةِ وَالنَّاسِ', 'latin': 'Minal-jinnati wan-nās', 'arti': 'dari (golongan) jin dan manusia."'},
      ],
    },
    {
      'name': 'Al-Kawthar',
      'arabic': 'الكوثر',
      'number': 108,
      'ayat': 3,
      'color': Color(0xFF26C6DA),
      'audio': 'audio/surah/al_kautsar.mp3',
      'verses': [
        {'arabic': 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ', 'latin': 'Innā a\'ṭainākal-kawṡar', 'arti': 'Sungguh, Kami telah memberimu (Muhammad) nikmat yang banyak.'},
        {'arabic': 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', 'latin': 'Faṣalli lirabbika wanḥar', 'arti': 'Maka laksanakanlah shalat karena Tuhanmu, dan berkurbanlah (sebagai ibadah dan mendekatkan diri kepada Allah).'},
        {'arabic': 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ', 'latin': 'Inna syāni\'aka huwal-abtar', 'arti': 'Sungguh, orang-orang yang membencimu dialah yang terputus (dari rahmat Allah).'},
      ],
    },
    {
      'name': 'Al-Ashr',
      'arabic': 'العصر',
      'number': 103,
      'ayat': 3,
      'color': Color(0xFFEF5350),
      'audio': 'audio/surah/al_asr.mp3',
      'verses': [
        {'arabic': 'وَالْعَصْرِ', 'latin': 'Wal-\'aṣr', 'arti': 'Demi masa.'},
        {'arabic': 'إِنَّ الْإِنسَانَ لَفِى خُسْرٍ', 'latin': 'Innal-insāna lafī khusr', 'arti': 'Sungguh, manusia berada dalam kerugian,'},
        {'arabic': 'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ', 'latin': 'Illal-lażīna āmanū wa \'amiluṣ-ṣāliḥāti wa tawāṣaw bil-ḥaqqi wa tawāṣaw biṣ-ṣabr', 'arti': 'kecuali orang-orang yang beriman dan mengerjakan kebajikan serta saling menasihati untuk kebenaran dan saling menasihati untuk kesabaran.'},
      ],
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioPath, String surahName) async {
    if (_playingSurah == surahName) {
      await _audioPlayer.stop();
      setState(() => _playingSurah = null);
      return;
    }
    setState(() => _playingSurah = surahName);
    try {
      await rootBundle.load('assets/$audioPath');
      await _audioPlayer.play(AssetSource(audioPath));
      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _playingSurah = null);
      });
    } catch (_) {
      if (mounted) {
        setState(() => _playingSurah = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Audio belum tersedia 😊', textAlign: TextAlign.center),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Surah Pendek',
        subtitle: 'Hafalan surah pilihan',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: _surahs.length,
            itemBuilder: (context, index) => _buildSurahCard(_surahs[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    final color = surah['color'] as Color;
    final isPlaying = _playingSurah == surah['name'];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () => _showSurahDetail(surah),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Number badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Center(
                    child: Text('${surah['number']}', style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(surah['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textMain)),
                          Text(surah['arabic'], style: TextStyle(fontSize: 22, color: color, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${surah['ayat']} ayat', style: const TextStyle(fontSize: 13, color: AppColors.textDim)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Play button
                GestureDetector(
                  onTap: () => _playAudio(surah['audio'], surah['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isPlaying ? color : color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: isPlaying ? Colors.white : color,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSurahDetail(Map<String, dynamic> surah) {
    final color = surah['color'] as Color;
    final verses = surah['verses'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surah['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                        Text('${surah['ayat']} Ayat', style: const TextStyle(color: AppColors.textDim, fontSize: 14)),
                      ],
                    ),
                    Text(surah['arabic'], style: TextStyle(fontSize: 32, color: color, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Divider(height: 24),
              // Verses
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: verses.length,
                  itemBuilder: (_, i) {
                    final verse = verses[i] as Map;
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: color.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(AppRadius.full)),
                                child: Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
                              ),
                              Flexible(
                                child: Text(
                                  verse['arabic'],
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 22, color: color, fontFamily: 'Amiri', height: 1.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(verse['latin'], style: TextStyle(fontSize: 13, color: color, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 4),
                          Text(verse['arti'], style: const TextStyle(fontSize: 13, color: AppColors.textDim, height: 1.4)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
