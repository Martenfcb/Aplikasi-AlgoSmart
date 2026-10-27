import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HasilLatihanService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ============================================================
  // SIMPAN HASIL LATIHAN
  // ============================================================

  Future<void> simpanHasil({
    required int totalSoal,
    required int benar,
    required int salah,
    required int totalPoin,
    required int persentase,
    required String predikat,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'Siswa belum login.',
      );
    }

    await _firestore
        .collection('hasil_latihan')
        .add({
      'userId': user.uid,
      'email': user.email ?? '',
      'totalSoal': totalSoal,
      'benar': benar,
      'salah': salah,
      'totalPoin': totalPoin,
      'persentase': persentase,
      'predikat': predikat,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // AMBIL HASIL MILIK SISWA
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getHasilSiswa() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('hasil_latihan')
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ============================================================
  // AMBIL SEMUA HASIL
  // KHUSUS GURU
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getSemuaHasil() {
    return _firestore
        .collection('hasil_latihan')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }
}