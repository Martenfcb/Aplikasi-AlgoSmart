import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  static const Color primaryColor = Color(0xFF6366F1);
  static const Color purpleColor = Color(0xFF7C3AED);
  static const Color pinkColor = Color(0xFFDB2777);

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _backgroundColor(BuildContext context) {
    return _isDark(context)
        ? const Color(0xFF080D1A)
        : const Color(0xFFF7F8FC);
  }

  Color _cardColor(BuildContext context) {
    return _isDark(context)
        ? const Color(0xFF111827)
        : Colors.white;
  }

  Color _textColor(BuildContext context) {
    return _isDark(context)
        ? Colors.white
        : const Color(0xFF172033);
  }

  Color _subtitleColor(BuildContext context) {
    return _isDark(context)
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _backgroundColor(context),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _textColor(context),
            size: 20,
          ),
        ),
        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(
            color: _textColor(context),
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            35,
          ),
          child: Column(
            children: [
              _buildAppHeader(context),

              const SizedBox(height: 20),

              _buildDescription(context),

              const SizedBox(height: 18),

              _buildFeatures(context),

              const SizedBox(height: 18),

              _buildApplicationInfo(context),

              const SizedBox(height: 25),

              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP HEADER
  // ============================================================

  Widget _buildAppHeader(BuildContext context) {
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
            primaryColor,
            purpleColor,
            pinkColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(
              alpha: 0.24,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.07,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -50,
            bottom: -65,
            child: Container(
              width: 130,
              height: 130,
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
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.25,
                    ),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),

              const SizedBox(height: 17),

              const Text(
                'AlgoSmart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Media Pembelajaran Interaktif',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.13,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: const Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  Widget _buildDescription(BuildContext context) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon: Icons.info_rounded,
            title: 'Tentang AlgoSmart',
            subtitle: 'Mengenal aplikasi pembelajaran',
            color: const Color(0xFF6366F1),
          ),

          const SizedBox(height: 18),

          Text(
            'AlgoSmart merupakan media pembelajaran '
            'interaktif yang dirancang untuk membantu '
            'proses pembelajaran Algoritma dan Pemrograman.',
            style: TextStyle(
              color: _subtitleColor(context),
              fontSize: 12,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Aplikasi ini menyediakan berbagai konten '
            'pembelajaran yang dapat membantu guru dalam '
            'mengelola materi serta membantu siswa '
            'memahami materi pembelajaran secara lebih '
            'interaktif.',
            style: TextStyle(
              color: _subtitleColor(context),
              fontSize: 12,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURES
  // ============================================================

  Widget _buildFeatures(BuildContext context) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon: Icons.auto_awesome_rounded,
            title: 'Fitur Aplikasi',
            subtitle: 'Fitur utama yang tersedia',
            color: const Color(0xFF8B5CF6),
          ),

          const SizedBox(height: 18),

          _featureItem(
            context,
            icon: Icons.menu_book_rounded,
            title: 'Materi Pembelajaran',
            subtitle:
                'Menyediakan materi pembelajaran yang dapat '
                'dipelajari secara digital.',
            color: const Color(0xFF2563EB),
          ),

          const SizedBox(height: 10),

          _featureItem(
            context,
            icon: Icons.video_library_rounded,
            title: 'Video Pembelajaran',
            subtitle:
                'Mendukung pembelajaran melalui konten '
                'video yang interaktif.',
            color: const Color(0xFFEF4444),
          ),

          const SizedBox(height: 10),

          _featureItem(
            context,
            icon: Icons.quiz_rounded,
            title: 'Quiz',
            subtitle:
                'Membantu menguji pemahaman siswa terhadap '
                'materi pembelajaran.',
            color: const Color(0xFFF59E0B),
          ),

          const SizedBox(height: 10),

          _featureItem(
            context,
            icon: Icons.dark_mode_rounded,
            title: 'Mode Gelap',
            subtitle:
                'Menyediakan tampilan terang dan gelap '
                'sesuai kenyamanan pengguna.',
            color: const Color(0xFF7C3AED),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APPLICATION INFO
  // ============================================================

  Widget _buildApplicationInfo(BuildContext context) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon: Icons.apps_rounded,
            title: 'Informasi Aplikasi',
            subtitle: 'Detail SQLearning',
            color: const Color(0xFF06B6D4),
          ),

          const SizedBox(height: 18),

          _infoItem(
            context,
            icon: Icons.apps_rounded,
            title: 'Nama Aplikasi',
            value: 'SQLearning',
            color: const Color(0xFF06B6D4),
          ),

          const SizedBox(height: 10),

          _infoItem(
            context,
            icon: Icons.numbers_rounded,
            title: 'Versi',
            value: '1.0.0',
            color: const Color(0xFF14B8A6),
          ),

          const SizedBox(height: 10),

          _infoItem(
            context,
            icon: Icons.school_rounded,
            title: 'Mata Pelajaran',
            value: 'Algoritma dan Pemrograman',
            color: const Color(0xFFF59E0B),
          ),

          const SizedBox(height: 10),

          _infoItem(
            context,
            icon: Icons.phone_android_rounded,
            title: 'Platform',
            value: 'Android',
            color: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURE ITEM
  // ============================================================

  Widget _featureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: _isDark(context) ? 0.07 : 0.045,
        ),
        borderRadius: BorderRadius.circular(17),
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
                  color.withValues(alpha: 0.70),
                ],
              ),
              borderRadius: BorderRadius.circular(13),
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
                    color: _textColor(context),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _subtitleColor(context),
                    fontSize: 9.8,
                    height: 1.4,
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
  // INFO ITEM
  // ============================================================

  Widget _infoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: _isDark(context) ? 0.07 : 0.045,
        ),
        borderRadius: BorderRadius.circular(16),
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
              borderRadius: BorderRadius.circular(12),
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
                    color: _subtitleColor(context),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _textColor(context),
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

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard(
    BuildContext context, {
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isDark(context)
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: _isDark(context) ? 0.14 : 0.035,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _sectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
            borderRadius: BorderRadius.circular(14),
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
                  color: _textColor(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: TextStyle(
                  color: _subtitleColor(context),
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
  // FOOTER
  // ============================================================

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                primaryColor,
                pinkColor,
              ],
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'AlgoSmart',
          style: TextStyle(
            color: _textColor(context),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Media Pembelajaran Interaktif',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _subtitleColor(context),
            fontSize: 9.5,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          '© 2026 AlgoSmart',
          style: TextStyle(
            color: _subtitleColor(context).withValues(
              alpha: 0.7,
            ),
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}