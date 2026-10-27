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
    final rawPilihan = data['pilihan'];

    final Map<String, String> pilihan = {};

    if (rawPilihan is Map) {
      rawPilihan.forEach((key, value) {
        pilihan[key.toString()] =
            value?.toString() ?? '';
      });
    }

    return SoalLatihanModel(
      id: id,
      nomor: _toInt(data['nomor'], 1),
      pertanyaan:
          data['pertanyaan']?.toString() ?? '',
      tipe:
          data['tipe']?.toString() ??
              'pilihan_ganda',
      pilihan: pilihan,
      jawaban:
          data['jawaban']?.toString() ?? '',
      poin: _toInt(data['poin'], 10),
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
    int defaultValue,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        defaultValue;
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
    Map<String, dynamic> data, {
    List<SoalLatihanModel> soal = const [],
  }) {
    final rawSoal = data['soal'];

    List<SoalLatihanModel> soalList =
        soal;

    if (rawSoal is List) {
      soalList = [];

      for (int i = 0;
          i < rawSoal.length;
          i++) {
        final item = rawSoal[i];

        if (item is Map) {
          final map =
              Map<String, dynamic>.from(
            item,
          );

          soalList.add(
            SoalLatihanModel.fromMap(
              '${id}_soal_${i + 1}',
              {
                ...map,
                'nomor':
                    map['nomor'] ?? i + 1,
              },
            ),
          );
        }
      }
    }

    return LatihanModel(
      id: id,
      judul:
          data['judul']?.toString() ?? '',
      deskripsi:
          data['deskripsi']?.toString() ?? '',
      materi:
          data['materi']?.toString() ?? '',
      tingkat:
          data['tingkat']?.toString() ??
              'mudah',
      jumlahSoal: _toInt(
        data['jumlahSoal'],
        soalList.length,
      ),
      aktif:
          data['aktif'] is bool
              ? data['aktif'] as bool
              : true,
      createdAt:
          data['createdAt'] is Timestamp
              ? data['createdAt']
                  as Timestamp
              : null,
      createdBy:
          data['createdBy']?.toString() ??
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
    int defaultValue,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        defaultValue;
  }
}