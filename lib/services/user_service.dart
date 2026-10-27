import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  // ============================================================
  // FIRESTORE
  // ============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // COLLECTION
  // ============================================================

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // ============================================================
  // GET SEMUA USER
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return _usersCollection
        .orderBy(
          'nama',
          descending: false,
        )
        .snapshots();
  }

  // ============================================================
  // GET USER BERDASARKAN ROLE
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersByRole(
    String role,
  ) {
    return _usersCollection
        .where(
          'role',
          isEqualTo: role,
        )
        .orderBy(
          'nama',
          descending: false,
        )
        .snapshots();
  }

  // ============================================================
  // GET SEMUA SISWA
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getSiswa() {
    return getUsersByRole('siswa');
  }

  // ============================================================
  // GET SEMUA ADMIN
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getAdmin() {
    return getUsersByRole('admin');
  }

  // ============================================================
  // GET USER BERDASARKAN UID
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
    String uid,
  ) async {
    return await _usersCollection
        .doc(uid)
        .get();
  }

  // ============================================================
  // TAMBAH DATA USER KE FIRESTORE
  // ============================================================
  //
  // Catatan:
  // Fungsi ini menyimpan PROFIL user ke Firestore.
  //
  // Pembuatan akun Firebase Authentication akan kita tangani
  // pada tahap form/tambah user agar akun login siswa benar-benar
  // dibuat.
  //
  // ============================================================

  Future<void> tambahUser({
    required String uid,
    required String nama,
    required String email,
    required String role,
    String nis = '',
    String sekolah = '',
    String kelas = '',
    String nomorHp = '',
    String bio = '',
  }) async {
    // Pastikan role hanya admin atau siswa.

    final normalizedRole =
        role.trim().toLowerCase();

    if (normalizedRole != 'admin' &&
        normalizedRole != 'siswa') {
      throw Exception(
        'Role hanya boleh admin atau siswa.',
      );
    }

    await _usersCollection
        .doc(uid)
        .set(
      {
        'uid': uid,
        'nama': nama.trim(),
        'email': email.trim(),
        'role': normalizedRole,

        // Data siswa
        'nis': nis.trim(),
        'sekolah': sekolah.trim(),
        'kelas': kelas.trim(),

        // Data umum
        'nomorHp': nomorHp.trim(),
        'bio': bio.trim(),

        'createdAt':
            FieldValue.serverTimestamp(),

        'updatedAt':
            FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  // ============================================================
  // UPDATE USER
  // ============================================================

  Future<void> updateUser({
    required String uid,
    required String nama,
    required String email,
    required String role,
    String nis = '',
    String sekolah = '',
    String kelas = '',
    String nomorHp = '',
    String bio = '',
  }) async {
    final normalizedRole =
        role.trim().toLowerCase();

    if (normalizedRole != 'admin' &&
        normalizedRole != 'siswa') {
      throw Exception(
        'Role hanya boleh admin atau siswa.',
      );
    }

    await _usersCollection
        .doc(uid)
        .update(
      {
        'nama': nama.trim(),
        'email': email.trim(),
        'role': normalizedRole,

        'nis': nis.trim(),
        'sekolah': sekolah.trim(),
        'kelas': kelas.trim(),

        'nomorHp': nomorHp.trim(),
        'bio': bio.trim(),

        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );
  }

  // ============================================================
  // UPDATE SEBAGIAN DATA USER
  // ============================================================
  //
  // Berguna apabila nanti hanya ingin mengubah beberapa field.
  //
  // ============================================================

  Future<void> updateUserFields({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    if (data.isEmpty) {
      return;
    }

    await _usersCollection
        .doc(uid)
        .update(
      {
        ...data,
        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );
  }

  // ============================================================
  // HAPUS USER
  // ============================================================
  //
  // PERHATIAN:
  // Fungsi ini menghapus data PROFIL dari Firestore.
  //
  // Penghapusan akun dari Firebase Authentication tidak dapat
  // dilakukan hanya dengan Flutter Client SDK untuk user lain.
  //
  // Kita akan membuat mekanisme penghapusan akun Authentication
  // pada tahap berikutnya.
  //
  // ============================================================

  Future<void> hapusUser(
    String uid,
  ) async {
    await _usersCollection
        .doc(uid)
        .delete();
  }

  // ============================================================
  // CEK APAKAH EMAIL SUDAH TERDAFTAR DI FIRESTORE
  // ============================================================

  Future<bool> emailSudahTerdaftar(
    String email,
  ) async {
    final snapshot = await _usersCollection
        .where(
          'email',
          isEqualTo: email.trim(),
        )
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // ============================================================
  // CEK APAKAH NIS SUDAH TERDAFTAR
  // ============================================================

  Future<bool> nisSudahTerdaftar(
    String nis, {
    String? exceptUid,
  }) async {
    final snapshot = await _usersCollection
        .where(
          'nis',
          isEqualTo: nis.trim(),
        )
        .limit(10)
        .get();

    for (final doc in snapshot.docs) {
      if (exceptUid == null ||
          doc.id != exceptUid) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // HITUNG JUMLAH USER
  // ============================================================

  Future<int> jumlahUser() async {
    final snapshot =
        await _usersCollection.get();

    return snapshot.docs.length;
  }

  // ============================================================
  // HITUNG JUMLAH SISWA
  // ============================================================

  Future<int> jumlahSiswa() async {
    final snapshot = await _usersCollection
        .where(
          'role',
          isEqualTo: 'siswa',
        )
        .get();

    return snapshot.docs.length;
  }

  // ============================================================
  // HITUNG JUMLAH ADMIN
  // ============================================================

  Future<int> jumlahAdmin() async {
    final snapshot = await _usersCollection
        .where(
          'role',
          isEqualTo: 'admin',
        )
        .get();

    return snapshot.docs.length;
  }
}