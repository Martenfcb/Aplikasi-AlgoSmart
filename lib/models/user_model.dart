import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nama;
  final String email;
  final String role;
  final String nis;
  final String kelas;
  final String jurusan;
  final String noHp;
  final String alamat;
  final String jenisKelamin;
  final String tanggalLahir;
  final String foto;
  final String tentangSaya;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.nama,
    required this.email,
    required this.role,
    required this.nis,
    required this.kelas,
    required this.jurusan,
    required this.noHp,
    required this.alamat,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.foto,
    required this.tentangSaya,
    this.createdAt,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      uid: map['uid'] ?? '',
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      nis: map['nis'] ?? '',
      kelas: map['kelas'] ?? '',
      jurusan: map['jurusan'] ?? '',
      noHp: map['noHp'] ?? '',
      alamat: map['alamat'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? '',
      tanggalLahir: map['tanggalLahir'] ?? '',
      foto: map['foto'] ?? '',
      tentangSaya: map['tentangSaya'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'role': role,
      'nis': nis,
      'kelas': kelas,
      'jurusan': jurusan,
      'noHp': noHp,
      'alamat': alamat,
      'jenisKelamin': jenisKelamin,
      'tanggalLahir': tanggalLahir,
      'foto': foto,
      'tentangSaya': tentangSaya,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? nama,
    String? email,
    String? role,
    String? nis,
    String? kelas,
    String? jurusan,
    String? noHp,
    String? alamat,
    String? jenisKelamin,
    String? tanggalLahir,
    String? foto,
    String? tentangSaya,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      role: role ?? this.role,
      nis: nis ?? this.nis,
      kelas: kelas ?? this.kelas,
      jurusan: jurusan ?? this.jurusan,
      noHp: noHp ?? this.noHp,
      alamat: alamat ?? this.alamat,
      jenisKelamin:
          jenisKelamin ?? this.jenisKelamin,
      tanggalLahir:
          tanggalLahir ?? this.tanggalLahir,
      foto: foto ?? this.foto,
      tentangSaya:
          tentangSaya ?? this.tentangSaya,
      createdAt:
          createdAt ?? this.createdAt,
    );
  }
}