import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // BOBOT NILAI
  // ============================================================

  static const double quizWeight = 0.60;
  static const double latihanWeight = 0.40;

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refresh() async {
    setState(() {});
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),

        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Ranking Siswa',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Gabungan nilai Quiz & Latihan',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: RefreshIndicator(
        color: const Color(0xFF6366F1),
        onRefresh: _refresh,

        child: StreamBuilder<
            QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('nilai')
              .snapshots(),

          builder: (
            context,
            quizSnapshot,
          ) {
            // ====================================================
            // LOADING QUIZ
            // ====================================================

            if (quizSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              );
            }

            // ====================================================
            // ERROR QUIZ
            // ====================================================

            if (quizSnapshot.hasError) {
              return _buildError(
                'Gagal memuat nilai Quiz',
                quizSnapshot.error.toString(),
              );
            }

            // ====================================================
            // STREAM LATIHAN
            // ====================================================

            return StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore
                  .collection('hasil_latihan')
                  .snapshots(),

              builder: (
                context,
                latihanSnapshot,
              ) {
                // ==================================================
                // LOADING LATIHAN
                // ==================================================

                if (latihanSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6366F1),
                    ),
                  );
                }

                // ==================================================
                // ERROR LATIHAN
                // ==================================================

                if (latihanSnapshot.hasError) {
                  return _buildError(
                    'Gagal memuat nilai Latihan',
                    latihanSnapshot.error.toString(),
                  );
                }

                // ==================================================
                // AMBIL DATA
                // ==================================================

                final quizDocs =
                    quizSnapshot.data?.docs ?? [];

                final latihanDocs =
                    latihanSnapshot.data?.docs ?? [];

                // ==================================================
                // PROSES RANKING
                // ==================================================

                final ranking =
                    _calculateRanking(
                  quizDocs,
                  latihanDocs,
                );

                // ==================================================
                // BELUM ADA DATA
                // ==================================================

                if (ranking.isEmpty) {
                  return _buildEmpty();
                }

                // ==================================================
                // TAMPILKAN
                // ==================================================

                return ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),

                  padding:
                      const EdgeInsets.fromLTRB(
                    16,
                    18,
                    16,
                    30,
                  ),

                  children: [
                    // =================================================
                    // SUMMARY
                    // =================================================

                    _buildSummaryCard(
                      ranking.length,
                    ),

                    const SizedBox(height: 22),

                    // =================================================
                    // KETERANGAN BOBOT
                    // =================================================

                    _buildWeightCard(),

                    const SizedBox(height: 24),

                    // =================================================
                    // HEADER RANKING
                    // =================================================

                    _buildSectionHeader(),

                    const SizedBox(height: 12),

                    // =================================================
                    // TOP 3
                    // =================================================

                    if (ranking.length >= 3)
                      _buildTopThree(
                        ranking,
                      ),

                    if (ranking.length >= 3)
                      const SizedBox(height: 20),

                    // =================================================
                    // LIST RANKING
                    // =================================================

                    ...List.generate(
                      ranking.length,
                      (index) {
                        final item =
                            ranking[index];

                        return _RankingCard(
                          rank: index + 1,
                          data: item,
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // =================================================
                    // INFO
                    // =================================================

                    _buildInfoCard(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HITUNG RANKING
  // ============================================================

  List<_StudentRanking> _calculateRanking(
    List<QueryDocumentSnapshot<
            Map<String, dynamic>>>
        quizDocs,

    List<QueryDocumentSnapshot<
            Map<String, dynamic>>>
        latihanDocs,
  ) {
    final Map<String, _StudentScore> students =
        {};

    // ==========================================================
    // PROSES QUIZ
    // ==========================================================

    for (final doc in quizDocs) {
      final data = doc.data();

      final uid =
          data['uid']?.toString().trim() ?? '';

      if (uid.isEmpty) {
        continue;
      }

      final nama =
          data['nama']?.toString().trim();

      final foto =
          data['foto']?.toString().trim();

      final kelas =
          data['kelas']?.toString().trim();

      final nilai =
          _parseNilai(data['nilai']);

      if (!students.containsKey(uid)) {
        students[uid] = _StudentScore(
          uid: uid,
          nama: nama?.isNotEmpty == true
              ? nama!
              : 'Siswa',
          foto: foto ?? '',
          kelas: kelas ?? '',
        );
      }

      final student = students[uid]!;

      student.quizScores.add(nilai);

      if (nama != null &&
          nama.isNotEmpty) {
        student.nama = nama;
      }

      if (foto != null &&
          foto.isNotEmpty) {
        student.foto = foto;
      }

      if (kelas != null &&
          kelas.isNotEmpty) {
        student.kelas = kelas;
      }
    }

    // ==========================================================
    // PROSES LATIHAN
    // ==========================================================

    for (final doc in latihanDocs) {
      final data = doc.data();

      final uid =
          data['userId']?.toString().trim() ?? '';

      if (uid.isEmpty) {
        continue;
      }

      final nilai =
          _parseNilai(data['nilai']);

      // --------------------------------------------------------
      // Jika siswa hanya punya hasil latihan
      // tetap kita masukkan ke data.
      // --------------------------------------------------------

      if (!students.containsKey(uid)) {
        students[uid] = _StudentScore(
          uid: uid,
          nama: 'Siswa',
          foto: '',
          kelas: '',
        );
      }

      students[uid]!
          .latihanScores
          .add(nilai);
    }

    // ==========================================================
    // HITUNG NILAI AKHIR
    // ==========================================================

    final List<_StudentRanking> result = [];

    for (final student in students.values) {
      // --------------------------------------------------------
      // Agar ranking benar-benar merupakan gabungan,
      // siswa harus memiliki Quiz DAN Latihan.
      // --------------------------------------------------------

      if (student.quizScores.isEmpty ||
          student.latihanScores.isEmpty) {
        continue;
      }

      final rataQuiz =
          _average(student.quizScores);

      final rataLatihan =
          _average(student.latihanScores);

      final nilaiAkhir =
          (rataQuiz * quizWeight) +
              (rataLatihan * latihanWeight);

      result.add(
        _StudentRanking(
          uid: student.uid,
          nama: student.nama,
          foto: student.foto,
          kelas: student.kelas,
          rataQuiz: rataQuiz,
          rataLatihan: rataLatihan,
          nilaiAkhir: nilaiAkhir,
          jumlahQuiz:
              student.quizScores.length,
          jumlahLatihan:
              student.latihanScores.length,
        ),
      );
    }

    // ==========================================================
    // SORT NILAI AKHIR
    // ==========================================================

    result.sort(
      (a, b) => b.nilaiAkhir.compareTo(
        a.nilaiAkhir,
      ),
    );

    return result;
  }

  // ============================================================
  // AVERAGE
  // ============================================================

  double _average(
    List<double> values,
  ) {
    if (values.isEmpty) {
      return 0;
    }

    final total =
        values.reduce(
      (a, b) => a + b,
    );

    return total / values.length;
  }

  // ============================================================
  // PARSE NILAI
  // ============================================================

  double _parseNilai(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '0',
        ) ??
        0;
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _buildSummaryCard(
    int jumlahSiswa,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1)
                .withValues(alpha: .20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: .15,
              ),
              borderRadius:
                  BorderRadius.circular(17),
            ),

            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Ranking Performa Siswa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$jumlahSiswa siswa memiliki '
                  'nilai lengkap',
                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: .78),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOBOT CARD
  // ============================================================

  Widget _buildWeightCard() {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              const Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(
                Icons.calculate_rounded,
                color: Color(0xFF6366F1),
                size: 19,
              ),

              SizedBox(width: 8),

              Text(
                'Perhitungan Nilai',
                style: TextStyle(
                  color: Color(0xFF172033),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildWeightItem(
                  icon: Icons.quiz_rounded,
                  title: 'Quiz',
                  value: '60%',
                  color:
                      const Color(0xFF10B981),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildWeightItem(
                  icon:
                      Icons.assignment_rounded,
                  title: 'Latihan',
                  value: '40%',
                  color:
                      const Color(0xFF6366F1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            'Nilai akhir = (Rata-rata Quiz × 60%) '
            '+ (Rata-rata Latihan × 40%)',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WEIGHT ITEM
  // ============================================================

  Widget _buildWeightItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(11),

      decoration: BoxDecoration(
        color:
            color.withValues(alpha: .07),
        borderRadius:
            BorderRadius.circular(13),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 19,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader() {
    return const Row(
      children: [
        Icon(
          Icons.leaderboard_rounded,
          color: Color(0xFFF59E0B),
          size: 22,
        ),

        SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                'Peringkat Siswa',
                style: TextStyle(
                  color: Color(0xFF172033),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Urutan berdasarkan nilai akhir',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TOP THREE
  // ============================================================

  Widget _buildTopThree(
    List<_StudentRanking> ranking,
  ) {
    final first = ranking[0];
    final second = ranking[1];
    final third = ranking[2];

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,

      children: [
        Expanded(
          child: _buildPodium(
            rank: 2,
            data: second,
            height: 145,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildPodium(
            rank: 1,
            data: first,
            height: 175,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildPodium(
            rank: 3,
            data: third,
            height: 130,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PODIUM
  // ============================================================

  Widget _buildPodium({
    required int rank,
    required _StudentRanking data,
    required double height,
  }) {
    final Color color;

    if (rank == 1) {
      color = const Color(0xFFF59E0B);
    } else if (rank == 2) {
      color = const Color(0xFF64748B);
    } else {
      color = const Color(0xFFB45309);
    }

    return Container(
      height: height,

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              color.withValues(alpha: .15),
        ),

        boxShadow: [
          BoxShadow(
            color:
                color.withValues(alpha: .07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Container(
            width: 43,
            height: 43,

            decoration: BoxDecoration(
              color:
                  color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),

            child: Icon(
              rank == 1
                  ? Icons.workspace_premium_rounded
                  : Icons.emoji_events_rounded,
              color: color,
              size: 23,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            data.nama,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),

          if (data.kelas.isNotEmpty) ...[
            const SizedBox(height: 2),

            Text(
              data.kelas,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 8,
              ),
            ),
          ],

          const SizedBox(height: 7),

          Text(
            _formatNilai(
              data.nilaiAkhir,
            ),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          Text(
            'Peringkat $rank',
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color:
              const Color(0xFFE5E7EB),
        ),
      ),

      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF6366F1),
            size: 19,
          ),

          SizedBox(width: 9),

          Expanded(
            child: Text(
              'Ranking dihitung dari rata-rata seluruh '
              'nilai Quiz dan Latihan siswa. Siswa '
              'harus memiliki hasil Quiz dan Latihan '
              'agar dapat masuk ke ranking.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),

      children: const [
        SizedBox(height: 150),

        Center(
          child: Icon(
            Icons.emoji_events_outlined,
            size: 75,
            color: Color(0xFFCBD5E1),
          ),
        ),

        SizedBox(height: 18),

        Center(
          child: Text(
            'Belum ada ranking',
            style: TextStyle(
              color: Color(0xFF172033),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        SizedBox(height: 7),

        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 35),

          child: Text(
            'Ranking akan muncul setelah siswa '
            'memiliki nilai Quiz dan Latihan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(
    String title,
    String error,
  ) {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),

      children: [
        const SizedBox(height: 140),

        const Center(
          child: Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 60,
          ),
        ),

        const SizedBox(height: 15),

        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 30,
          ),

          child: Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label:
                const Text('Coba Lagi'),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// STUDENT SCORE
// ================================================================

class _StudentScore {
  final String uid;

  String nama;
  String foto;
  String kelas;

  final List<double> quizScores = [];
  final List<double> latihanScores = [];

  _StudentScore({
    required this.uid,
    required this.nama,
    required this.foto,
    required this.kelas,
  });
}

// ================================================================
// STUDENT RANKING
// ================================================================

class _StudentRanking {
  final String uid;
  final String nama;
  final String foto;
  final String kelas;

  final double rataQuiz;
  final double rataLatihan;
  final double nilaiAkhir;

  final int jumlahQuiz;
  final int jumlahLatihan;

  _StudentRanking({
    required this.uid,
    required this.nama,
    required this.foto,
    required this.kelas,
    required this.rataQuiz,
    required this.rataLatihan,
    required this.nilaiAkhir,
    required this.jumlahQuiz,
    required this.jumlahLatihan,
  });
}

// ================================================================
// RANKING CARD
// ================================================================

class _RankingCard extends StatelessWidget {
  final int rank;
  final _StudentRanking data;

  const _RankingCard({
    required this.rank,
    required this.data,
  });

  Color get rankColor {
    switch (rank) {
      case 1:
        return const Color(0xFFF59E0B);

      case 2:
        return const Color(0xFF64748B);

      case 3:
        return const Color(0xFFB45309);

      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 11),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              rankColor.withValues(alpha: .10),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: .025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              // ====================================================
              // RANK
              // ====================================================

              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: rankColor.withValues(
                    alpha: .10,
                  ),
                  shape: BoxShape.circle,
                ),

                child: Center(
                  child: rank <= 3
                      ? Icon(
                          rank == 1
                              ? Icons
                                  .workspace_premium_rounded
                              : Icons
                                  .emoji_events_rounded,
                          color: rankColor,
                          size: 23,
                        )
                      : Text(
                          '$rank',
                          style: TextStyle(
                            color: rankColor,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // ====================================================
              // NAMA
              // ====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      data.nama,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF172033),
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    if (data.kelas.isNotEmpty) ...[
                      const SizedBox(height: 3),

                      Text(
                        'Kelas ${data.kelas}',
                        style: const TextStyle(
                          color:
                              Color(0xFF94A3B8),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ====================================================
              // NILAI AKHIR
              // ====================================================

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,

                children: [
                  const Text(
                    'NILAI AKHIR',
                    style: TextStyle(
                      color:
                          Color(0xFF94A3B8),
                      fontSize: 7,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: .7,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    _formatNilai(
                      data.nilaiAkhir,
                    ),
                    style: TextStyle(
                      color: rankColor,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ========================================================
          // NILAI QUIZ & LATIHAN
          // ========================================================

          Row(
            children: [
              Expanded(
                child: _buildScoreItem(
                  icon: Icons.quiz_rounded,
                  title: 'Quiz',
                  value: data.rataQuiz,
                  color:
                      const Color(0xFF10B981),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _buildScoreItem(
                  icon:
                      Icons.assignment_rounded,
                  title: 'Latihan',
                  value: data.rataLatihan,
                  color:
                      const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCORE ITEM
  // ============================================================

  Widget _buildScoreItem({
    required IconData icon,
    required String title,
    required double value,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),

      decoration: BoxDecoration(
        color:
            color.withValues(alpha: .06),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Text(
            _formatNilai(value),
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// FORMAT NILAI
// ================================================================

String _formatNilai(
  double nilai,
) {
  return nilai % 1 == 0
      ? nilai.toInt().toString()
      : nilai.toStringAsFixed(1);
}