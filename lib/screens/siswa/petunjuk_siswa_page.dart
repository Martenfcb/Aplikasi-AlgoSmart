import 'package:flutter/material.dart';

import 'widgets/siswa_bottom_navigation.dart';

class PetunjukSiswaPage extends StatefulWidget {
  const PetunjukSiswaPage({super.key});

  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);

  @override
  State<PetunjukSiswaPage> createState() => _PetunjukSiswaPageState();
}

class _PetunjukSiswaPageState extends State<PetunjukSiswaPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.94,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF6F7FC),

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(
                  context,
                  isDark,
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  30,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildWelcomeCard(isDark),

                    const SizedBox(height: 24),

                    _buildSectionTitle(
                      'Cara Menggunakan Aplikasi',
                      'Ikuti langkah berikut untuk belajar dengan mudah.',
                      isDark,
                    ),

                    const SizedBox(height: 15),

                    _buildAnimatedGuide(
                      index: 0,
                      number: '01',
                      icon: Icons.home_rounded,
                      title: 'Buka Beranda',
                      description:
                          'Gunakan menu Beranda untuk melihat menu dan fitur pembelajaran yang tersedia.',
                      color: const Color(0xFF6366F1),
                      isDark: isDark,
                    ),

                    _buildAnimatedGuide(
                      index: 1,
                      number: '02',
                      icon: Icons.menu_book_rounded,
                      title: 'Pelajari Materi',
                      description:
                          'Pilih materi pembelajaran untuk membaca dan memahami materi Algoritma dan Pemrograman.',
                      color: const Color(0xFF06B6D4),
                      isDark: isDark,
                    ),

                    _buildAnimatedGuide(
                      index: 2,
                      number: '03',
                      icon: Icons.play_circle_fill_rounded,
                      title: 'Tonton Video',
                      description:
                          'Gunakan video pembelajaran sebagai media tambahan untuk memahami konsep dengan lebih mudah.',
                      color: const Color(0xFFEF4444),
                      isDark: isDark,
                    ),

                    _buildAnimatedGuide(
                      index: 3,
                      number: '04',
                      icon: Icons.quiz_rounded,
                      title: 'Kerjakan Latihan',
                      description:
                          'Kerjakan latihan atau quiz untuk menguji pemahaman terhadap materi yang sudah dipelajari.',
                      color: const Color(0xFFF59E0B),
                      isDark: isDark,
                    ),

                    _buildAnimatedGuide(
                      index: 4,
                      number: '05',
                      icon: Icons.emoji_events_rounded,
                      title: 'Lihat Hasil',
                      description:
                          'Periksa hasil pengerjaan dan gunakan hasil tersebut sebagai bahan evaluasi belajar.',
                      color: const Color(0xFF10B981),
                      isDark: isDark,
                    ),

                    const SizedBox(height: 10),

                    _buildTipsCard(isDark),

                    const SizedBox(height: 20),

                    _buildHelpCard(isDark),

                    const SizedBox(height: 8),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: const SiswaBottomNavigation(
        currentIndex: 1,
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        18,
      ),
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFF8B5CF6),
            Color(0xFFEC4899),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: PetunjukSiswaPage.primary.withValues(
              alpha: 0.28,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.17,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.18,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Petunjuk Penggunaan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Panduan menggunakan AlgoSmart',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.13,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.13,
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 28,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Gunakan aplikasi secara bertahap agar proses belajar menjadi lebih mudah dan menyenangkan.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
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
  // WELCOME CARD
  // ============================================================

  Widget _buildWelcomeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE7E9F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.08 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF06B6D4),
                    Color(0xFF6366F1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1)
                        .withValues(alpha: 0.22),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Colors.white,
                size: 29,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Belajar! 👋',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF172033),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Jelajahi fitur AlgoSmart dan tingkatkan kemampuanmu.',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontSize: 11,
                    height: 1.45,
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
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                PetunjukSiswaPage.primary,
                PetunjukSiswaPage.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
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
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF172033),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ANIMATED GUIDE
  // ============================================================

  Widget _buildAnimatedGuide({
    required int index,
    required String number,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isDark,
  }) {
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        (index * 0.08).clamp(0.0, 0.5),
        0.65 + (index * 0.05).clamp(0.0, 0.3),
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              25 * (1 - value),
            ),
            child: Transform.scale(
              scale: 0.96 + (value * 0.04),
              child: child,
            ),
          ),
        );
      },
      child: _buildGuideCard(
        number: number,
        icon: icon,
        title: title,
        description: description,
        color: color,
        isDark: isDark,
      ),
    );
  }

  // ============================================================
  // GUIDE CARD
  // ============================================================

  Widget _buildGuideCard({
    required String number,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 13,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE7E9F2),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: isDark ? 0.08 : 0.07,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.72),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(
                    alpha: 0.23,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF172033),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                            BorderRadius.circular(9),
                      ),
                      child: Text(
                        number,
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  description,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 9),

                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: color,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Langkah $number',
                      style: TextStyle(
                        color: color,
                        fontSize: 9.5,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIPS
  // ============================================================

  Widget _buildTipsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0EA5E9),
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1)
                .withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 9),
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
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.15,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.tips_and_updates_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips Belajar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Agar belajar lebih efektif',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildTip(
            'Pelajari materi secara berurutan.',
          ),

          _buildTip(
            'Tonton video untuk memperkuat pemahaman.',
          ),

          _buildTip(
            'Kerjakan latihan dengan teliti.',
          ),

          _buildTip(
            'Evaluasi hasil belajar secara berkala.',
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 16,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELP
  // ============================================================

  Widget _buildHelpCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE7E9F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.07 : 0.035,
            ),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF10B981),
                  Color(0xFF06B6D4),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh Bantuan?',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF172033),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Hubungi guru jika mengalami kesulitan dalam proses pembelajaran.',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontSize: 10.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981)
                  .withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF10B981),
              size: 13,
            ),
          ),
        ],
      ),
    );
  }
}