import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

final FirebaseAuth _auth =
    FirebaseAuth.instance;

String get uid => _auth.currentUser!.uid;
  /// ===========================
  /// Jumlah Materi
  /// ===========================

  Stream<int> totalMateri() {
    return _firestore
        .collection('materi')
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// ===========================
  /// Jumlah Video
  /// ===========================

  Stream<int> totalVideo() {
    return _firestore
        .collection('video')
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// ===========================
  /// Jumlah Quiz
  /// ===========================

  Stream<int> totalQuiz() {
    return _firestore
        .collection('quiz')
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// ===========================
  /// Materi Terbaru
  /// ===========================

  Stream<QuerySnapshot<Map<String, dynamic>>> materiTerbaru() {
    return _firestore
        .collection("materi")
        .orderBy("createdAt", descending: true)
        .limit(5)
        .snapshots();
  }

  /// ===========================
  /// Video Terbaru
  /// ===========================

  Stream<QuerySnapshot<Map<String, dynamic>>> videoTerbaru() {
    return _firestore
        .collection("video")
        .orderBy("createdAt", descending: true)
        .limit(5)
        .snapshots();
  }

  /// ===========================
  /// Quiz Terbaru
  /// ===========================

  Stream<QuerySnapshot<Map<String, dynamic>>> quizTerbaru() {
    return _firestore
        .collection("quiz")
        .orderBy("createdAt", descending: true)
        .limit(5)
        .snapshots();
  }

    /// ===========================
  /// Progress Materi
  /// ===========================

  Stream<int> materiSelesai() {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_materi")
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// ===========================
  /// Progress Video
  /// ===========================

  Stream<int> videoSelesai() {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_video")
        .snapshots()
        .map((event) => event.docs.length);
  }

  /// ===========================
  /// Progress Quiz
  /// ===========================

  Stream<int> quizSelesai() {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_quiz")
        .snapshots()
        .map((event) => event.docs.length);
  }
  //======================================
// TOTAL PROGRESS BELAJAR
//======================================

Stream<double> progressBelajar() {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .snapshots()
      .asyncMap((_) async {

    final totalMateri =
        await _firestore
            .collection("materi")
            .get();

    final totalVideo =
        await _firestore
            .collection("video")
            .get();

    final totalQuiz =
        await _firestore
            .collection("quiz")
            .get();

    final materiSelesai =
        await _firestore
            .collection("users")
            .doc(uid)
            .collection("progress_materi")
            .get();

    final videoSelesai =
        await _firestore
            .collection("users")
            .doc(uid)
            .collection("progress_video")
            .get();

    final quizSelesai =
        await _firestore
            .collection("users")
            .doc(uid)
            .collection("progress_quiz")
            .get();

    final total =
        totalMateri.docs.length +
            totalVideo.docs.length +
            totalQuiz.docs.length;

    final selesai =
        materiSelesai.docs.length +
            videoSelesai.docs.length +
            quizSelesai.docs.length;

    if (total == 0) {
      return 0.0;
    }

    return selesai / total;
  });
}
}