import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

      final FirebaseStorage _storage =
    FirebaseStorage.instance;

  //--------------------------------------------
  // USER LOGIN
  //--------------------------------------------

  User? get currentUser => _auth.currentUser;

  //--------------------------------------------
  // STREAM PROFILE
  //--------------------------------------------

  Stream<UserModel> getProfile() {
    final user = currentUser;

    if (user == null) {
      throw Exception("User belum login.");
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map(
          (snapshot) => UserModel.fromMap(
            snapshot.data() ?? {},
          ),
        );
  }

  //--------------------------------------------
  // GET PROFILE SEKALI
  //--------------------------------------------

  Future<UserModel?> getProfileOnce() async {
    final user = currentUser;

    if (user == null) return null;

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromMap(doc.data()!);
  }

  //--------------------------------------------
  // UPDATE PROFILE
  //--------------------------------------------

  Future<void> updateProfile(
    UserModel model,
  ) async {
    await _firestore
        .collection('users')
        .doc(model.uid)
        .update(model.toMap());
  }

  //--------------------------------------------
  // UPDATE FOTO
  //--------------------------------------------

  Future<void> updatePhoto(
    String photoUrl,
  ) async {
    final user = currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'foto': photoUrl,
    });
  }

  //--------------------------------------------
// UPLOAD FOTO PROFIL
//--------------------------------------------

Future<String> uploadPhoto(
  File imageFile,
) async {

  final user = currentUser;

  if (user == null) {
    throw Exception("User belum login");
  }

  final ref = _storage
      .ref()
      .child("profile")
      .child("${user.uid}.jpg");

  await ref.putFile(imageFile);

  final url = await ref.getDownloadURL();

  await _firestore
      .collection("users")
      .doc(user.uid)
      .update({
    "foto": url,
  });

  return url;
}

  //--------------------------------------------
  // GANTI PASSWORD
  //--------------------------------------------

  Future<void> changePassword(
    String newPassword,
  ) async {
    final user = currentUser;

    if (user == null) return;

    await user.updatePassword(
      newPassword,
    );
  }

  //--------------------------------------------
  // LOGOUT
  //--------------------------------------------

  Future<void> logout() async {
    await _auth.signOut();
  }
}