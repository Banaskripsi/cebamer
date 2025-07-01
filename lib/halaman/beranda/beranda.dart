import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/data&fitur/nama_display.dart';
import 'package:cebamer/halaman/beranda/edukasi/budidaya/budidaya_main.dart';
import 'package:cebamer/halaman/beranda/edukasi/jenishama/jenishama_main.dart';
import 'package:cebamer/halaman/beranda/edukasi/varietas/varietas_main.dart';
import 'package:cebamer/halaman/beranda/video_helper.dart';
import 'package:cebamer/halaman/beranda/video_main.dart';
import 'package:cebamer/services/navigasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final localStorage = GetStorage();
  final GetIt getIt = GetIt.instance;
  final NavigasiService _navigasi = Get.find<NavigasiService>();

  List<String> urlVideo = [
    'https://youtu.be/cYBjtM6jlrM?si=ThR4AR1pJxeZHJZA',
    'https://youtu.be/KWwzTBGloLg?si=yLLzzI5uWUY94zIa',
    'https://youtu.be/gHlFS4fneKs?si=UZuV-xHXStElP_-1',
    'https://youtu.be/S2zePVreZKk?si=BJz1irWA26OmjkRA',
    'https://youtu.be/3uTA7IRw5YY?si=_iX1dZIRR8M9oNuE'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size * 0.08,
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30)
            )
          ),
          backgroundColor: primer1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  j10,
                  Text(
                    'Selamat datang!',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  UsernameDisplay()
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Symbols.notification_important, size: 40),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: paddingLR20,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pengantarAplikasi(),
                j20,
                
                Text(
                  'Apa yang ingin anda ketahui?',
                  style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                ), j20,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.maxFinite,
                  child: _edukasi()
                ),
                j20,
                Text(
                  'Dapatkan materi yang relevan untuk lahan Anda...',
                  style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3, fontWeight: FontWeight.bold)
                ), j20,
                buildVideoList(),
                j50,
              ],
            )
          ]
        ),
      ),
    );
  }

  //P E N G A N T A R  A P L I K A S I  
  Widget _pengantarAplikasi () {
    return GestureDetector(
      onTap: () => _navigasi.pindahHalaman('/pengantar'),
      child: Column(
        children: [
          Image.asset('assets/image/logoutama.png'), j5,
          Text(
            'Cerdas Bertani Bawang Merah',
            style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic),
          ), j10,
          Divider(
            thickness: 1,
          ),
          Text(
            'Aplikasi untuk belajar tentang bawang merah dan mengelola data lahan bawang merah Anda.'
          )
        ],
      ),
    );
  }

  Widget _edukasi() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(() => BudidayaMain()),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: primer2,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.agriculture,
                    size: 80,
                    color: warnaCerah3,
                  ), j10,
                  Text(
                    'Budidaya',
                    textAlign: TextAlign.center,
                    style: BanaTemaTeks.temaCerah.titleSmall!.copyWith(color: warnaCerah3)
                  ),
                ],
              ),
            ),
          ),
        ), j10,
        GestureDetector(
          onTap: () => Get.to(() => VarietasMain()),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: primer2,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.photo_prints,
                    size: 80,
                    color: warnaCerah3,
                  ), j10,
                  Text(
                    'Varietas',
                    textAlign: TextAlign.center,
                    style: BanaTemaTeks.temaCerah.titleSmall!.copyWith(color: warnaCerah3)
                  ),
                ],
              ),
            ),
          ),
        ), j10,
        GestureDetector(
          onTap: () => Get.to(() => JenishamaMain()),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: primer2,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.pest_control_rounded,
                    size: 80,
                    color: warnaCerah3,
                  ), j10,
                  Text(
                    'Jenis OPT',
                    textAlign: TextAlign.center,
                    style: BanaTemaTeks.temaCerah.titleSmall!.copyWith(color: warnaCerah3)
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget buildVideoList() {
    String? convertYoutubeUrlToId(String url) {
      final uri = Uri.tryParse(url);
      if (uri == null || (!uri.host.contains('youtube.com') && !uri.host.contains('youtu.be'))) {
        return null;
      }

      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }

      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }

      return null;
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urlVideo.length,
        itemBuilder: (context, index) {
          final url = urlVideo[index];
          final videoId = convertYoutubeUrlToId(url);
          
          // Validasi videoId
          if (videoId == null) {
            return Container(
              width: 200,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'URL tidak valid',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          
          final thumbnail = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

          return FutureBuilder<Map<String, String>>(
            future: YoutubeHelper.fetchVideoInfo(url),
            builder: (context, snapshot) {
              final title = snapshot.data?['title'] ?? 'Memuat...';
              final author = snapshot.data?['author'] ?? '';
              final hasError = snapshot.hasError;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    if (!hasError) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoMain(url: url),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: primer1,
                      borderRadius: BorderRadius.circular(20),
                      image: !hasError ? DecorationImage(
                        image: NetworkImage(thumbnail),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle error loading thumbnail
                        },
                      ) : null,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasError)
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 30,
                            )
                          else ...[
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              author,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Tonton',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

