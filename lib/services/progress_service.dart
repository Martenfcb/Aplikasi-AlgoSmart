import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  //----------------------------------
  // UID
  //----------------------------------

  String get uid => _auth.currentUser!.uid;

  //----------------------------------
  // MATERI
  //----------------------------------

  Future<void> selesaiMateri(
    String materiId,
  ) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_materi")
        .doc(materiId)
        .set({
      "selesai": true,
      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }

  //----------------------------------
  // VIDEO
  //----------------------------------

  Future<void> selesaiVideo(
    String videoId,
  ) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_video")
        .doc(videoId)
        .set({
      "selesai": true,
      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }

  //----------------------------------
  // QUIZ
  //----------------------------------

  Future<void> selesaiQuiz(
    String quizId,
    int nilai,
  ) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_quiz")
        .doc(quizId)
        .set({
      "selesai": true,
      "nilai": nilai,
      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }


//----------------------------------
// SIMULASI
//----------------------------------

Future<void> selesaiSimulasi(
  String simulasiId,
) async {
  await _firestore
      .collection("users")
      .doc(uid)
      .collection("progress_simulasi")
      .doc(simulasiId)
      .set({
    "simulasiId": simulasiId,
    "selesai": true,
    "createdAt": FieldValue.serverTimestamp(),
  });
}

//----------------------------------
// CEK SIMULASI
//----------------------------------

Future<bool> simulasiSudahSelesai(
  String simulasiId,
) async {
  final doc = await _firestore
      .collection("users")
      .doc(uid)
      .collection("progress_simulasi")
      .doc(simulasiId)
      .get();

  return doc.exists &&
      doc.data()?["selesai"] == true;
}
  //----------------------------------
  // TOTAL PROGRESS MATERI
  //----------------------------------

  Stream<int> totalMateriSelesai() {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_materi")
        .snapshots()
        .map((e) => e.docs.length);
  }

  //----------------------------------
  // TOTAL PROGRESS VIDEO
  //----------------------------------

  Stream<int> totalVideoSelesai() {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_video")
        .snapshots()
        .map((e) => e.docs.length);
  }

  //----------------------------------
  // TOTAL PROGRESS QUIZ
  //----------------------------------

  Stream<int> totalQuizSelesai() {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("progress_quiz")
        .snapshots()
        .map((e) => e.docs.length);
  }
}