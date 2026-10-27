import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF080D1A)
        : const Color(0xFFF7F8FC);

    final cardColor = isDark
        ? const Color(0xFF111827)
        : Colors.white;

    final textColor = isDark
        ? Colors.white
        : const Color(0xFF172033);

    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
        ),

        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),

        centerTitle: true,
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            35,
          ),

          child: Column(
            children: [
              // HEADER
              _buildHeader(
                context,
                isDark: isDark,
              ),

              const SizedBox(height: 20),

              // TENTANG APLIKASI
              _buildAboutCard(
                cardColor: cardColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),

              const SizedBox(height: 18),

              // FITUR
              _buildFeatureCard(
                cardColor: cardColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),

              const SizedBox(height: 18),

              // INFORMASI APLIKASI
              _buildAppInfoCard(
                cardColor: cardColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),

              const SizedBox(height: 18),

              // PENGEMBANG
              _buildDeveloperCard(
                cardColor: cardColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),

              const SizedBox(height: 25),

              // FOOTER
              _buildFooter(
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(
    BuildContext context, {
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        30,
        22,
        28,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFDB2777),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1)
                .withValues(alpha: 0.25),

            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Stack(
        children: [
          // DEKORASI

          Positioned(
            right: -50,
            top: -65,

            child: Container(
              width: 160,
              height: 160,

              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.07,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -60,
            bottom: -75,

            child: Container(
              width: 145,
              height: 145,

              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.05,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              // LOGO

              Container(
                width: 92,
                height: 92,

                padding: const EdgeInsets.all(5),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(25),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),

                  child: Image.asset(
                    'assets/images/logoo.png',

                    fit: BoxFit.contain,

                    errorBuilder:
                        (_, __, ___) {
                      return Container(
                        decoration:
                            const BoxDecoration(
                          gradient:
                              LinearGradient(
                            colors: [
                              Color(0xFF4F46E5),
                              Color(0xFFDB2777),
                            ],
                          ),
                        ),

                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 45,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 17),

              const Text(
                'SQLearning',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Media Pembelajaran Interaktif',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.13),

                  borderRadius:
                      BorderRadius.circular(30),

                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.18),
                  ),
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 16,
                    ),

                    SizedBox(width: 7),

                    Text(
                      'Algoritma dan Pemrograman',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight:
                            FontWeight.w800,
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

  // =============================================================
  // ABOUT
  // =============================================================

  Widget _buildAboutCard({
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return _buildCard(
      cardColor: cardColor,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _sectionHeader(
            icon: Icons.info_rounded,
            title: 'Tentang SQLearning',
            subtitle:
                'Mengenal aplikasi pembelajaran',
            color: const Color(0xFF6366F1),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 18),

          Text(
            'SQLearning merupakan media pembelajaran '
            'interaktif berbasis Android yang dirancang '
            'untuk membantu proses pembelajaran materi '
            'Algoritma dan Pemrograman.',

            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Aplikasi ini menyediakan materi pembelajaran, '
            'video, kuis, serta fitur pendukung lainnya '
            'agar proses belajar menjadi lebih menarik, '
            'interaktif, dan mudah dipahami.',

            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FEATURES
  // =============================================================

  Widget _buildFeatureCard({
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return _buildCard(
      cardColor: cardColor,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _sectionHeader(
            icon: Icons.auto_awesome_rounded,
            title: 'Fitur Aplikasi',
            subtitle:
                'Fitur yang tersedia di SQLearning',
            color: const Color(0xFF8B5CF6),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 18),

          _featureItem(
            icon: Icons.menu_book_rounded,
            title: 'Materi Pembelajaran',
            subtitle:
                'Mempelajari materi Algoritma dan Pemrograman.',
            color: const Color(0xFF6366F1),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _featureItem(
            icon: Icons.play_circle_fill_rounded,
            title: 'Video Pembelajaran',
            subtitle:
                'Mendukung pembelajaran melalui video.',
            color: const Color(0xFFEF4444),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _featureItem(
            icon: Icons.quiz_rounded,
            title: 'Kuis',
            subtitle:
                'Melatih pemahaman siswa melalui soal interaktif.',
            color: const Color(0xFFF59E0B),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _featureItem(
            icon: Icons.emoji_events_rounded,
            title: 'Ranking',
            subtitle:
                'Menampilkan pencapaian dan hasil belajar.',
            color: const Color(0xFF10B981),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // APP INFORMATION
  // =============================================================

  Widget _buildAppInfoCard({
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return _buildCard(
      cardColor: cardColor,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _sectionHeader(
            icon: Icons.apps_rounded,
            title: 'Informasi Aplikasi',
            subtitle:
                'Detail aplikasi SQLearning',
            color: const Color(0xFF06B6D4),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 18),

          _infoItem(
            icon: Icons.apps_rounded,
            title: 'Nama Aplikasi',
            value: 'SQLearning',
            color: const Color(0xFF06B6D4),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon: Icons.numbers_rounded,
            title: 'Versi',
            value: '1.0.0',
            color: const Color(0xFF14B8A6),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon: Icons.category_rounded,
            title: 'Kategori',
            value: 'Media Pembelajaran Interaktif',
            color: const Color(0xFF8B5CF6),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon: Icons.menu_book_rounded,
            title: 'Mata Pelajaran',
            value:
                'Algoritma dan Pemrograman',
            color: const Color(0xFFF59E0B),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon: Icons.devices_rounded,
            title: 'Platform',
            value: 'Android',
            color: const Color(0xFF22C55E),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DEVELOPER
  // =============================================================

  Widget _buildDeveloperCard({
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return _buildCard(
      cardColor: cardColor,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _sectionHeader(
            icon: Icons.code_rounded,
            title: 'Tim Pengembang',
            subtitle:
                'Pengembangan aplikasi SQLearning',
            color: const Color(0xFFEC4899),
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1)
                      .withValues(alpha: 0.08),
                  const Color(0xFFEC4899)
                      .withValues(alpha: 0.08),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(18),

              border: Border.all(
                color: isDarkColor(
                  context: null,
                )
                    ? Colors.white
                        .withValues(alpha: 0.05)
                    : const Color(0xFFE5E7EB),
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,

                  decoration:
                      const BoxDecoration(
                    gradient:
                        LinearGradient(
                      colors: [
                        Color(0xFF4F46E5),
                        Color(0xFFDB2777),
                      ],
                    ),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.person_rounded,
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
                      Text(
                        'Pengembang SQLearning',

                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Media Pembelajaran Interaktif',

                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 10,
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

  // =============================================================
  // CARD
  // =============================================================

  Widget _buildCard({
    required Color cardColor,
    required Widget child,
  }) {
    final isDark =
        cardColor == const Color(0xFF111827);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: isDark
              ? Colors.white.withValues(
                  alpha: 0.06,
                )
              : const Color(0xFFE5E7EB),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.14 : 0.035,
            ),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: child,
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withValues(alpha: 0.70),
              ],
            ),

            borderRadius:
                BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
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
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,

                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // FEATURE ITEM
  // =============================================================

  Widget _featureItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.045,
        ),

        borderRadius:
            BorderRadius.circular(17),
      ),

      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(
                    alpha: 0.70,
                  ),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 21,
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
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 10,
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

  // =============================================================
  // INFO ITEM
  // =============================================================

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.045,
        ),

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.12,
              ),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: color,
              size: 20,
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
                    color: subtitleColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  maxLines: 3,
                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FOOTER
  // =============================================================

  Widget _buildFooter({
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,

          decoration: BoxDecoration(
            gradient:
                const LinearGradient(
              colors: [
                Color(0xFF4F46E5),
                Color(0xFFDB2777),
              ],
            ),

            borderRadius:
                BorderRadius.circular(17),
          ),

          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'SQLearning',

          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Media Pembelajaran Interaktif',

          textAlign: TextAlign.center,

          style: TextStyle(
            color: subtitleColor,
            fontSize: 9.5,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Versi 1.0.0',

          style: TextStyle(
            color: subtitleColor,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DARK MODE HELPER
  // =============================================================

  bool isDarkColor({
    BuildContext? context,
  }) {
    if (context == null) {
      return false;
    }

    return Theme.of(context).brightness ==
        Brightness.dark;
  }
}