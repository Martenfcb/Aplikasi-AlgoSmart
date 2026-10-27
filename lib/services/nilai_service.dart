import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NilaiService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ============================================================
  // USER LOGIN
  // ============================================================

  User? get currentUser => _auth.currentUser;

  // ============================================================
  // SIMPAN HASIL QUIZ
  // ============================================================

  Future<void> simpanNilai({
    required String judulQuiz,
    required int nilai,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw Exception("User belum login.");
    }

    // Ambil data user dari Firestore
    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("Data user tidak ditemukan.");
    }

    final userData = userDoc.data() ?? {};

    final String nama =
        userData['nama']?.toString().trim().isNotEmpty == true
            ? userData['nama'].toString()
            : user.displayName ?? "Siswa";

    final String foto =
        userData['foto']?.toString() ?? "";

    final String kelas =
        userData['kelas']?.toString() ?? "";

    final String nis =
        userData['nis']?.toString() ?? "";

    await _firestore.collection('nilai').add({
      'uid': user.uid,
      'nama': nama,
      'foto': foto,
      'kelas': kelas,
      'nis': nis,
      'quiz': judulQuiz,
      'judulQuiz': judulQuiz,
      'nilai': nilai,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // STREAM RANKING
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getRanking() {
    return _firestore
        .collection('nilai')
        .orderBy(
          'nilai',
          descending: true,
        )
        .orderBy(
          'createdAt',
          descending: false,
        )
        .snapshots();
  }

  // ============================================================
  // STREAM NILAI USER YANG LOGIN
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getNilaiSaya() {
    final user = currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('nilai')
        .where(
          'uid',
          isEqualTo: user.uid,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ============================================================
  // AMBIL NILAI USER SEKALI
  // ============================================================

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getNilaiSayaOnce() async {
    final user = currentUser;

    if (user == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('nilai')
        .where(
          'uid',
          isEqualTo: user.uid,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs;
  }

  // ============================================================
  // HITUNG RANKING USER
  // ============================================================

  Future<int> getRankingSaya() async {
    final user = currentUser;

    if (user == null) {
      return 0;
    }

    final snapshot = await _firestore
        .collection('nilai')
        .orderBy(
          'nilai',
          descending: true,
        )
        .orderBy(
          'createdAt',
          descending: false,
        )
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data();

      if (data['uid'] == user.uid) {
        return i + 1;
      }
    }

    return 0;
  }

  // ============================================================
  // NILAI TERTINGGI USER
  // ============================================================

  Future<int> getNilaiTertinggiSaya() async {
    final user = currentUser;

    if (user == null) {
      return 0;
    }

    final snapshot = await _firestore
        .collection('nilai')
        .where(
          'uid',
          isEqualTo: user.uid,
        )
        .orderBy(
          'nilai',
          descending: true,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    final data = snapshot.docs.first.data();

    return (data['nilai'] as num?)?.toInt() ?? 0;
  }
}