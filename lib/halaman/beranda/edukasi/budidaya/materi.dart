import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/beranda/edukasi/budidaya/model/materi_model.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';

class MateriEdukasi extends StatefulWidget {
  final MateriModel materi;
  const MateriEdukasi({super.key, required this.materi});

  @override
  State<MateriEdukasi> createState() => _MateriEdukasiState();
}

class _MateriEdukasiState extends State<MateriEdukasi> with TickerProviderStateMixin {
  late List<bool> _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = List.generate(widget.materi.materiItem?.length ?? 1, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBG1,
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                j30,
                header(context, judul: widget.materi.headerJudul, deskripsi: widget.materi.headerDeskripsi),
                j10,
                // Judul Materi
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.materi.materiItem?.length ?? 1,
                  itemBuilder: (context, index) {
                    final item = widget.materi.materiItem?[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isVisible[index] = !_isVisible[index];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _isVisible[index] ? primer1 : primer1.withOpacity(0.5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item!.judulMateri,
                                  style: _isVisible[index] ? BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3) : BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
                                ),
                                Icon(_isVisible[index] ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: primer3,)
                              ],
                            ),
                          ),
                        ), j10,
                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _isVisible[index]
                              ? Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: warnaCerah3
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Deskripsi: ',
                                        style: BanaTemaTeks.temaCerah.labelMedium!.copyWith(color: primer3)
                                      ),
                                      Text(
                                        item.deskripsiMateri,
                                        style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3)
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                        j20,
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      );
  }
}