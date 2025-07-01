import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/helper/banahelper.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

class PengantarAplikasi extends StatefulWidget {
  const PengantarAplikasi({super.key});

  @override
  State<PengantarAplikasi> createState() => _PengantarAplikasiState();
}

class _PengantarAplikasiState extends State<PengantarAplikasi> {

  @override
  Widget build(BuildContext context) {
    final dark = Banahelper.modeGelap(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size * 0.06,
        child: AppBar(
          backgroundColor: dark ? warnaCerah3 : warnaPrimer1,
          title: const Text('Tentang Bawang Merah'),
        ),
      ),
      body: Padding(
        padding: paddingLR20,
        child: ListView(
          children: [
            j40,
            j20,            
            Text(
              'Bawang Merah',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ), j20,
            Column(
              children: [
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bawang merah merupakan salah satu komoditas hortikultura yang banyak dibudidayakan di Indonesia, karena memiliki banyak kandungan gizi dan senyawa yang baik untuk menjaga kesehatan manusia dan juga bawang merah cocok dibudidayakan di wilayah yang beriklim sub-tropis atau tropis, seperti di Indonesia. Bawang merah juga merupakan tanaman umbi lapis berakar serabut yang dibudidayakan dengan menggunakan umbi sebagai bibit, sehingga mudah untuk dikembangkan. Bawang merah berasal dari famili Liliaceae yang berjenis umbi lapis dan berakar serabut, tumbuh secara berumpun, biasanya 2-5 siung dalam 1 rumpun dengan umbi berwarna merah keunguan, dan memiliki daun yang berongga.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: dark? warnaCerah1 : warnaGelap2
                        ),
                      ),
                    ]
                  )
                ), j20,
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bawang merah berasal dari wilayah Asia Tengah, kemudian menyebar karena aktivitas perdagangan yang meningkat secara signifikan setelah ditemukannya jalur laut, yang terjadi pada periode abad pertengahan, yakni sekitar abad ke-8. Pada era Hindu-Buddha di Indonesia, jalur laut tersebut banyak membawa keuntungan, baik dari segi perdagangan maupun temuan komoditas-komoditas asing seperti bawang merah. Sejak saat itu, bawang merah telah dibudidayakan di Indonesia dan secara perlahan dijadikan sebagai bahan penyedap makanan bagi masyarakat Indonesia hingga sekarang.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: dark? warnaCerah1 : warnaGelap2
                        ),
                      )
                    ]
                  )
                ), j20,
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bawang merah telah dikembangkan sejak lama di Indonesia, tetapi tidak menghapus berbagai tantangan dalam usaha budidayanya. Berbagai macam hama dan penyakit juga mengalami perkembangan, seperti serangan fungi, nematoda, dan serangga. Oleh sebab itu, penting untuk memahami teknik dan metode budidaya bawang merah yang tepat, metode pengendalian hama dan penyakit, serta regulasi dalam perdagangan dan persebaran bawang merah.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: dark? warnaCerah1 : warnaGelap2
                        ),
                      )
                    ]
                  )
                ), j20,
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Aplikasi ini diharapkan dapat membantu dalam mengusahakan komoditas bawang merah secara tepat, sehingga dapat meningkatkan hasil produksi bawang merah di Indonesia. Tujuan dari pembuatan aplikasi ini adalah sebagai media edukasi yang dapat digunakan baik oleh petani ataupun mahasiswa untuk mempelajari pertanian bawang merah.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: dark? warnaCerah1 : warnaGelap2
                        ),
                      )
                    ]
                  )
                )
              ],
            )
          ],
        ),
      )
    );
  }
}