import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/soal_model.dart';

class QuizService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  ///=================================================
  /// TAMBAH QUIZ BARU
  ///=================================================

  Future<void> tambahQuiz({
    required String judul,
    required String deskripsi,
    required int durasi,
    required List<SoalModel> soal,
  }) async {

    final quizRef =
        _firestore.collection("quiz").doc();

    final batch = _firestore.batch();

    batch.set(
      quizRef,
      {
        "judul": judul,
        "deskripsi": deskripsi,
        "durasi": durasi,
        "jumlahSoal": soal.length,
        "createdAt":
            FieldValue.serverTimestamp(),
        "updatedAt":
            FieldValue.serverTimestamp(),
      },
    );

    for (final item in soal) {

      final soalRef =
          quizRef.collection("soal").doc();

      batch.set(
        soalRef,
        item.toMap(),
      );

    }

    await batch.commit();

  }

  ///=================================================
  /// SIMPAN QUIZ (DARI MAP)
  ///=================================================

  Future<void> simpanQuizBaru(
    Map<String, dynamic> quizData,
  ) async {

    final List<SoalModel> soal = [];

    for (final item in quizData["soal"]) {

      soal.add(
        SoalModel(
          pertanyaan: item["pertanyaan"],
          pilihanA: item["pilihanA"],
          pilihanB: item["pilihanB"],
          pilihanC: item["pilihanC"],
          pilihanD: item["pilihanD"],
          jawaban: item["jawaban"],
        ),
      );

    }

    await tambahQuiz(
      judul: quizData["judul"],
      deskripsi: quizData["deskripsi"],
      durasi: quizData["durasi"],
      soal: soal,
    );

  }

  ///=================================================
  /// DAFTAR QUIZ
  ///=================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getQuiz() {

    return _firestore
        .collection("quiz")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots();

  }

  ///=================================================
  /// DETAIL QUIZ
  ///=================================================

  Future<DocumentSnapshot<Map<String, dynamic>>>
      detailQuiz(
    String quizId,
  ) {

    return _firestore
        .collection("quiz")
        .doc(quizId)
        .get();

  }

  ///=================================================
  /// DAFTAR SOAL
  ///=================================================

  Future<List<SoalModel>> getSoal(
    String quizId,
  ) async {

    final snapshot = await _firestore
        .collection("quiz")
        .doc(quizId)
        .collection("soal")
        .get();

    return snapshot.docs
        .map(
          (e) => SoalModel.fromMap(e.data()),
        )
        .toList();

  }

  ///=================================================
  /// UPDATE QUIZ
  ///=================================================

  Future<void> updateQuiz({
  required String quizId,
  required String judul,
  required String deskripsi,
  required int durasi,
  required List<SoalModel> soal,
}) async {

  final quizRef =
      _firestore.collection("quiz").doc(quizId);

  final batch = _firestore.batch();

  // Update data quiz
  batch.update(
    quizRef,
    {
      "judul": judul,
      "deskripsi": deskripsi,
      "durasi": durasi,
      "jumlahSoal": soal.length,
    },
  );

  // Ambil semua soal lama
  final soalLama =
      await quizRef.collection("soal").get();

  // Hapus soal lama
  for (final item in soalLama.docs) {

    batch.delete(item.reference);

  }

  // Simpan soal baru
  for (final item in soal) {

    final soalRef =
        quizRef.collection("soal").doc();

    batch.set(
      soalRef,
      item.toMap(),
    );

  }

  await batch.commit();

}
  ///=================================================
  /// HAPUS QUIZ
  ///=================================================

  Future<void> hapusQuiz(
    String quizId,
  ) async {

    final quizRef =
        _firestore.collection("quiz").doc(quizId);

    final soal =
        await quizRef
            .collection("soal")
            .get();

    final batch = _firestore.batch();

    for (final item in soal.docs) {
      batch.delete(item.reference);
    }

    batch.delete(quizRef);

    await batch.commit();

  }
}