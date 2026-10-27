import 'package:cloud_firestore/cloud_firestore.dart';

class SoalLatihanModel {
  final String id;
  final int nomor;
  final String pertanyaan;
  final String tipe;
  final Map<String, String> pilihan;
  final String jawaban;
  final int poin;

  const SoalLatihanModel({
    required this.id,
    required this.nomor,
    required this.pertanyaan,
    required this.tipe,
    required this.pilihan,
    required this.jawaban,
    required this.poin,
  });

  factory SoalLatihanModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    final pilihan =
        <String, String>{};

    final pilihanData = data['pilihan'];

    if (pilihanData is Map) {
      pilihanData.forEach(
        (key, value) {
          pilihan[key.toString()] =
              value?.toString() ?? '';
        },
      );
    }

    return SoalLatihanModel(
      id: id,
      nomor: _toInt(
        data['nomor'],
        1,
      ),
      pertanyaan:
          data['pertanyaan']
                  ?.toString() ??
              '',
      tipe:
          data['tipe']?.toString() ??
              'pilihan_ganda',
      pilihan: pilihan,
      jawaban:
          data['jawaban']?.toString() ??
              '',
      poin: _toInt(
        data['poin'],
        10,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nomor': nomor,
      'pertanyaan': pertanyaan,
      'tipe': tipe,
      'pilihan': pilihan,
      'jawaban': jawaban,
      'poin': poin,
    };
  }

  static int _toInt(
    dynamic value,
    int fallback,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return fallback;
  }
}

class LatihanModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String materi;
  final String tingkat;
  final int jumlahSoal;
  final bool aktif;
  final Timestamp? createdAt;
  final String createdBy;
  final List<SoalLatihanModel> soal;

  const LatihanModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.materi,
    required this.tingkat,
    required this.jumlahSoal,
    required this.aktif,
    required this.createdAt,
    required this.createdBy,
    this.soal = const [],
  });

  factory LatihanModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    final List<SoalLatihanModel> soalList = [];

    final soalData = data['soal'];

    if (soalData is List) {
      for (int i = 0;
          i < soalData.length;
          i++) {
        final item = soalData[i];

        if (item is Map) {
          final map =
              Map<String, dynamic>.from(
            item,
          );

          soalList.add(
            SoalLatihanModel.fromMap(
              '${id}_soal_${i + 1}',
              map,
            ),
          );
        }
      }
    }

    return LatihanModel(
      id: id,
      judul:
          data['judul']?.toString() ??
              '',
      deskripsi:
          data['deskripsi']
                  ?.toString() ??
              '',
      materi:
          data['materi']?.toString() ??
              '',
      tingkat:
          data['tingkat']?.toString() ??
              'mudah',
      jumlahSoal:
          _toInt(
            data['jumlahSoal'],
            soalList.length,
          ),
      aktif:
          data['aktif'] ?? true,
      createdAt:
          data['createdAt']
              is Timestamp
              ? data['createdAt']
              : null,
      createdBy:
          data['createdBy']
                  ?.toString() ??
              'guru',
      soal: soalList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'materi': materi,
      'tingkat': tingkat,
      'jumlahSoal': jumlahSoal,
      'aktif': aktif,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'soal': soal
          .map(
            (item) => item.toMap(),
          )
          .toList(),
    };
  }

  static int _toInt(
    dynamic value,
    int fallback,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return fallback;
  }
}