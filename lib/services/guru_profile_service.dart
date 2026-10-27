import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuruProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ============================================================
  // GET CURRENT USER ID
  // ============================================================

  String? get uid => _auth.currentUser?.uid;

  // ============================================================
  // GET PROFILE
  // ============================================================

  Future<Map<String, dynamic>?> getProfile() async {
    final userId = uid;

    if (userId == null) {
      return null;
    }

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return doc.data();
  }

  // ============================================================
  // SAVE / UPDATE PROFILE
  // ============================================================

  Future<void> saveProfile({
    required String nama,
    required String email,
    required String nip,
    required String sekolah,
    required String mataPelajaran,
    required String noHp,
    required String bio,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Akun tidak ditemukan.');
    }

    final data = <String, dynamic>{
      'uid': user.uid,
      'nama': nama,
      'email': email,
      'role': 'guru',
      'nip': nip,
      'sekolah': sekolah,
      'mataPelajaran': mataPelajaran,
      'noHp': noHp,
      'bio': bio,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
          data,
          SetOptions(merge: true),
        );

    // Nama juga diperbarui di Firebase Authentication
    if (user.displayName != nama) {
      await user.updateDisplayName(nama);
    }

    await user.reload();
  }

  // ============================================================
  // CREATE PROFILE IF NOT EXISTS
  // ============================================================

    Future<void> createProfileIfNotExists() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'nama': user.displayName ?? '',
      'email': user.email ?? '',
      'role': 'guru',
      'nip': '',
      'sekolah': '',
      'mataPelajaran':
          'Algoritma dan Pemrograman',
      'noHp': '',
      'bio': '',
      'createdAt':
          FieldValue.serverTimestamp(),
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // REAUTHENTICATE USER
  // ============================================================

  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Akun tidak ditemukan.');
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      throw Exception(
        'Email akun tidak ditemukan.',
      );
    }

    final credential =
        EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(
      credential,
    );
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> changePassword(
    String newPassword,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Akun tidak ditemukan.');
    }

    if (newPassword.trim().length < 6) {
      throw Exception(
        'Password baru minimal 6 karakter.',
      );
    }

    await user.updatePassword(
      newPassword.trim(),
    );
  }
}