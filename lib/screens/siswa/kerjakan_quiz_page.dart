import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/soal_model.dart';
import '../../services/nilai_service.dart';
import '../../services/progress_service.dart';

import 'hasil_quiz_page.dart';
import 'widgets/siswa_bottom_navigation.dart';

class KerjakanQuizPage extends StatefulWidget {
  final String quizId;

  const KerjakanQuizPage({
    super.key,
    required this.quizId,
  });

  @override
  State<KerjakanQuizPage> createState() =>
      _KerjakanQuizPageState();
}

class _KerjakanQuizPageState
    extends State<KerjakanQuizPage> {
  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // SERVICE
  // ============================================================

  final NilaiService nilaiService =
      NilaiService();

  final ProgressService progressService =
      ProgressService();

  // ============================================================
  // DATA QUIZ
  // ============================================================

  Map<String, dynamic>? quiz;

  List<SoalModel> daftarSoal = [];

  // ============================================================
  // JAWABAN SISWA
  // ============================================================

  List<String?> jawabanSiswa = [];

  // ============================================================
  // INDEX SOAL
  // ============================================================

  int currentIndex = 0;

  // ============================================================
  // STATUS
  // ============================================================

  bool loading = true;

  bool menyimpan = false;

  // ============================================================
  // WARNA
  // ============================================================

  static const Color primaryColor =
      Color(0xFF4F46E5);

  static const Color secondaryColor =
      Color(0xFF7C3AED);

  static const Color backgroundColor =
      Color(0xFFF5F7FB);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    ambilQuiz();
  }

  // ============================================================
  // AMBIL QUIZ
  // ============================================================

  Future<void> ambilQuiz() async {
    try {
      final quizDoc = await firestore
          .collection('quiz')
          .doc(widget.quizId)
          .get();

      if (!quizDoc.exists) {
        if (!mounted) return;

        await _showErrorDialog(
          'Quiz External Tidak Ditemukan',
          'Quiz ini belum memiliki soal yang dapat dikerjakan.',
        );

        if (mounted) {
          Navigator.pop(context);
        }

        return;
      }

      final soalSnapshot = await firestore
          .collection('quiz')
          .doc(widget.quizId)
          .collection('soal')
          .get();

      final List<SoalModel> listSoal =
          soalSnapshot.docs
              .map(
                (document) =>
                    SoalModel.fromMap(
                  document.data(),
                ),
              )
              .toList();

      if (!mounted) return;

      if (listSoal.isEmpty) {
        await _showErrorDialog(
          'Soal Belum Tersedia',
          'Quiz ini belum memiliki soal yang dapat dikerjakan.',
        );

        if (mounted) {
          Navigator.pop(context);
        }

        return;
      }

      setState(() {
        quiz = quizDoc.data();

        daftarSoal = listSoal;

        jawabanSiswa = List<String?>.generate(
          listSoal.length,
          (_) => null,
        );

        currentIndex = 0;

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      await _showErrorDialog(
        'Gagal Memuat Quiz',
        e.toString(),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  // ============================================================
  // JUDUL QUIZ
  // ============================================================

  String get judulQuiz {
    return quiz?['judul']?.toString().trim().isNotEmpty ==
            true
        ? quiz!['judul'].toString()
        : 'Quiz';
  }

  // ============================================================
  // DESKRIPSI QUIZ
  // ============================================================

  String get deskripsiQuiz {
    return quiz?['deskripsi']?.toString() ?? '';
  }

  // ============================================================
  // PILIH JAWABAN
  // ============================================================

  void pilihJawaban(String? value) {
    if (menyimpan) return;

    if (value == null) return;

    setState(() {
      jawabanSiswa[currentIndex] = value;
    });
  }

  // ============================================================
  // SOAL SEBELUMNYA
  // ============================================================

  void previousSoal() {
    if (menyimpan) return;

    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  // ============================================================
  // SOAL BERIKUTNYA
  // ============================================================

  void nextSoal() {
    if (menyimpan) return;

    if (jawabanSiswa[currentIndex] == null) {
      _showMessage(
        'Silakan pilih jawaban terlebih dahulu.',
        isError: true,
      );

      return;
    }

    if (currentIndex <
        daftarSoal.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  // ============================================================
  // PROGRESS QUIZ
  // ============================================================

  double get progressQuiz {
    if (daftarSoal.isEmpty) {
      return 0;
    }

    return (currentIndex + 1) /
        daftarSoal.length;
  }

  // ============================================================
  // JUMLAH SOAL DIJAWAB
  // ============================================================

  int get jumlahSudahDijawab {
    return jawabanSiswa
        .where(
          (jawaban) =>
              jawaban != null &&
              jawaban!.isNotEmpty,
        )
        .length;
  }

  // ============================================================
  // SOAL AKTIF
  // ============================================================

  SoalModel get soalAktif {
    return daftarSoal[currentIndex];
  }

  // ============================================================
  // SOAL TERAKHIR
  // ============================================================

  bool get soalTerakhir {
    return currentIndex ==
        daftarSoal.length - 1;
  }

  // ============================================================
  // HITUNG NILAI
  // ============================================================

  int hitungNilai() {
    if (daftarSoal.isEmpty) {
      return 0;
    }

    int benar = 0;

    for (int i = 0;
        i < daftarSoal.length;
        i++) {
      if (jawabanSiswa[i] ==
          daftarSoal[i].jawaban) {
        benar++;
      }
    }

    return (
      (benar / daftarSoal.length) * 100
    ).round();
  }

  // ============================================================
  // HITUNG JAWABAN BENAR
  // ============================================================

  int hitungBenar() {
    int benar = 0;

    for (int i = 0;
        i < daftarSoal.length;
        i++) {
      if (jawabanSiswa[i] ==
          daftarSoal[i].jawaban) {
        benar++;
      }
    }

    return benar;
  }

  // ============================================================
  // SELESAIKAN QUIZ
  // ============================================================

  Future<void> selesaiQuiz() async {
    if (menyimpan) return;

    // Pastikan soal terakhir dijawab
    if (jawabanSiswa[currentIndex] == null) {
      _showMessage(
        'Silakan pilih jawaban terlebih dahulu.',
        isError: true,
      );

      return;
    }

    // Pastikan semua soal sudah dijawab
    final int belumDijawab =
        daftarSoal.length -
            jumlahSudahDijawab;

    if (belumDijawab > 0) {
      final bool? lanjut =
          await _showKonfirmasiBelumLengkap(
        belumDijawab,
      );

      if (lanjut != true) {
        return;
      }
    } else {
      final bool? yakin =
          await _showKonfirmasiSelesai();

      if (yakin != true) {
        return;
      }
    }

    final int nilai = hitungNilai();

    setState(() {
      menyimpan = true;
    });

    try {
      // ========================================================
      // SIMPAN NILAI KE FIREBASE
      // ========================================================

      await nilaiService.simpanNilai(
        judulQuiz: judulQuiz,
        nilai: nilai,
      );

      // ========================================================
      // SIMPAN PROGRESS QUIZ
      // ========================================================

      await progressService.selesaiQuiz(
        widget.quizId,
        nilai,
      );

      if (!mounted) return;

      // ========================================================
      // PINDAH KE HASIL QUIZ
      // ========================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HasilQuizPage(
            nilai: nilai,
            judul: judulQuiz,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        menyimpan = false;
      });

      _showMessage(
        'Gagal menyimpan hasil quiz.\n$e',
        isError: true,
      );
    }
  }

  // ============================================================
  // DIALOG KONFIRMASI SEMUA SUDAH DIJAWAB
  // ============================================================

  Future<bool?> _showKonfirmasiSelesai() async {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Selesaikan Quiz?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Semua soal sudah dijawab. '
            'Apakah kamu yakin ingin mengakhiri quiz dan menyimpan nilai?',
            style: TextStyle(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Periksa Lagi'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Selesai',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DIALOG SOAL BELUM LENGKAP
  // ============================================================

  Future<bool?> _showKonfirmasiBelumLengkap(
    int belumDijawab,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Belum Lengkap',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Masih ada $belumDijawab soal yang belum dijawab.\n\n'
            'Jika kamu melanjutkan, soal yang belum dijawab akan dianggap salah.',
            style: const TextStyle(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Kembali',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Tetap Selesai',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red : primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR DIALOG
  // ============================================================

  Future<void> _showErrorDialog(
    String title,
    String message,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              height: 1.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }

    if (daftarSoal.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Tidak ada soal.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        title: const Text(
          'Kerjakan Quiz',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: menyimpan
              ? null
              : () => _konfirmasiKeluar(),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  20,
                ),
                child: Column(
                  children: [
                    _buildQuizHeader(),

                    const SizedBox(height: 16),

                    _buildQuestionIndicator(),

                    const SizedBox(height: 16),

                    _buildQuestionCard(),

                    const SizedBox(height: 16),

                    _buildAnswerSection(),
                  ],
                ),
              ),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 3,
      ),
);
  }

  // ============================================================
  // QUIZ HEADER
  // ============================================================

  Widget _buildQuizHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                primaryColor.withOpacity(.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(.15),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  judulQuiz,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          if (deskripsiQuiz.isNotEmpty) ...[
            const SizedBox(height: 15),

            Text(
              deskripsiQuiz,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    Colors.white.withOpacity(.82),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${currentIndex + 1} dari ${daftarSoal.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),

              Text(
                '${(progressQuiz * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressQuiz,
              minHeight: 9,
              backgroundColor:
                  Colors.white.withOpacity(.18),
              valueColor:
                  const AlwaysStoppedAnimation(
                Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION INDICATOR
  // ============================================================

  Widget _buildQuestionIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.grid_view_rounded,
                color: primaryColor,
                size: 20,
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'Nomor Soal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),

              Text(
                '$jumlahSudahDijawab/${daftarSoal.length} dijawab',
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              daftarSoal.length,
              (index) {
                final bool aktif =
                    index == currentIndex;

                final bool sudahDijawab =
                    jawabanSiswa[index] !=
                        null;

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(10),
                  onTap: menyimpan
                      ? null
                      : () {
                          setState(() {
                            currentIndex =
                                index;
                          });
                        },
                  child: AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 200,
                    ),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: aktif
                          ? primaryColor
                          : sudahDijawab
                              ? Colors.green
                                  .withOpacity(.12)
                              : const Color(
                                  0xFFF3F4F6,
                                ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      border: Border.all(
                        color: aktif
                            ? primaryColor
                            : sudahDijawab
                                ? Colors.green
                                : const Color(
                                    0xFFE5E7EB,
                                  ),
                        width: aktif ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: aktif
                              ? Colors.white
                              : sudahDijawab
                                  ? Colors.green
                                  : const Color(
                                      0xFF6B7280,
                                    ),
                          fontWeight:
                              FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                      primaryColor.withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: primaryColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Pertanyaan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      primaryColor.withOpacity(.08),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  '${currentIndex + 1}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            soalAktif.pertanyaan,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER SECTION
  // ============================================================

  Widget _buildAnswerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.fromLTRB(6, 2, 6, 12),
            child: Text(
              'Pilih Jawaban',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
          ),

          _buildAnswerOption(
            value: 'A',
            text: soalAktif.pilihanA,
          ),

          const SizedBox(height: 10),

          _buildAnswerOption(
            value: 'B',
            text: soalAktif.pilihanB,
          ),

          const SizedBox(height: 10),

          _buildAnswerOption(
            value: 'C',
            text: soalAktif.pilihanC,
          ),

          const SizedBox(height: 10),

          _buildAnswerOption(
            value: 'D',
            text: soalAktif.pilihanD,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER OPTION
  // ============================================================

  Widget _buildAnswerOption({
    required String value,
    required String text,
  }) {
    final bool selected =
        jawabanSiswa[currentIndex] ==
            value;

    return InkWell(
      onTap: menyimpan
          ? null
          : () => pilihJawaban(value),
      borderRadius:
          BorderRadius.circular(16),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withOpacity(.08)
              : const Color(0xFFF9FAFB),
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? primaryColor
                : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? primaryColor
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? primaryColor
                      : const Color(
                          0xFFD1D5DB,
                        ),
                ),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(
                            0xFF4B5563,
                          ),
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: selected
                      ? const Color(
                          0xFF312E81,
                        )
                      : const Color(
                          0xFF374151,
                        ),
                  fontSize: 14,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  height: 1.45,
                ),
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              color: selected
                  ? primaryColor
                  : Colors.grey.shade400,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed:
                  currentIndex == 0 ||
                          menyimpan
                      ? null
                      : previousSoal,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 19,
              ),
              label: const Text(
                'Sebelumnya',
              ),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    primaryColor,
                minimumSize:
                    const Size(0, 52),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton.icon(
              onPressed: menyimpan
                  ? null
                  : soalTerakhir
                      ? selesaiQuiz
                      : nextSoal,
              icon: menyimpan
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      soalTerakhir
                          ? Icons
                              .check_circle_rounded
                          : Icons
                              .arrow_forward_rounded,
                      size: 19,
                    ),
              label: Text(
                menyimpan
                    ? 'Menyimpan...'
                    : soalTerakhir
                        ? 'Selesai'
                        : 'Berikutnya',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    soalTerakhir
                        ? Colors.green
                        : primaryColor,
                foregroundColor:
                    Colors.white,
                minimumSize:
                    const Size(0, 52),
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONFIRMASI KELUAR
  // ============================================================

  Future<void> _konfirmasiKeluar() async {
    if (menyimpan) return;

    final bool? keluar =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.exit_to_app_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Keluar dari Quiz?',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Progress jawaban yang sedang dikerjakan '
            'mungkin tidak tersimpan. Apakah kamu yakin ingin keluar?',
            style: TextStyle(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Tetap di Quiz',
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Keluar',
              ),
            ),
          ],
        );
      },
    );

    if (keluar == true && mounted) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    super.dispose();
  }
}