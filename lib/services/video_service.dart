import 'package:cloud_firestore/cloud_firestore.dart';

class VideoService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ===========================
  // TAMBAH VIDEO
  // ===========================

  Future<void> tambahVideo({
    required String judul,
    required String deskripsi,
    required String link,
  }) async {
    await _firestore.collection("video").add({
      "judul": judul,
      "deskripsi": deskripsi,
      "link": link,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // ===========================
  // UPDATE VIDEO
  // ===========================

  Future<void> updateVideo({
    required String id,
    required String judul,
    required String deskripsi,
    required String link,
  }) async {
    await _firestore.collection("video").doc(id).update({
      "judul": judul,
      "deskripsi": deskripsi,
      "link": link,
    });
  }

  // ===========================
  // HAPUS VIDEO
  // ===========================

  Future<void> hapusVideo(String id) async {
    await _firestore.collection("video").doc(id).delete();
  }

  // ===========================
  // GET VIDEO
  // ===========================

  Stream<QuerySnapshot<Map<String, dynamic>>> getVideo() {
    return _firestore
        .collection("video")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots();
  }
}