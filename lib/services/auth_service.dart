import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //----------------------------------------
  // REGISTER
  //----------------------------------------

  Future<User?> register({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      print("========== REGISTER ==========");

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        throw Exception("User gagal dibuat.");
      }

      print("UID : ${user.uid}");
      print("Email : ${user.email}");

      print("Menyimpan data ke Firestore...");

      await _firestore
          .collection("users")
          .doc(user.uid)
          .set({
        "uid": user.uid,
        "nama": "",
        "nis": "",
        "email": email,
        "kelas": "",
        "jurusan": "",
        "jenisKelamin": "",
        "tanggalLahir": "",
        "alamat": "",
        "noHp": "",
        "foto": "",
        "role": role,
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("Data Firestore berhasil disimpan.");

      final check = await _firestore
          .collection("users")
          .doc(user.uid)
          .get();

      print("Dokumen ada : ${check.exists}");
      print("Isi data : ${check.data()}");

      return user;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error : ${e.code}");

      throw Exception(e.message);
    } on FirebaseException catch (e) {
      print("Firestore Error : ${e.code}");

      throw Exception(e.message);
    } catch (e) {
      print("Register Error : $e");

      rethrow;
    }
  }

  //----------------------------------------
  // LOGIN
  //----------------------------------------

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  //----------------------------------------
  // LOGOUT
  //----------------------------------------

  Future<void> logout() async {
    await _auth.signOut();
  }
}