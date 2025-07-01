import 'package:cebamer/data&fitur/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  CollectionReference? _userCollection;
  final GetIt getIt = GetIt.instance;

  DatabaseService () {
    setupCollectionRef();
  }

  void setupCollectionRef() {
    _userCollection = _fs
    .collection('users')
    .withConverter<UserProfile>(
      fromFirestore: (snapshots, _) => UserProfile.fromJson(snapshots.data()!),
      toFirestore: (userProfile, _) => userProfile.toJson()
    );
  }

  Future<void> buatProfil({required UserProfile userProfile}) async {
    await _userCollection?.doc(userProfile.username).set(userProfile);
  }
}