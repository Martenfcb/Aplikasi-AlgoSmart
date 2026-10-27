import 'package:flutter/material.dart';

class ProfilPengembangPage extends StatefulWidget {
  const ProfilPengembangPage({super.key});

  @override
  State<ProfilPengembangPage> createState() =>
      _ProfilPengembangPageState();
}

class _ProfilPengembangPageState
    extends State<ProfilPengembangPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ============================================================
  // DATA PENGEMBANG
  // ============================================================

  final String namaPengembang = 'Marten Shandra';

  final String nim = 'NIM Pengembang';

  final String programStudi = 'Sistem Informasi';

  final String universitas =
      'Universitas Putra Indonesia YPTK Padang';

  final String peran = 'Pengembang Aplikasi';

  final String deskripsi =
      'AlgoSmart dikembangkan sebagai media pembelajaran '
      'interaktif untuk membantu proses pembelajaran '
      'Algoritma dan Pemrograman agar menjadi lebih menarik, '
      'modern, dan mudah dipahami.';

  // ============================================================
  // DATA TIM
  // ============================================================

  final List<Map<String, String>> timKami = [
    {
      'nama': 'Pengembang 1',
      'peran': 'Developer',
      'deskripsi':
          'Bertanggung jawab dalam pengembangan aplikasi.',
    },
    {
      'nama': 'Pengembang 2',
      'peran': 'UI/UX',
      'deskripsi':
          'Bertanggung jawab dalam desain antarmuka aplikasi.',
    },
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        0.08,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

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
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF080D1A)
        : const Color(0xFFF7F8FC);

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

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
            color:
                theme.colorScheme.onSurface,
            size: 20,
          ),
        ),

        title: Text(
          'Profil Pengembang',
          style: TextStyle(
            color:
                theme.colorScheme.onSurface,
            fontSize: 19,
            fontWeight:
                FontWeight.w900,
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                18,
                10,
                18,
                35,
              ),

              child: Column(
                children: [
                  // ==================================================
                  // HERO
                  // ==================================================

                  _buildHero(
                    context,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ==================================================
                  // INFORMASI PENGEMBANG
                  // ==================================================

                  _buildDeveloperInfo(
                    context,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ==================================================
                  // TENTANG PENGEMBANG
                  // ==================================================

                  _buildAboutDeveloper(
                    context,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ==================================================
                  // TIM KAMI
                  // ==================================================

                  _buildTeamSection(
                    context,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ==================================================
                  // APLIKASI
                  // ==================================================

                  _buildApplicationSection(
                    context,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // ==================================================
                  // FOOTER
                  // ==================================================

                  _buildFooter(
                    context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        22,
        30,
        22,
        28,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFDB2777),
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(
          30,
        ),

        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF6366F1)
                    .withValues(
              alpha: 0.25,
            ),
            blurRadius: 28,
            offset:
                const Offset(
              0,
              12,
            ),
          ),
        ],
      ),

      child: Stack(
        children: [
          // ==================================================
          // DECORATION
          // ==================================================

          Positioned(
            right: -50,
            top: -65,
            child: Container(
              width: 160,
              height: 160,
              decoration:
                  BoxDecoration(
                color:
                    Colors.white.withValues(
                  alpha: 0.07,
                ),
                shape:
                    BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -55,
            bottom: -75,
            child: Container(
              width: 150,
              height: 150,
              decoration:
                  BoxDecoration(
                color:
                    Colors.white.withValues(
                  alpha: 0.05,
                ),
                shape:
                    BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              // ==================================================
              // AVATAR
              // ==================================================

              _buildAvatar(),

              const SizedBox(
                height: 17,
              ),

              Text(
                namaPengembang,
                textAlign:
                    TextAlign.center,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                peran,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color:
                      Colors.white70,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white.withValues(
                    alpha: 0.13,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                  border:
                      Border.all(
                    color:
                        Colors.white.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),

                child:
                    const Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color:
                          Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Pengembang AlgoSmart',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            10.5,
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

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar() {
    final initial =
        namaPengembang.trim().isNotEmpty
            ? namaPengembang
                .trim()[0]
                .toUpperCase()
            : 'M';

    return Container(
      width: 105,
      height: 105,
      padding:
          const EdgeInsets.all(4),

      decoration:
          BoxDecoration(
        shape:
            BoxShape.circle,
        color:
            Colors.white.withValues(
          alpha: 0.95,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.18,
            ),
            blurRadius: 18,
            offset:
                const Offset(
              0,
              8,
            ),
          ),
        ],
      ),

      child: ClipOval(
        child:
            Container(
          color:
              const Color(0xFF6366F1),

          alignment:
              Alignment.center,

          child:
              Text(
            initial,
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontSize:
                  42,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DEVELOPER INFO
  // ============================================================

  Widget _buildDeveloperInfo(
    BuildContext context,
  ) {
    return _buildCard(
      context,
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon:
                Icons.person_rounded,
            title:
                'Informasi Pengembang',
            subtitle:
                'Identitas pengembang aplikasi',
            color:
                const Color(0xFF6366F1),
          ),

          const SizedBox(
            height: 18,
          ),

          _infoItem(
            context,
            icon:
                Icons.badge_rounded,
            title:
                'Nama',
            value:
                namaPengembang,
            color:
                const Color(0xFF6366F1),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.numbers_rounded,
            title:
                'NIM',
            value:
                nim,
            color:
                const Color(0xFF2563EB),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.school_rounded,
            title:
                'Program Studi',
            value:
                programStudi,
            color:
                const Color(0xFF8B5CF6),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.account_balance_rounded,
            title:
                'Universitas',
            value:
                universitas,
            color:
                const Color(0xFF10B981),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.work_rounded,
            title:
                'Peran',
            value:
                peran,
            color:
                const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ABOUT DEVELOPER
  // ============================================================

  Widget _buildAboutDeveloper(
    BuildContext context,
  ) {
    return _buildCard(
      context,
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon:
                Icons.auto_awesome_rounded,
            title:
                'Tentang Pengembang',
            subtitle:
                'Informasi singkat',
            color:
                const Color(0xFF8B5CF6),
          ),

          const SizedBox(
            height: 17,
          ),

          Container(
            width:
                double.infinity,

            padding:
                const EdgeInsets.all(
              16,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(0xFF8B5CF6)
                      .withValues(
                alpha:
                    Theme.of(context)
                                .brightness ==
                            Brightness.dark
                        ? 0.08
                        : 0.045,
              ),

              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),

            child:
                Text(
              deskripsi,
              style:
                  TextStyle(
                color:
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(
                  alpha:
                      0.75,
                ),
                fontSize:
                    12,
                height:
                    1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEAM
  // ============================================================

  Widget _buildTeamSection(
    BuildContext context,
  ) {
    return _buildCard(
      context,
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon:
                Icons.groups_rounded,
            title:
                'Tim Kami',
            subtitle:
                'Orang-orang di balik AlgoSmart',
            color:
                const Color(0xFF06B6D4),
          ),

          const SizedBox(
            height: 18,
          ),

          ...timKami.map(
            (
              anggota,
            ) =>
                _buildTeamMember(
              context,
              nama:
                  anggota['nama'] ??
                      'Anggota Tim',
              peran:
                  anggota['peran'] ??
                      'Tim',
              deskripsi:
                  anggota['deskripsi'] ??
                      '',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEAM MEMBER
  // ============================================================

  Widget _buildTeamMember(
    BuildContext context, {
    required String nama,
    required String peran,
    required String deskripsi,
  }) {
    final theme =
        Theme.of(context);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 11,
      ),

      padding:
          const EdgeInsets.all(
        13,
      ),

      decoration:
          BoxDecoration(
        color:
            theme.brightness ==
                    Brightness.dark
                ? Colors.white
                    .withValues(
                  alpha:
                      0.035,
                )
                : const Color(
                    0xFFF8FAFC,
                  ),

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border:
            Border.all(
          color:
              theme.dividerColor
                  .withValues(
            alpha:
                0.10,
          ),
        ),
      ),

      child: Row(
        children: [
          // ==================================================
          // AVATAR
          // ==================================================

          Container(
            width: 48,
            height: 48,

            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  Color(0xFF06B6D4),
                  Color(0xFF2563EB),
                ],
              ),
              shape:
                  BoxShape.circle,
            ),

            alignment:
                Alignment.center,

            child:
                Text(
              nama.isNotEmpty
                  ? nama[0]
                      .toUpperCase()
                  : 'T',
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    18,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          // ==================================================
          // INFO
          // ==================================================

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  maxLines:
                      1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      TextStyle(
                    color:
                        theme.colorScheme.onSurface,
                    fontSize:
                        13,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  peran,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF06B6D4),
                    fontSize:
                        10,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  deskripsi,
                  maxLines:
                      2,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      TextStyle(
                    color:
                        theme.colorScheme.onSurface
                            .withValues(
                      alpha:
                          0.55,
                    ),
                    fontSize:
                        9.5,
                    height:
                        1.4,
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
  // APPLICATION
  // ============================================================

  Widget _buildApplicationSection(
    BuildContext context,
  ) {
    return _buildCard(
      context,
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            icon:
                Icons.school_rounded,
            title:
                'Tentang AlgoSmart',
            subtitle:
                'Media pembelajaran interaktif',
            color:
                const Color(0xFF10B981),
          ),

          const SizedBox(
            height: 18,
          ),

          _infoItem(
            context,
            icon:
                Icons.apps_rounded,
            title:
                'Nama Aplikasi',
            value:
                'AlgoSmart',
            color:
                const Color(0xFF6366F1),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.menu_book_rounded,
            title:
                'Mata Pelajaran',
            value:
                'Algoritma dan Pemrograman',
            color:
                const Color(0xFFF59E0B),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.phone_android_rounded,
            title:
                'Platform',
            value:
                'Android',
            color:
                const Color(0xFF10B981),
          ),

          const SizedBox(
            height: 11,
          ),

          _infoItem(
            context,
            icon:
                Icons.new_releases_rounded,
            title:
                'Versi',
            value:
                '1.0.0',
            color:
                const Color(0xFF06B6D4),
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
    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(
        color:
            isDark
                ? const Color(
                    0xFF111827,
                  )
                : Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border:
            Border.all(
          color:
              isDark
                  ? Colors.white
                      .withValues(
                    alpha:
                        0.06,
                  )
                  : const Color(
                      0xFFE5E7EB,
                    ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha:
                  isDark
                      ? 0.14
                      : 0.035,
            ),
            blurRadius:
                20,
            offset:
                const Offset(
              0,
              8,
            ),
          ),
        ],
      ),

      child:
          child,
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
    final theme =
        Theme.of(context);

    return Row(
      children: [
        Container(
          width: 45,
          height: 45,

          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                color,
                color.withValues(
                  alpha:
                      0.70,
                ),
              ],
            ),

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),

          child:
              Icon(
            icon,
            color:
                Colors.white,
            size:
                22,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    TextStyle(
                  color:
                      theme.colorScheme.onSurface,
                  fontSize:
                      15,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                subtitle,
                style:
                    TextStyle(
                  color:
                      theme.colorScheme.onSurface
                          .withValues(
                    alpha:
                        0.50,
                  ),
                  fontSize:
                      10,
                ),
              ),
            ],
          ),
        ),
      ],
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
    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      padding:
          const EdgeInsets.all(
        12,
      ),

      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha:
              isDark
                  ? 0.07
                  : 0.045,
        ),

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha:
                    0.12,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child:
                Icon(
              icon,
              color:
                  color,
              size:
                  20,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    color:
                        theme.colorScheme.onSurface
                            .withValues(
                      alpha:
                          0.50,
                    ),
                    fontSize:
                        9.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  value,
                  maxLines:
                      3,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      TextStyle(
                    color:
                        theme.colorScheme.onSurface,
                    fontSize:
                        12.5,
                    fontWeight:
                        FontWeight.w800,
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
  // FOOTER
  // ============================================================

  Widget _buildFooter(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Column(
      children: [
        Container(
          width: 52,
          height: 52,

          decoration:
              BoxDecoration(
            gradient:
                const LinearGradient(
              colors: [
                Color(0xFF4F46E5),
                Color(0xFFDB2777),
              ],
            ),

            borderRadius:
                BorderRadius.circular(
              17,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    const Color(
                        0xFF6366F1)
                        .withValues(
                  alpha:
                      0.20,
                ),
                blurRadius:
                    15,
                offset:
                    const Offset(
                  0,
                  6,
                ),
              ),
            ],
          ),

          child:
              const Icon(
            Icons.school_rounded,
            color:
                Colors.white,
            size:
                26,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(
          'AlgoSmart',
          style:
              TextStyle(
            color:
                theme.colorScheme.onSurface,
            fontSize:
                13,
            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          'Media Pembelajaran Interaktif',
          textAlign:
              TextAlign.center,
          style:
              TextStyle(
            color:
                theme.colorScheme.onSurface
                    .withValues(
              alpha:
                  0.50,
            ),
            fontSize:
                9.5,
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          'Versi 1.0.0',
          style:
              TextStyle(
            color:
                theme.colorScheme.onSurface
                    .withValues(
              alpha:
                  0.35,
            ),
            fontSize:
                9,
          ),
        ),
      ],
    );
  }
}