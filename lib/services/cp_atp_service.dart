import 'package:cloud_firestore/cloud_firestore.dart';

class CPATPService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> tambahData({
    required String judul,
    required String kategori,
    required String isi,
  }) async {
    await _firestore.collection('cp_atp').add({
      'judul': judul,
      'kategori': kategori,
      'isi': isi,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateData({
    required String docId,
    required String judul,
    required String kategori,
    required String isi,
  }) async {
    await _firestore
        .collection('cp_atp')
        .doc(docId)
        .update({
      'judul': judul,
      'kategori': kategori,
      'isi': isi,
    });
  }

  Future<void> hapusData(
    String docId,
  ) async {
    await _firestore
        .collection('cp_atp')
        .doc(docId)
        .delete();
  }

  Stream<QuerySnapshot> getData() {
    return _firestore
        .collection('cp_atp')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }
}