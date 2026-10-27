import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/latihan_model.dart';

class LatihanService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection('latihan');

  // ============================================================
  // FIRESTORE
  // ============================================================

  FirebaseFirestore get firestore => _firestore;

  // ============================================================
  // STREAM LATIHAN
  // ============================================================

  Stream<List<LatihanModel>> streamLatihan() {
    return _collection
        .where(
          'aktif',
          isEqualTo: true,
        )
        .snapshots()
        .map((snapshot) {
      final List<LatihanModel> latihan = [];

      for (final doc in snapshot.docs) {
        final data =
            Map<String, dynamic>.from(
          doc.data(),
        );

        latihan.add(
          LatihanModel.fromMap(
            doc.id,
            data,
          ),
        );
      }

      latihan.sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;

        if (aDate == null && bDate == null) {
          return 0;
        }

        if (aDate == null) {
          return 1;
        }

        if (bDate == null) {
          return -1;
        }

        return bDate.compareTo(aDate);
      });

      return latihan;
    });
  }

  // ============================================================
  // AMBIL SATU LATIHAN
  // ============================================================

  Future<LatihanModel?> getLatihan(
    String id,
  ) async {
    final doc = await _collection.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    final data =
        Map<String, dynamic>.from(
      doc.data()!,
    );

    return LatihanModel.fromMap(
      doc.id,
      data,
    );
  }

  // Alias supaya kompatibel dengan kode lama
  Future<LatihanModel?> getLatihanById(
    String id,
  ) async {
    return getLatihan(id);
  }

  // ============================================================
  // TAMBAH LATIHAN
  // ============================================================

  Future<String> tambahLatihan({
    required String judul,
    required String deskripsi,
    required String materi,
    required String tingkat,
    required List<Map<String, dynamic>> soal,
  }) async {
    if (soal.isEmpty) {
      throw Exception(
        'Latihan minimal memiliki 1 soal.',
      );
    }

    if (soal.length > 50) {
      throw Exception(
        'Maksimal 50 soal dalam satu latihan.',
      );
    }

    final List<Map<String, dynamic>> soalFinal = [];

    for (int i = 0; i < soal.length; i++) {
      final item =
          Map<String, dynamic>.from(
        soal[i],
      );

      item['nomor'] = i + 1;

      soalFinal.add(item);
    }

    final doc = await _collection.add({
      'judul': judul.trim(),
      'deskripsi': deskripsi.trim(),
      'materi': materi.trim(),
      'tingkat': tingkat,
      'soal': soalFinal,
      'jumlahSoal': soalFinal.length,
      'aktif': true,
      'createdBy': 'guru',
      'createdAt':
          FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  // ============================================================
  // UPDATE LATIHAN
  // ============================================================

  Future<void> updateLatihan({
    required String id,
    required String judul,
    required String deskripsi,
    required String materi,
    required String tingkat,
    required List<Map<String, dynamic>> soal,
  }) async {
    if (soal.isEmpty) {
      throw Exception(
        'Latihan minimal memiliki 1 soal.',
      );
    }

    if (soal.length > 50) {
      throw Exception(
        'Maksimal 50 soal dalam satu latihan.',
      );
    }

    final List<Map<String, dynamic>> soalFinal = [];

    for (int i = 0; i < soal.length; i++) {
      final item =
          Map<String, dynamic>.from(
        soal[i],
      );

      item['nomor'] = i + 1;

      soalFinal.add(item);
    }

    await _collection.doc(id).update({
      'judul': judul.trim(),
      'deskripsi': deskripsi.trim(),
      'materi': materi.trim(),
      'tingkat': tingkat,
      'soal': soalFinal,
      'jumlahSoal': soalFinal.length,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // HAPUS LATIHAN
  // ============================================================

  Future<void> hapusLatihan(
    String id,
  ) async {
    await _collection.doc(id).delete();
  }

  // ============================================================
  // STATUS
  // ============================================================

  Future<void> toggleStatus(
    String id,
    bool aktif,
  ) async {
    await _collection.doc(id).update({
      'aktif': aktif,
    });
  }

  Future<void> aktifkanLatihan(
    String id,
  ) async {
    await toggleStatus(
      id,
      true,
    );
  }

  Future<void> nonaktifkanLatihan(
    String id,
  ) async {
    await toggleStatus(
      id,
      false,
    );
  }
}