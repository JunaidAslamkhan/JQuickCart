import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/address_model.dart';

class AddressFirestoreService {
  AddressFirestoreService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _addressesCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('addresses');
  }

  Future<void> addAddress({
    required String uid,
    required AddressModel address,
  }) async {
    await _addressesCollection(uid).doc(address.id).set(address.toMap());
  }

  Stream<List<AddressModel>> getUserAddresses(String uid) {
    return _addressesCollection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return AddressModel.fromMap({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  Future<void> deleteAddress({
    required String uid,
    required String addressId,
  }) async {
    await _addressesCollection(uid).doc(addressId).delete();
  }

  Future<void> setDefaultAddress({
    required String uid,
    required String addressId,
  }) async {
    final addressesSnapshot = await _addressesCollection(uid).get();

    final batch = _firestore.batch();

    for (final doc in addressesSnapshot.docs) {
      batch.update(doc.reference, {
        'isDefault': doc.id == addressId,
        'updatedAt': Timestamp.now(),
      });
    }

    await batch.commit();
  }
}
