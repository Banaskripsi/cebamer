import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/data&fitur/user_profile.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/services/profilLahanService/lahan_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  late GlobalKey<State> _authKey;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Notifikasi _notifikasi;
  late LahanService lahan;
  final GetIt getIt = GetIt.instance;
  User? _user;

  User? get user {
    return _user;
  }

  void authStateChangesListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }

  GlobalKey<State>? get authKey {
    return _authKey;
  }

  AuthService() {
    _authKey = GlobalKey<State>();
    _auth.authStateChanges().listen(authStateChangesListener);
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> daftar(String email, String password, String username) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({'username': username, 'role': 'user', 'uid': user!.uid});
        await user!.updateDisplayName(username);
        await user!.reload();
        return true;
      }
    } on FirebaseAuthException {
      _notifikasi.notif(text: 'Email sudah terdaftar, silahkan gunakan email lain', icon: Icons.error);
    } return false;
  }

  Future<UserCredential> daftarGoogle() async {
    try {
      final GoogleSignInAccount? akunPengguna = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await akunPengguna?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw FirebaseAuthException;
    }
  }

  Future<void> simpanDataPengguna(UserProfile user) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set(user.toJson());
    } catch (e) {
      throw FirebaseAuthException;
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();

      Get.find<SelectedLahanController>().clearAll();
      Get.find<SelectedPeriodeController>().clearAll();
      return true;
    } catch (e) {
      _notifikasi.notif(text: 'Gagal logout, silahkan coba kembali', icon: Icons.error);
    } return false;
  }
}