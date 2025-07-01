import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/data&fitur/kalender/kalender_tambahan.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:table_calendar/table_calendar.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Map<String, dynamic>> _acara = [];
  Map<String, dynamic>? _dataBulan;

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final GetIt  _getIt = GetIt.instance;
  late Notifikasi _notifikasi;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchCatatan(_selectedDay!);
    _notifikasi = _getIt.get<Notifikasi>();
    fetchInformasiBulanan(_focusedDay);
  }

  Future<void> hapusAcara(String docId) async {
    final user = FirebaseAuth.instance.currentUser!;
    final username = user.displayName;
    try {
      await FirebaseFirestore.instance
        .collection('informasiPengguna')
        .doc(username)
        .collection('kalender_catatan')
        .doc(docId)
        .delete();
      
      _notifikasi.notif(text: 'Catatan berhasil dihapus');
      fetchCatatan(_selectedDay!);
    } catch (e) {
      _notifikasi.notif(text: 'Gagal menghapus catatan');
    }
  }


  Future<void> fetchCatatan(DateTime date) async {
    final user = FirebaseAuth.instance.currentUser!;
    final username = user.displayName;
    String formatTanggal = DateFormat('yyyy-MM-dd').format(date);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('informasiPengguna')
      .doc(username)
      .collection('kalender_catatan')
      .where('date', isEqualTo: formatTanggal)
      .orderBy('tanggalTambah', descending: true)
      .get();

    if (mounted) {
      setState(() {
        _acara = snapshot.docs
            .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            })
            .toList();
      });
    }
  }

  Future<Map<String, dynamic>?> informasiBulanan(String namaBulan) async {
    final doc = await FirebaseFirestore.instance
      .collection('kalender_bulanan')
      .doc(namaBulan.toLowerCase())
      .get();

    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  void fetchInformasiBulanan(DateTime date) async {
    final bulan = DateFormat.MMMM('id_ID').format(date).toLowerCase();
    final data = await informasiBulanan(bulan);
    setState(() {
      _dataBulan = data;
    });
  }

  void _tambahCatatan() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) => KalenderCatatan(selectedDay: _selectedDay!)
    ).then((_) {
      // Refresh data after bottom sheet is closed
      fetchCatatan(_selectedDay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              j20,
              Padding(
                padding: paddingLR20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.MMMM('id_ID').format(_focusedDay),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 27,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          DateFormat.y('id_ID').format(_focusedDay),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 19,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    GradientText(
                      DateFormat.d('id_ID').format(_focusedDay),
                      colors: [
                        warnaPrimer1,
                        warnaBiru1
                      ],
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 37,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )
              ), j20,
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  _dataBulan?['info'] ?? 'Tidak ada info'
                ),
              ), j20,
              TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                  headerMargin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black, width: 3))
                  )
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.red
                  )
                ),
                calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(
                    color: Colors.red
                  ),

                ),
                locale: 'id_ID',
                focusedDay: _focusedDay,
                firstDay: DateTime(2020, 1, 1), 
                lastDay: DateTime(2030, 12, 31),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  fetchCatatan(selectedDay);
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                  fetchInformasiBulanan(focusedDay);
                },
              ), j20,
              Divider(
                thickness: 3,
                color: Colors.black,
              ), j20,
              Padding(
                padding: paddingLR20,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Catatan Hari Ini...',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ), j10,
              _acara.isEmpty
              ? Padding(
                  padding: paddingLR20,
                  child: Text('Tidak ada catatan untuk hari ini')
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _acara.length,
                itemBuilder: (context, index) {
                  final acara = _acara[index];
                  final List<Color> warnaRandom = [
                    warnaPrimer1,
                    warnaBiru1
                  ];
                  final int indexWarna = acara['id'].hashCode % warnaRandom.length;
                  final warnaCard = warnaRandom[indexWarna];
                  return Card(
                    color: warnaCard,
                    shadowColor: warnaBiru1,
                    elevation: 2,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: ListTile(
                      title: Text(
                        acara['judul'],
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                        ),
                      subtitle: Text(
                        acara['deskripsi'],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500
                        )
                        ),
                      trailing: IconButton(
                        icon: Icon(Remix.delete_bin_line, size: 26, color: Colors.black87,),
                        onPressed: () => hapusAcara(acara['id']),
                      ),
                    )
                  );
                },
              ), j20,
              Center(
                child: ElevatedButton.icon(
                  onPressed: _tambahCatatan,
                  icon: Icon(Remix.calendar_todo_fill),
                  label: Text('Tambahkan Catatan'),
                ),
              )
            ],
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}