import 'package:cebamer/helper/banahelper.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UsernameDisplay extends StatefulWidget {
  const UsernameDisplay({super.key});

  @override
  State<UsernameDisplay> createState() => _UsernameDisplayState();
}

class _UsernameDisplayState extends State<UsernameDisplay> {
  final localStorage = GetStorage();
  DocumentReference nama = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid);

  String username = '';

  @override
  void initState() {
    super.initState();
    username = localStorage.read('username') ?? '';
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    if (!mounted) return;
    try {
      DocumentReference authResult = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot docSnap = await authResult.get();
      if (docSnap.exists) {
        var data = docSnap.data() as Map<String, dynamic>;
        setState(() {
          username = data['username'];
        });
        localStorage.write('username', username);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Banahelper.modeGelap(context);
    return Text(
      username.isEmpty ? 'Memuat...' : username,
      style: TextStyle(
        color: dark ? warnaCerah1 : warnaGelap1,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'
      ),
    );
  }
}