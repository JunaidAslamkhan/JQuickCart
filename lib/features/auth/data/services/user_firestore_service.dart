import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user_model.dart';

class UserFirestoreService {
  UserFirestoreService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }

  Future<void> createUserProfile(AppUserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<AppUserModel?> getUserProfile(String uid) async {
    final documentSnapshot = await _usersCollection.doc(uid).get();

    if (!documentSnapshot.exists || documentSnapshot.data() == null) {
      return null;
    }

    return AppUserModel.fromMap(documentSnapshot.data()!);
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _usersCollection.doc(uid).update({
      ...data,
      'updatedAt': Timestamp.now(),
    });
  }
}
