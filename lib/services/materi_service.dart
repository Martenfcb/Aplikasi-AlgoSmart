import 'package:cloud_firestore/cloud_firestore.dart';

class MateriService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Tambah Materi
  Future<void> tambahMateri({
    required String judul,
    required String deskripsi,
    required String link,
  }) async {
    await _firestore.collection('materi').add({
      'judul': judul,
      'deskripsi': deskripsi,
      'link': link,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update Materi
  Future<void> updateMateri({
    required String docId,
    required String judul,
    required String deskripsi,
    required String link,
  }) async {
    await _firestore.collection('materi').doc(docId).update({
      'judul': judul,
      'deskripsi': deskripsi,
      'link': link,
    });
  }

  /// Hapus Materi
  Future<void> hapusMateri(String docId) async {
    await _firestore.collection('materi').doc(docId).delete();
  }

  /// Stream semua materi
  Stream<QuerySnapshot<Map<String, dynamic>>> getMateri() {
    return _firestore
        .collection('materi')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Ambil satu materi
  Future<DocumentSnapshot<Map<String, dynamic>>> getMateriById(
      String docId) {
    return _firestore.collection('materi').doc(docId).get();
  }
}