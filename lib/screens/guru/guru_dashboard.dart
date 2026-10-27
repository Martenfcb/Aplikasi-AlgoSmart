import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../theme/theme_controller.dart';
import '../../widgets/app_drawer.dart';

import 'kelola_latihan_page.dart';
import 'kelola_cp_atp_page.dart';
import 'kelola_materi_page.dart';
import 'kelola_quiz_page.dart';
import 'kelola_video_page.dart';
import 'petunjuk_page.dart';
import 'ranking_page.dart';
import 'nilai_siswa_page.dart';
import 'hasil_latihan_page.dart';
import 'profil_guru_page.dart';

class GuruDashboard extends StatefulWidget {
  const GuruDashboard({super.key});

  @override
  State<GuruDashboard> createState() => _GuruDashboardState();
}

class _GuruDashboardState extends State<GuruDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _selectedIndex = 0;

  // ============================================================
  // INFORMASI AKUN GURU
  // ============================================================

  String _namaGuru = 'Guru';
  bool _loadingNamaGuru = true;

  // ============================================================
  // DATA PENGEMBANG
  // ============================================================

  static const String namaPembuat = 'Februari Risma';
  static const String npmPembuat = '2201100086';
  static const String instagramPembuat = 'Februari_Risma21';
  static const String emailPembuat = 'februaririsma@gmail.com';
  static const String noHpPembuat = '085169170802';
  static const String pendidikanPembuat = 'Informatika';
  static const String fakultasPembuat = 'Sains dan Teknologi';

  static const String pbb1 =
      'Heri Mulyono, M.Pd';

  static const String pbb2 =
      'Ami Anggraini Samudra, S.Pd., M.Si';

  // ============================================================
  // ASSET FOTO
  // ============================================================

  static const String fotoPengembang =
      'assets/images/pengembang.JPG';

  static const String fotoPbb1 =
      'assets/images/pbb1.JPG';

  static const String fotoPbb2 =
      'assets/images/pbb2.jpeg';

  // ============================================================
  // THEME
  // ============================================================

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor => isDark
      ? const Color(0xFF0B1020)
      : const Color(0xFFF6F7FB);

  Color get cardColor => isDark
      ? const Color(0xFF151B2C)
      : Colors.white;

  Color get textColor => isDark
      ? Colors.white
      : const Color(0xFF172033);

  Color get secondaryTextColor => isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF64748B);

  Color get primaryColor =>
      const Color(0xFF4F46E5);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();

    _loadNamaGuru();
  }

  // ============================================================
  // LOAD NAMA GURU DARI INFORMASI AKUN
  // ============================================================

  Future<void> _loadNamaGuru() async {
    try {
      final authUser = FirebaseAuth.instance.currentUser;

      if (authUser == null) {
        if (mounted) {
          setState(() {
            _namaGuru = 'Guru';
            _loadingNamaGuru = false;
          });
        }
        return;
      }

      String nama = '';

      // 1. Ambil nama dari Firestore users/{uid}.
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final namaFirestore =
            data?['nama']?.toString().trim() ?? '';

        if (namaFirestore.isNotEmpty) {
          nama = namaFirestore;
        }
      }

      // 2. Jika Firestore kosong, gunakan displayName Firebase Auth.
      if (nama.isEmpty) {
        final displayName =
            authUser.displayName?.trim() ?? '';

        if (displayName.isNotEmpty) {
          nama = displayName;
        }
      }

      // 3. Jika masih kosong, gunakan username dari email.
      if (nama.isEmpty) {
        final email = authUser.email?.trim() ?? '';

        if (email.isNotEmpty && email.contains('@')) {
          final username = email.split('@').first.trim();

          if (username.isNotEmpty) {
            final cleaned = username
                .replaceAll(RegExp(r'[._-]+'), ' ')
                .trim();

            if (cleaned.isNotEmpty) {
              nama = cleaned
                  .split(RegExp(r'\s+'))
                  .map(
                    (word) => word.isEmpty
                        ? word
                        : '${word[0].toUpperCase()}'
                          '${word.substring(1).toLowerCase()}',
                  )
                  .join(' ');
            }
          }
        }
      }

      if (nama.isEmpty) {
        nama = 'Guru';
      }

      if (!mounted) return;

      setState(() {
        _namaGuru = nama;
        _loadingNamaGuru = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _namaGuru = 'Guru';
        _loadingNamaGuru = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const AppDrawer(),

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildCurrentPage(),
        ),
      ),

      bottomNavigationBar:
          _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // CURRENT PAGE
  // ============================================================

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 1:
        return _buildLearningPage();

      case 2:
        return _buildAssessmentPage();

      case 3:
        return _buildProfilePage();

      default:
        return _buildHomePage();
    }
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHomePage() {
    return RefreshIndicator(
      color: primaryColor,
      backgroundColor: cardColor,
      onRefresh: () async {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (mounted) {
          setState(() {});
        }
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                100,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),

                  const SizedBox(height: 18),

                  _buildWelcomeCard(),

                  const SizedBox(height: 28),

                  _buildSectionTitle(
                    'Fitur Pembelajaran',
                    'Kelola pembelajaran untuk siswa',
                    Icons.auto_stories_rounded,
                  ),

                  const SizedBox(height: 14),

                  _buildLearningGrid(),

                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    'Siswa & Penilaian',
                    'Pantau perkembangan belajar siswa',
                    Icons.groups_rounded,
                  ),

                  const SizedBox(height: 14),

                  _buildStudentGrid(),

                  const SizedBox(height: 25),

                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Row(
      children: [
        Builder(
          builder: (context) {
            return _circleButton(
              icon: Icons.menu_rounded,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'AlgoSmart',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Dashboard',
                style: TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        _circleButton(
          icon: isDark
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          onTap: _toggleTheme,
        ),

        const SizedBox(width: 8),

        _circleButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {
            _showMessage(
              'Belum ada notifikasi baru',
              Icons.notifications_none_rounded,
            );
          },
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: .06)
                  : const Color(0xFFE7EAF0),
            ),
          ),
          child: Icon(
            icon,
            color: textColor,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // WELCOME CARD
  // ============================================================

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5)
                .withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -30,
            top: -45,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withValues(alpha: .08),
              ),
            ),
          ),

          Positioned(
            right: 55,
            bottom: -70,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withValues(alpha: .06),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: .16),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        _loadingNamaGuru
                            ? 'Halo, Guru! 👋'
                            : 'Halo, $_namaGuru! 👋',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Mari buat pembelajaran '
                        'menjadi lebih menarik.',
                        style: TextStyle(
                          color: Colors.white
                              .withValues(alpha: .82),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
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
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor
                .withValues(alpha: .10),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 21,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LEARNING GRID
  // ============================================================

  Widget _buildLearningGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 14,
      childAspectRatio: .78,
      children: [
        _featureCard(
          title: 'Materi',
          subtitle: 'Materi pembelajaran',
          icon: Icons.menu_book_rounded,
          color: const Color(0xFF3B82F6),
          imageUrl:
              'https://cdn-icons-png.flaticon.com/512/2232/2232688.png',
          page: const KelolaMateriPage(),
          buttonText: 'KELOLA',
        ),

        _featureCard(
          title: 'Video',
          subtitle: 'Video pembelajaran',
          icon: Icons.play_circle_fill_rounded,
          color: const Color(0xFFEF4444),
          imageUrl:
              'https://cdn-icons-png.flaticon.com/512/2991/2991108.png',
          page: const KelolaVideoPage(),
          buttonText: 'KELOLA',
        ),

        _featureCard(
          title: 'Quiz External',
          subtitle: 'Soal dan kuis siswa',
          icon: Icons.quiz_rounded,
          color: const Color(0xFF10B981),
          imageUrl:
              'https://cdn-icons-png.flaticon.com/512/3135/3135810.png',
          page: const KelolaQuizPage(),
          buttonText: 'KELOLA',
        ),

        _featureCard(
          title: 'Latihan',
          subtitle: 'Latihan soal siswa',
          icon: Icons.assignment_rounded,
          color: const Color(0xFF6366F1),
          imageUrl:
              'https://cdn-icons-png.flaticon.com/512/942/942748.png',
          page: const KelolaLatihanPage(),
          buttonText: 'KELOLA',
        ),

        _featureCard(
          title: 'CP & ATP',
          subtitle: 'Capaian pembelajaran',
          icon: Icons.account_tree_rounded,
          color: const Color(0xFF8B5CF6),
          imageUrl:
              'https://cdn-icons-png.flaticon.com/512/2997/2997206.png',
          page: const KelolaCPATPPage(),
          buttonText: 'KELOLA',
        ),

        _featureCard(
          title: 'Petunjuk',
          subtitle: 'Panduan aplikasi',
          icon: Icons.help_rounded,
          color: const Color(0xFF14B8A6),
          imageUrl:
              'https://cdn-icons-png.flaticon.com/512/471/471664.png',
          page: const PetunjukPage(),
          buttonText: 'BUKA',
        ),
      ],
    );
  }

  // ============================================================
  // STUDENT GRID
  // ============================================================

 Widget _buildStudentGrid() {
  return GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 14,
    childAspectRatio: .78,
    children: [
      _featureCard(
        title: 'Ranking',
        subtitle: 'Ranking & nilai siswa',
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFFF59E0B),
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/2583/2583344.png',
        page: const RankingPage(),
        buttonText: 'LIHAT',
      ),
    ],
  );
}

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _featureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String imageUrl,
    required Widget page,
    required String buttonText,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white
                      .withValues(alpha: .05)
                  : color
                      .withValues(alpha: .10),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: color
                      .withValues(alpha: .08),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(23),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ),

              // IMAGE
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -28,
                      right: -25,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration:
                            BoxDecoration(
                          shape: BoxShape.circle,
                          color: color
                              .withValues(
                            alpha: .08,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -30,
                      left: -25,
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration:
                            BoxDecoration(
                          shape: BoxShape.circle,
                          color: color
                              .withValues(
                            alpha: .06,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.all(12),
                      child: Image.network(
                        imageUrl,
                        width: 78,
                        height: 78,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, __, ___) {
                          return Container(
                            width: 78,
                            height: 78,
                            decoration:
                                BoxDecoration(
                              color: color
                                  .withValues(
                                alpha: .12,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(22),
                            ),
                            child: Icon(
                              icon,
                              color: color,
                              size: 42,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // BOTTOM
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  12,
                  2,
                  12,
                  13,
                ),
                child: Column(
                  children: [
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 9.5,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Container(
                      height: 34,
                      width: 92,
                      decoration:
                          BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color
                                .withValues(
                              alpha: .20,
                            ),
                            blurRadius: 7,
                            offset:
                                const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            buttonText,
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w900,
                              letterSpacing: .3,
                            ),
                          ),

                          const SizedBox(width: 4),

                          const Icon(
                            Icons
                                .arrow_forward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEARNING PAGE
  // ============================================================

  Widget _buildLearningPage() {
    return _secondaryPage(
      title: 'Pembelajaran',
      subtitle: 'Kelola konten pembelajaran',
      icon: Icons.auto_stories_rounded,
      children: [
        _largeAction(
          title: 'Materi',
          subtitle:
              'Kelola materi pembelajaran',
          icon: Icons.menu_book_rounded,
          color: const Color(0xFF3B82F6),
          page: const KelolaMateriPage(),
        ),

        _largeAction(
          title: 'Video',
          subtitle:
              'Kelola video pembelajaran',
          icon:
              Icons.video_library_rounded,
          color: const Color(0xFFEF4444),
          page: const KelolaVideoPage(),
        ),

        _largeAction(
          title: 'Quiz',
          subtitle:
              'Buat dan kelola quiz',
          icon: Icons.quiz_rounded,
          color: const Color(0xFF10B981),
          page: const KelolaQuizPage(),
        ),

        _largeAction(
          title: 'Latihan',
          subtitle:
              'Buat latihan siswa',
          icon: Icons.assignment_rounded,
          color: const Color(0xFF6366F1),
          page: const KelolaLatihanPage(),
        ),

        _largeAction(
          title: 'CP & ATP',
          subtitle:
              'Kelola capaian pembelajaran',
          icon:
              Icons.account_tree_rounded,
          color: const Color(0xFF8B5CF6),
          page: const KelolaCPATPPage(),
        ),

        _largeAction(
          title: 'Petunjuk',
          subtitle:
              'Panduan penggunaan aplikasi',
          icon: Icons.help_outline_rounded,
          color: const Color(0xFF14B8A6),
          page: const PetunjukPage(),
        ),
      ],
    );
  }

  // ============================================================
  // ASSESSMENT PAGE
  // ============================================================

  Widget _buildAssessmentPage() {
    return _secondaryPage(
      title: 'Penilaian',
      subtitle:
          'Pantau perkembangan siswa',
      icon: Icons.assessment_rounded,
      children: [
        _largeAction(
          title: 'Nilai Siswa',
          subtitle:
              'Lihat hasil belajar siswa',
          icon: Icons.assessment_rounded,
          color: const Color(0xFF06B6D4),
          page: const NilaiSiswaPage(),
        ),

        _largeAction(
          title: 'Ranking',
          subtitle:
              'Lihat peringkat siswa',
          icon:
              Icons.emoji_events_rounded,
          color: const Color(0xFFF59E0B),
          page: const RankingPage(),
        ),

        _largeAction(
          title: 'Hasil Latihan',
          subtitle:
              'Lihat pengerjaan siswa',
          icon:
              Icons.assignment_turned_in_rounded,
          color: const Color(0xFF22C55E),
          page: const HasilLatihanPage(),
        ),
      ],
    );
  }

  // ============================================================
  // SECONDARY PAGE
  // ============================================================

  Widget _secondaryPage({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: backgroundColor,
          surfaceTintColor:
              Colors.transparent,
          elevation: 0,
          pinned: true,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor
                      .withValues(alpha: .10),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            100,
          ),
          sliver: SliverList(
            delegate:
                SliverChildListDelegate(
              children,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LARGE ACTION
  // ============================================================

  Widget _largeAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white
                  .withValues(alpha: .05)
              : color.withValues(alpha: .10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => page,
              ),
            );
          },
          borderRadius:
              BorderRadius.circular(20),
          child: Padding(
            padding:
                const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration:
                      BoxDecoration(
                    gradient:
                        LinearGradient(
                      colors: [
                        color,
                        color.withValues(
                          alpha: .70,
                        ),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: TextStyle(
                          color:
                              secondaryTextColor,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color:
                      secondaryTextColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE PAGE
  // ============================================================

  Widget _buildProfilePage() {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: backgroundColor,
          surfaceTintColor:
              Colors.transparent,
          elevation: 0,
          pinned: true,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor
                      .withValues(alpha: .10),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: primaryColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Profil',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            100,
          ),
          sliver: SliverList(
            delegate:
                SliverChildListDelegate([
              _buildGuruProfileCard(),

              const SizedBox(height: 18),

              _buildAboutAppCard(),

              const SizedBox(height: 18),

              _buildDeveloperCard(),

              const SizedBox(height: 18),

              _buildSecurityCard(),

              const SizedBox(height: 25),

              _buildProfileFooter(),
            ]),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GURU PROFILE CARD
  // ============================================================

  Widget _buildGuruProfileCard() {
    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(25),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ProfilGuruPage(),
            ),
          );
        },
        borderRadius:
            BorderRadius.circular(25),
        child: Ink(
          width: double.infinity,
          padding:
              const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(
              colors: [
                Color(0xFF4F46E5),
                Color(0xFF7C3AED),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: primaryColor
                    .withValues(alpha: .22),
                blurRadius: 20,
                offset:
                    const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: .15),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Guru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Lihat dan ubah informasi profil guru',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: .13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT APP
  // ============================================================

  Widget _buildAboutAppCard() {
    return _profileCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _profileSectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi',
            subtitle:
                'Mengenal SQLearning',
            color: const Color(0xFF06B6D4),
          ),

          const SizedBox(height: 17),

          Text(
            'SQLearning merupakan media pembelajaran '
            'interaktif berbasis Android yang membantu '
            'siswa mempelajari Algoritma dan Pemrograman '
            'dengan cara yang lebih mudah, menarik, '
            'dan interaktif.',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED)
                  .withValues(
                alpha: isDark ? .09 : .055,
              ),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFF7C3AED),
                  size: 21,
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    'Belajar lebih mudah melalui materi, '
                    'video, quiz, dan latihan algoritma.',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFC4B5FD)
                          : const Color(
                              0xFF5B21B6,
                            ),
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                      height: 1.4,
                    ),
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
  // DEVELOPER CARD
  // ============================================================

  Widget _buildDeveloperCard() {
    return _profileCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _profileSectionHeader(
            icon:
                Icons.developer_mode_rounded,
            title: 'Profil Pengembang',
            subtitle:
                'Pembuat media pembelajaran SQLearning',
            color: primaryColor,
          ),

          const SizedBox(height: 22),

          // FOTO PENGEMBANG
          Center(
            child: Container(
              width: 115,
              height: 115,
              padding:
                  const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF8B5CF6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor
                        .withValues(
                      alpha: .20,
                    ),
                    blurRadius: 18,
                    offset:
                        const Offset(0, 7),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  fotoPengembang,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) {
                    return Container(
                      color:
                          const Color(0xFFEDE9FE),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 58,
                        color:
                            Color(0xFF4F46E5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 13),

          const Center(
            child: Text(
              namaPembuat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFEDE9FE),
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: const Text(
                'Pembuat Media Pembelajaran',
                style: TextStyle(
                  color: Color(0xFF6D28D9),
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          _developerInfo(
            icon: Icons.person_rounded,
            title: 'Nama',
            value: namaPembuat,
          ),

          _developerInfo(
            icon: Icons.badge_rounded,
            title: 'NPM',
            value: npmPembuat,
          ),

          _developerInfo(
            icon: Icons.school_rounded,
            title: 'Pendidikan',
            value: pendidikanPembuat,
          ),

          _developerInfo(
            icon:
                Icons.account_balance_rounded,
            title: 'Fakultas',
            value: fakultasPembuat,
          ),

          _developerInfo(
            icon: Icons.camera_alt_rounded,
            title: 'Instagram',
            value: instagramPembuat,
          ),

          _developerInfo(
            icon: Icons.email_rounded,
            title: 'Email',
            value: emailPembuat,
          ),

          _developerInfo(
            icon: Icons.phone_rounded,
            title: 'Kontak',
            value: noHpPembuat,
          ),

          const SizedBox(height: 12),

          Text(
            'Dosen Pembimbing',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Dosen pembimbing media pembelajaran',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 14),

          // PBB 1 & PBB 2
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _pbbCard(
                  label: 'PBB 1',
                  name: pbb1,
                  photo: fotoPbb1,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _pbbCard(
                  label: 'PBB 2',
                  name: pbb2,
                  photo: fotoPbb2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DEVELOPER INFO
  // ============================================================

  Widget _developerInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 9),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white
                .withValues(alpha: .035)
            : const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white
                  .withValues(alpha: .05)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor
                  .withValues(alpha: .10),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        secondaryTextColor,
                    fontSize: 9.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  softWrap: true,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w700,
                    height: 1.3,
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
  // PBB CARD
  // ============================================================

  Widget _pbbCard({
    required String label,
    required String name,
    required String photo,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white
                .withValues(alpha: .035)
            : const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color: isDark
              ? Colors.white
                  .withValues(alpha: .05)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            padding:
                const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                photo,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) {
                  return Container(
                    color:
                        const Color(0xFFEDE9FE),
                    child: const Icon(
                      Icons.person_rounded,
                      color:
                          Color(0xFF6D28D9),
                      size: 34,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 9),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius:
                  BorderRadius.circular(7),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight:
                  FontWeight.w800,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _buildSecurityCard() {
    return _profileCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _profileSectionHeader(
            icon: Icons.security_rounded,
            title: 'Keamanan',
            subtitle:
                'Kelola keamanan akun guru',
            color: const Color(0xFFEF4444),
          ),

          const SizedBox(height: 15),

          _profileAction(
            icon:
                Icons.person_outline_rounded,
            title: 'Profil Guru',
            subtitle:
                'Lihat dan edit informasi profil',
            color: primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ProfilGuruPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 9),

          _profileAction(
            icon:
                Icons.lock_reset_rounded,
            title: 'Ubah Kata Sandi',
            subtitle:
                'Kelola kata sandi akun',
            color: const Color(0xFFEF4444),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ProfilGuruPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 9),

          _profileAction(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle:
                'Keluar dari akun guru',
            color: const Color(0xFFDC2626),
            onTap: _showLogoutMessage,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color: isDark
              ? Colors.white
                  .withValues(alpha: .05)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? .10 : .035,
            ),
            blurRadius: 18,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // PROFILE SECTION HEADER
  // ============================================================

  Widget _profileSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                color,
                color.withValues(alpha: .70),
              ],
            ),
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE ACTION
  // ============================================================

  Widget _profileAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(15),
        child: Ink(
          padding:
              const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: color.withValues(
              alpha: isDark ? .07 : .045,
            ),
            borderRadius:
                BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      color,
                      color.withValues(
                        alpha: .70,
                      ),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: secondaryTextColor,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE FOOTER
  // ============================================================

  Widget _buildProfileFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            'SQLearning',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Media Pembelajaran '
            'Algoritma & Pemrograman',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 9,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '© ${DateTime.now().year} SQLearning',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

Widget _buildBottomNavigationBar() {
  final safeIndex =
      (_selectedIndex >= 0 && _selectedIndex < 4)
          ? _selectedIndex
          : 0;

  return NavigationBar(
    selectedIndex: safeIndex,

    onDestinationSelected: (index) {
      if (index < 0 || index >= 4) {
        return;
      }

      setState(() {
        _selectedIndex = index;
      });
    },

    backgroundColor: cardColor,
    surfaceTintColor: Colors.transparent,
    indicatorColor: primaryColor.withValues(
      alpha: .12,
    ),
    elevation: 8,
    height: 70,

    labelBehavior:
        NavigationDestinationLabelBehavior.alwaysShow,

    destinations: const [
      NavigationDestination(
        icon: Icon(
          Icons.home_outlined,
        ),
        selectedIcon: Icon(
          Icons.home_rounded,
        ),
        label: 'Beranda',
      ),

      NavigationDestination(
        icon: Icon(
          Icons.menu_book_outlined,
        ),
        selectedIcon: Icon(
          Icons.menu_book_rounded,
        ),
        label: 'Belajar',
      ),

      NavigationDestination(
        icon: Icon(
          Icons.assessment_outlined,
        ),
        selectedIcon: Icon(
          Icons.assessment_rounded,
        ),
        label: 'Penilaian',
      ),

      NavigationDestination(
        icon: Icon(
          Icons.person_outline_rounded,
        ),
        selectedIcon: Icon(
          Icons.person_rounded,
        ),
        label: 'Profil',
      ),
    ],
  );
}

  // ============================================================
  // FOOTER HOME
  // ============================================================

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            'AlgoSmart',
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Media Pembelajaran Interaktif',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // THEME
  // ============================================================

  void _toggleTheme() {
    ThemeController.toggle();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(12),
          duration:
              const Duration(
            milliseconds: 1200,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              Icon(
                ThemeController.isDark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                color: Colors.white,
                size: 20,
              ),

              const SizedBox(width: 9),

              Text(
                ThemeController.isDark
                    ? 'Mode gelap aktif'
                    : 'Mode terang aktif',
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutMessage() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),

              const SizedBox(width: 10),

              Text(
                'Logout',
                style: TextStyle(
                  color: textColor,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Text(
            'Untuk keluar dari akun, gunakan '
            'menu logout pada halaman profil guru.',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Mengerti'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ProfilGuruPage(),
                  ),
                );
              },
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    primaryColor,
              ),
              child:
                  const Text('Buka Profil'),
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
    String message,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(12),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(message),
              ),
            ],
          ),
        ),
      );
  }
}