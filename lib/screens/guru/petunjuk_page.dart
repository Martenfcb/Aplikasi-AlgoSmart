import 'package:flutter/material.dart';

class PetunjukPage extends StatelessWidget {
  const PetunjukPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primary = theme.colorScheme.primary;
    final background = theme.scaffoldBackgroundColor;

    final petunjuk = [
      {
        'icon': Icons.menu_book_rounded,
        'title': 'Kelola Materi',
        'desc':
            'Guru dapat menambah, mengubah, dan menghapus materi pembelajaran Algoritma dan Pemrograman.',
        'color': const Color(0xFF2563EB),
      },
      {
        'icon': Icons.play_circle_fill_rounded,
        'title': 'Kelola Video',
        'desc':
            'Guru dapat menambahkan video pembelajaran dari YouTube dan memutarnya langsung di dalam aplikasi.',
        'color': const Color(0xFFEF4444),
      },
      {
        'icon': Icons.quiz_rounded,
        'title': 'Kelola Quiz',
        'desc':
            'Guru dapat membuat soal quiz, menentukan pilihan jawaban, serta menentukan kunci jawaban.',
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Icons.emoji_events_rounded,
        'title': 'Ranking Nilai',
        'desc':
            'Guru dapat melihat hasil dan ranking nilai siswa berdasarkan quiz yang telah dikerjakan.',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.account_tree_rounded,
        'title': 'CP & ATP',
        'desc':
            'Guru dapat melihat Capaian Pembelajaran (CP) dan Alur Tujuan Pembelajaran (ATP) yang digunakan dalam proses pembelajaran.',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.groups_rounded,
        'title': 'Monitoring Siswa',
        'desc':
            'Guru dapat memantau aktivitas belajar siswa melalui nilai dan hasil quiz yang tersimpan di dalam sistem.',
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Petunjuk Penggunaan',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 18,
                  vertical: 20,
                ),
                children: [
                  // =====================================================
                  // HEADER ALGOSMART
                  // =====================================================

                  _buildHeroHeader(
                    context,
                    isDark: isDark,
                    primary: primary,
                  ),

                  const SizedBox(height: 28),

                  // =====================================================
                  // TITLE
                  // =====================================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panduan Fitur',
                              style: TextStyle(
                                color: theme
                                    .colorScheme
                                    .onSurface,
                                fontSize: 23,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Pelajari fitur-fitur yang tersedia di AlgoSmart.',
                              style: TextStyle(
                                color: theme
                                    .colorScheme
                                    .onSurface
                                    .withValues(
                                  alpha: 0.55,
                                ),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: Text(
                          '${petunjuk.length} Fitur',
                          style: TextStyle(
                            color: primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // =====================================================
                  // PETUNJUK GRID / LIST
                  // =====================================================

                  if (isDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.55,
                      ),
                      itemCount: petunjuk.length,
                      itemBuilder: (context, index) {
                        final item = petunjuk[index];

                        return _buildPetunjukCard(
                          context,
                          index: index,
                          icon: item['icon'] as IconData,
                          title: item['title'] as String,
                          desc: item['desc'] as String,
                          color: item['color'] as Color,
                        );
                      },
                    )
                  else
                    Column(
                      children: List.generate(
                        petunjuk.length,
                        (index) {
                          final item = petunjuk[index];

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 14,
                            ),
                            child: _buildPetunjukCard(
                              context,
                              index: index,
                              icon:
                                  item['icon'] as IconData,
                              title:
                                  item['title'] as String,
                              desc:
                                  item['desc'] as String,
                              color:
                                  item['color'] as Color,
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 18),

                  // =====================================================
                  // ABOUT ALGOSMART
                  // =====================================================

                  _buildAboutCard(
                    context,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // FOOTER
                  // =====================================================

                  Center(
                    child: Text(
                      'AlgoSmart • Media Pembelajaran Interaktif',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme
                            .colorScheme
                            .onSurface
                            .withValues(
                          alpha: 0.38,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // HERO HEADER
  // ================================================================

  Widget _buildHeroHeader(
    BuildContext context, {
    required bool isDark,
    required Color primary,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2563EB),
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(
              alpha: 0.25,
            ),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.07,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 35,
            bottom: -45,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.05,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.16,
                  ),
                  borderRadius:
                      BorderRadius.circular(21),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.20,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(width: 17),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AlgoSmart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Media Pembelajaran Interaktif',
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: 0.86,
                        ),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.14,
                        ),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Algoritma & Pemrograman',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
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

  // ================================================================
  // PETUNJUK CARD
  // ================================================================

  Widget _buildPetunjukCard(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.08,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha:
                  theme.brightness == Brightness.dark
                      ? 0.04
                      : 0.08,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ICON
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withValues(
                      alpha: 0.72,
                    ),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(
                      alpha: 0.20,
                    ),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 15),

            // CONTENT
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
                            color: theme
                                .colorScheme
                                .onSurface,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(
                            alpha: 0.09,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    desc,
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onSurface
                          .withValues(
                        alpha: 0.57,
                      ),
                      fontSize: 12,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: color,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Pelajari fitur',
                        style: TextStyle(
                          color: color,
                          fontSize: 10.5,
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
      ),
    );
  }

  // ================================================================
  // ABOUT CARD
  // ================================================================

  Widget _buildAboutCard(
    BuildContext context, {
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.08,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.08 : 0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5)
                      .withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'Tentang AlgoSmart',
            style: TextStyle(
              color:
                  theme.colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            'AlgoSmart adalah media pembelajaran interaktif berbasis Android yang dirancang untuk membantu proses pembelajaran Algoritma dan Pemrograman menjadi lebih mudah, menarik, dan interaktif.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(
                alpha: 0.58,
              ),
              fontSize: 12.5,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 18),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(
                context,
                Icons.phone_android_rounded,
                'Android',
              ),
              _buildTag(
                context,
                Icons.code_rounded,
                'Pemrograman',
              ),
              _buildTag(
                context,
                Icons.school_rounded,
                'Pembelajaran',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TAG
  // ================================================================

  Widget _buildTag(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary
            .withValues(
          alpha: 0.07,
        ),
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color:
                  theme.colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}