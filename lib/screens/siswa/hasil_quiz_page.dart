import 'package:flutter/material.dart';

import '../../services/nilai_service.dart';
import 'siswa_dashboard.dart';
import 'widgets/siswa_bottom_navigation.dart';

class HasilQuizPage extends StatefulWidget {
  final int nilai;
  final String judul;

  const HasilQuizPage({
    super.key,
    required this.nilai,
    required this.judul,
  });

  @override
  State<HasilQuizPage> createState() => _HasilQuizPageState();
}

class _HasilQuizPageState extends State<HasilQuizPage> {
  final NilaiService _nilaiService = NilaiService();

  bool _saving = true;
  bool _saved = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _simpanNilai();
  }

  // ============================================================
  // SIMPAN NILAI KE FIREBASE
  // ============================================================

  Future<void> _simpanNilai() async {
    try {
      await _nilaiService.simpanNilai(
        judulQuiz: widget.judul,
        nilai: widget.nilai,
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
        _saved = true;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
        _saved = false;
        _error = e.toString();
      });
    }
  }

  // ============================================================
  // WARNA HASIL
  // ============================================================

  Color get warna {
    if (widget.nilai >= 80) {
      return const Color(0xFF10B981);
    }

    if (widget.nilai >= 60) {
      return const Color(0xFFF59E0B);
    }

    return const Color(0xFFEF4444);
  }

  // ============================================================
  // KETERANGAN
  // ============================================================

  String get keterangan {
    if (widget.nilai >= 80) {
      return "Luar Biasa! 🎉";
    }

    if (widget.nilai >= 60) {
      return "Bagus! 👍";
    }

    return "Belajar Lagi 💪";
  }

  // ============================================================
  // SUBTITLE
  // ============================================================

  String get subtitle {
    if (widget.nilai >= 80) {
      return "Kamu berhasil memahami materi dengan sangat baik.";
    }

    if (widget.nilai >= 60) {
      return "Pemahaman kamu sudah cukup baik. Terus tingkatkan!";
    }

    return "Jangan menyerah. Pelajari kembali materi dan coba lagi.";
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData get icon {
    if (widget.nilai >= 80) {
      return Icons.emoji_events_rounded;
    }

    if (widget.nilai >= 60) {
      return Icons.thumb_up_alt_rounded;
    }

    return Icons.school_rounded;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1F2937),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Hasil Quiz",
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child: Column(
            children: [
              const SizedBox(height: 10),

              // ==================================================
              // ICON HASIL
              // ==================================================

              Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      warna.withOpacity(.15),
                      warna.withOpacity(.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),

                child: Container(
                  margin: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: warna.withOpacity(.12),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    icon,
                    color: warna,
                    size: 62,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // JUDUL QUIZ
              // ==================================================

              Text(
                widget.judul,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Quiz telah selesai",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // CARD NILAI
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      warna,
                      warna.withOpacity(.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: warna.withOpacity(.25),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    const Text(
                      "NILAI KAMU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${widget.nilai}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 68,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        keterangan,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // STATUS PENYIMPANAN
              // ==================================================

              _buildSaveStatus(),

              const SizedBox(height: 20),

              // ==================================================
              // PESAN
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 45,
                      height: 45,

                      decoration: BoxDecoration(
                        color: warna.withOpacity(.10),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Icon(
                        icon,
                        color: warna,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 13),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            keterangan,
                            style: TextStyle(
                              color: warna,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // TOMBOL DASHBOARD
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton.icon(
                  onPressed: _saving
                      ? null
                      : () {
                          _kembaliKeDashboard(context);
                        },

                  icon: const Icon(
                    Icons.dashboard_rounded,
                    size: 22,
                  ),

                  label: Text(
                    _saving
                        ? "Menyimpan Nilai..."
                        : "Kembali ke Dashboard",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: warna,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey.shade400,
                    disabledForegroundColor:
                        Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // TOMBOL KEMBALI
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                  ),

                  label: const Text(
                    "Kembali",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF6366F1),

                    side: const BorderSide(
                      color: Color(0xFF6366F1),
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 3,
      ),
);
  }

  // ============================================================
  // STATUS SIMPAN NILAI
  // ============================================================

  Widget _buildSaveStatus() {
    if (_saving) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFBFDBFE),
          ),
        ),

        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,

              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF3B82F6),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                "Menyimpan hasil quiz ke Firebase...",
                style: TextStyle(
                  color: Color(0xFF1D4ED8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_saved) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFA7F3D0),
          ),
        ),

        child: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 22,
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                "Hasil quiz berhasil disimpan. Nilai kamu masuk ke ranking.",
                style: TextStyle(
                  color: Color(0xFF047857),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFECACA),
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Nilai belum berhasil disimpan. $_error",
              style: const TextStyle(
                color: Color(0xFFB91C1C),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),

          IconButton(
            tooltip: "Coba lagi",
            onPressed: _simpanNilai,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KEMBALI KE DASHBOARD
  // ============================================================

  void _kembaliKeDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) => const SiswaDashboard(),
      ),

      (route) => false,
    );
  }
}