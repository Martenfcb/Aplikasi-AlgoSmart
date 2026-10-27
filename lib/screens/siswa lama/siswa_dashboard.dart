import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/dashboard_service.dart';

import 'flowchart_page.dart';
import 'latihan_page.dart';
import 'materi_page.dart';
import 'profile_page.dart';
import 'quiz_page.dart';
import 'ranking_page.dart';
import 'simulasi_page.dart';
import 'video_page.dart';
import 'widgets/siswa_bottom_navigation.dart';

class SiswaDashboard extends StatefulWidget {
  const SiswaDashboard({super.key});

  @override
  State<SiswaDashboard> createState() => _SiswaDashboardState();
}

class _SiswaDashboardState extends State<SiswaDashboard>
    with TickerProviderStateMixin {
  final DashboardService dashboard = DashboardService();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  late final AnimationController _pageController;
  late final Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;
  bool _isDarkMode = false;

  // ============================================================
  // COLORS
  // ============================================================

  Color get primaryColor => const Color(0xFF6366F1);

  Color get backgroundColor => _isDarkMode
      ? const Color(0xFF0B1120)
      : const Color(0xFFF5F7FB);

  Color get cardColor =>
      _isDarkMode ? const Color(0xFF172033) : Colors.white;

  Color get textColor =>
      _isDarkMode ? Colors.white : const Color(0xFF172033);

  Color get secondaryTextColor =>
      _isDarkMode ? Colors.white60 : const Color(0xFF64748B);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeOutCubic,
    );

    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildCurrentPage(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentPage() {
    // Dashboard adalah halaman Beranda.
    // Halaman Materi, Video, Quiz, dan Profil dibuka
    // melalui reusable SiswaBottomNavigation.
    return _buildHomePage();
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHomePage() {
    return RefreshIndicator(
      color: primaryColor,
      backgroundColor: cardColor,
      onRefresh: () async {
        setState(() {});
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 17),
                  _buildSearch(),
                  const SizedBox(height: 15),
                  _buildQuickActions(),
                  const SizedBox(height: 21),
                  _buildProgressCard(),
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                    'Menu Pembelajaran',
                    'Pilih aktivitas belajar kamu',
                    Icons.auto_awesome_rounded,
                    const Color(0xFFEC4899),
                  ),
                  const SizedBox(height: 13),
                  _buildLearningGrid(),
                  const SizedBox(height: 25),
                  _buildMotivationCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    final user = currentUser;

    final name = _getAccountName(user);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF312E81),
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFDB2777),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: .25),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -45,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -35,
            bottom: -50,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(user?.photoURL),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _headerButton(
                    icon: _isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    onTap: _toggleTheme,
                  ),
                ],
              ),
              const SizedBox(height: 21),
              const Text(
                'Selamat belajar! 🚀',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tingkatkan kemampuan Algoritma dan Pemrograman kamu hari ini.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .82),
                  fontSize: 11.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: Colors.amber,
                      size: 17,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Terus semangat belajar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? photoUrl) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .16),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: .55),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              )
            : const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 28,
              ),
      ),
    );
  }

  Widget _headerButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDarkMode
              ? Colors.white.withValues(alpha: .06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: TextStyle(
          color: textColor,
          fontSize: 12.5,
        ),
        decoration: InputDecoration(
          hintText: 'Cari materi, video atau quiz...',
          hintStyle: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: primaryColor,
          ),
          suffixIcon: _searchController.text.isEmpty
              ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: secondaryTextColor,
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ACTION
  // ============================================================

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickActionCard(
            title: 'Mulai Quiz',
            subtitle: 'Uji kemampuan',
            icon: Icons.quiz_rounded,
            colors: const [
              Color(0xFF059669),
              Color(0xFF10B981),
            ],
            page: const QuizPage(),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _quickActionCard(
            title: 'Ranking',
            subtitle: 'Lihat peringkat',
            icon: Icons.emoji_events_rounded,
            colors: const [
              Color(0xFFF59E0B),
              Color(0xFFF97316),
            ],
            page: const RankingPage(),
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required Widget page,
  }) {
    return _Pressable(
      onTap: () => _openPage(page),
      child: Container(
        height: 82,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: .20),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .17),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgressCard() {
    return StreamBuilder<double>(
      stream: dashboard.progressBelajar(),
      builder: (context, snapshot) {
        final progress = (snapshot.data ?? 0).clamp(0.0, 1.0);
        final percentage = (progress * 100).round();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF5F6D),
                Color(0xFFFF8E53),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(23),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8E53)
                    .withValues(alpha: .20),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .17),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress Belajar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Sedikit demi sedikit menjadi hebat',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: progress,
                  ),
                  duration: const Duration(
                    milliseconds: 700,
                  ),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 10,
                      backgroundColor:
                          Colors.white.withValues(alpha: .24),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      percentage >= 100
                          ? 'Pembelajaran selesai 🎉'
                          : 'Terus tingkatkan progresmu',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: .18),
                color.withValues(alpha: .06),
              ],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: color,
            size: 21,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    final menus = <_MenuData>[
      _MenuData(
        'Materi',
        'Pelajari materi',
        Icons.menu_book_rounded,
        const Color(0xFF2563EB),
        const MateriPage(),
      ),
      _MenuData(
        'Video',
        'Video pembelajaran',
        Icons.play_circle_fill_rounded,
        const Color(0xFFEF4444),
        const VideoPage(),
      ),
      _MenuData(
        'Quiz',
        'Uji kemampuan',
        Icons.quiz_rounded,
        const Color(0xFF10B981),
        const QuizPage(),
      ),
      _MenuData(
        'Latihan',
        'Soal latihan',
        Icons.assignment_rounded,
        const Color(0xFF6366F1),
        const LatihanPage(),
      ),
      _MenuData(
        'Flowchart',
        'Belajar alur',
        Icons.account_tree_rounded,
        const Color(0xFF8B5CF6),
        const FlowchartPage(),
      ),
      _MenuData(
        'Simulasi',
        'Latihan algoritma',
        Icons.smart_display_rounded,
        const Color(0xFFF59E0B),
        const SimulasiPage(),
      ),
      _MenuData(
        'Ranking',
        'Papan peringkat',
        Icons.emoji_events_rounded,
        const Color(0xFFEAB308),
        const RankingPage(),
      ),
      _MenuData(
        'Profil',
        'Akun saya',
        Icons.person_rounded,
        const Color(0xFFEC4899),
        const ProfilePage(),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: .88,
      ),
      itemBuilder: (context, index) {
        final menu = menus[index];

        return _FeatureCard(
          menu: menu,
          index: index,
          isDark: _isDarkMode,
          onTap: () => _openPage(menu.page),
        );
      },
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: primaryColor.withValues(alpha: .10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Belajar',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Belajar sedikit setiap hari lebih baik daripada sekaligus.',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 9.5,
                    height: 1.35,
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
  // BELAJAR PAGE
  // ============================================================

  Widget _buildLearningPage() {
    return _simplePage(
      title: 'Belajar',
      icon: Icons.menu_book_rounded,
      children: [
        _largeAction(
          'Materi',
          'Pelajari materi Algoritma dan Pemrograman',
          Icons.menu_book_rounded,
          const Color(0xFF2563EB),
          const MateriPage(),
        ),
        _largeAction(
          'Video',
          'Tonton video pembelajaran',
          Icons.play_circle_fill_rounded,
          const Color(0xFFEF4444),
          const VideoPage(),
        ),
        _largeAction(
          'Quiz',
          'Uji pemahaman kamu',
          Icons.quiz_rounded,
          const Color(0xFF10B981),
          const QuizPage(),
        ),
        _largeAction(
          'Latihan',
          'Kerjakan soal latihan',
          Icons.assignment_rounded,
          const Color(0xFF6366F1),
          const LatihanPage(),
        ),
        _largeAction(
          'Flowchart',
          'Pelajari alur program',
          Icons.account_tree_rounded,
          const Color(0xFF8B5CF6),
          const FlowchartPage(),
        ),
        _largeAction(
          'Simulasi',
          'Latihan algoritma secara interaktif',
          Icons.smart_display_rounded,
          const Color(0xFFF59E0B),
          const SimulasiPage(),
        ),
      ],
    );
  }

  // ============================================================
  // RANKING PAGE
  // ============================================================

  Widget _buildRankingPage() {
    return _simplePage(
      title: 'Ranking',
      icon: Icons.emoji_events_rounded,
      children: [
        _largeAction(
          'Papan Peringkat',
          'Lihat posisi kamu bersama siswa lainnya',
          Icons.emoji_events_rounded,
          const Color(0xFFF59E0B),
          const RankingPage(),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Terus berlatih dan kumpulkan nilai terbaikmu! 🏆',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACCOUNT PAGE
  // ============================================================

  Widget _buildAccountPage() {
    final user = currentUser;

    final name = _getAccountName(user);
    final email = user?.email ?? 'Belum ada email';

    return _simplePage(
      title: 'Akun',
      icon: Icons.person_rounded,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F46E5),
                Color(0xFF8B5CF6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildAccountAvatar(user?.photoURL),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _accountItem(
          Icons.person_rounded,
          'Profil Saya',
          'Lihat dan ubah profil',
          () => _openPage(const ProfilePage()),
        ),
        _accountItem(
          _isDarkMode
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          'Tema Aplikasi',
          _isDarkMode
              ? 'Mode gelap aktif'
              : 'Mode terang aktif',
          _toggleTheme,
        ),
        _accountItem(
          Icons.emoji_events_rounded,
          'Ranking',
          'Lihat papan peringkat',
          () => _openPage(const RankingPage()),
        ),
      ],
    );
  }

  Widget _buildAccountAvatar(String? photoUrl) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white54,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              )
            : const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 38,
              ),
      ),
    );
  }

  Widget _accountItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDarkMode
              ? Colors.white.withValues(alpha: .05)
              : const Color(0xFFE8EAF0),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 3,
        ),
        leading: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 21,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 9.5,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: secondaryTextColor,
        ),
      ),
    );
  }

  // ============================================================
  // SIMPLE PAGE
  // ============================================================

  Widget _simplePage({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
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
            12,
            16,
            100,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(children),
          ),
        ),
      ],
    );
  }

  Widget _largeAction(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: color.withValues(alpha: .10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openPage(page),
          borderRadius: BorderRadius.circular(19),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 49,
                  height: 49,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withValues(alpha: .70),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 23,
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
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
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
                Icon(
                  Icons.chevron_right_rounded,
                  color: secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return SiswaBottomNavigation(
      currentIndex: 0,
      onTap: _handleBottomNavigation,
    );
  }

  void _handleBottomNavigation(int index) {
    if (!mounted) return;

    switch (index) {
      case 0:
        // Sudah berada di Beranda.
        return;

      case 1:
        _openPage(const MateriPage());
        return;

      case 2:
        _openPage(const VideoPage());
        return;

      case 3:
        _openPage(const QuizPage());
        return;

      case 4:
        _openPage(const ProfilePage());
        return;
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  String _getAccountName(User? user) {
    final displayName = user?.displayName?.trim();

    if (displayName != null &&
        displayName.isNotEmpty &&
        displayName.toLowerCase() != 'siswa') {
      return displayName;
    }

    final email = user?.email?.trim();

    if (email != null && email.isNotEmpty) {
      final username = email.split('@').first.trim();

      if (username.isNotEmpty) {
        final cleaned = username.replaceAll(RegExp(r'[._-]+'), ' ').trim();

        if (cleaned.isNotEmpty) {
          return cleaned
              .split(RegExp(r'\s+'))
              .map(
                (word) => word.isEmpty
                    ? word
                    : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
              )
              .join(' ');
        }
      }
    }

    return 'Siswa';
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat pagi 👋';
    }

    if (hour >= 11 && hour < 15) {
      return 'Selamat siang 👋';
    }

    if (hour >= 15 && hour < 18) {
      return 'Selamat sore 👋';
    }

    return 'Selamat malam 👋';
  }
}

// ================================================================
// MENU MODEL
// ================================================================

class _MenuData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const _MenuData(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.page,
  );
}

// ================================================================
// FEATURE CARD
// ================================================================

class _FeatureCard extends StatefulWidget {
  final _MenuData menu;
  final int index;
  final bool isDark;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.menu,
    required this.index,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  late final AnimationController _illustrationController;
  late final Animation<double> _illustrationAnimation;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 450 + widget.index * 60,
      ),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _illustrationAnimation = CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.easeInOut,
    );

    _illustrationController.repeat(reverse: true);

    Future<void>.delayed(
      Duration(milliseconds: widget.index * 55),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _illustrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    return ScaleTransition(
      scale: _animation,
      child: AnimatedScale(
        scale: _pressed ? .95 : 1,
        duration: const Duration(milliseconds: 110),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (value) {
              setState(() {
                _pressed = value;
              });
            },
            borderRadius: BorderRadius.circular(23),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isDark
                      ? const [
                          Color(0xFF1E293B),
                          Color(0xFF172033),
                        ]
                      : [
                          Colors.white,
                          menu.color.withValues(alpha: .045),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: menu.color.withValues(
                    alpha: widget.isDark ? .20 : .12,
                  ),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: menu.color.withValues(
                      alpha: widget.isDark ? .12 : .075,
                    ),
                    blurRadius: 17,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -22,
                    top: -22,
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: menu.color.withValues(
                          alpha: widget.isDark ? .08 : .055,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -35,
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: menu.color.withValues(
                          alpha: widget.isDark ? .06 : .035,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 74,
                          height: 68,
                          child: AnimatedBuilder(
                            animation: _illustrationAnimation,
                            builder: (context, child) {
                              final t = _illustrationAnimation.value;
                              final dy = -3.5 + (t * 7);
                              final angle = (t - .5) * .10;
                              final scale = .96 + (t * .08);

                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 2,
                                    top: 7,
                                    child: Opacity(
                                      opacity: .55,
                                      child: Transform.scale(
                                        scale: .85 + (t * .18),
                                        child: Icon(
                                          Icons.auto_awesome_rounded,
                                          color: menu.color.withValues(
                                            alpha: .55,
                                          ),
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 1,
                                    child: Opacity(
                                      opacity: .70,
                                      child: Transform.rotate(
                                        angle: -angle,
                                        child: Icon(
                                          Icons.auto_awesome_rounded,
                                          color: menu.color,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, dy),
                                    child: Transform.rotate(
                                      angle: angle,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                menu.color,
                                                menu.color.withValues(
                                                  alpha: .68,
                                                ),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            boxShadow: [
                                              BoxShadow(
                                                color: menu.color.withValues(
                                                  alpha: .24,
                                                ),
                                                blurRadius: 14,
                                                offset: const Offset(0, 7),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            menu.icon,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          menu.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.white
                                : const Color(0xFF172033),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          menu.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.white54
                                : const Color(0xFF64748B),
                            fontSize: 9.5,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            Text(
                              'Buka',
                              style: TextStyle(
                                color: menu.color,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: menu.color,
                              size: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// PRESSABLE
// ================================================================

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _Pressable({
    required this.child,
    required this.onTap,
  });

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? .96 : 1,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        child: widget.child,
      ),
    );
  }
}
