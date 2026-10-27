import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'latihan_page.dart';
import 'materi_page.dart';
import 'profile_page.dart';
import 'quiz_page.dart';
import 'ranking_page.dart';
import 'simulasi_page.dart';
import 'video_page.dart';

class SiswaDashboard extends StatefulWidget {
  const SiswaDashboard({super.key});

  @override
  State<SiswaDashboard> createState() => _SiswaDashboardState();
}

class _SiswaDashboardState extends State<SiswaDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _selectedIndex = 0;
  bool _darkMode = false;

final List<_StudentMenu> _menus = const [
  _StudentMenu(
    title: 'Materi',
    subtitle: 'Materi pembelajaran',
    buttonText: 'BELAJAR',
    icon: Icons.menu_book_rounded,
    color: Color(0xFF3B82F6),
    imageUrl:
        'https://cdn-icons-png.flaticon.com/512/2232/2232688.png',
    pageType: 'materi',
  ),

  _StudentMenu(
  title: 'Video',
  subtitle: 'Video pembelajaran',
  buttonText: 'TONTON',
  icon: Icons.video_library_rounded,
  color: Color(0xFFEF4444),
  imageUrl:
      'https://cdn-icons-png.flaticon.com/512/3659/3659899.png',
  pageType: 'video',
),
 
  _StudentMenu(
    title: 'Quiz',
    subtitle: 'Soal dan kuis interaktif',
    buttonText: 'MULAI',
    icon: Icons.quiz_rounded,
    color: Color(0xFF10B981),
   imageUrl:
    'https://cdn-icons-png.flaticon.com/512/2921/2921222.png',
    pageType: 'quiz',
  ),

  _StudentMenu(
    title: 'Latihan',
    subtitle: 'Latihan soal siswa',
    buttonText: 'LATIHAN',
    icon: Icons.assignment_rounded,
    color: Color(0xFF6366F1),
    imageUrl:
        'https://cdn-icons-png.flaticon.com/512/942/942748.png',
    pageType: 'latihan',
  ),

  _StudentMenu(
    title: 'Simulasi',
    subtitle: 'Simulasi algoritma',
    buttonText: 'SIMULASI',
    icon: Icons.auto_graph_rounded,
    color: Color(0xFF8B5CF6),
    imageUrl:
        'https://cdn-icons-png.flaticon.com/512/2997/2997206.png',
    pageType: 'simulasi',
  ),

  _StudentMenu(
    title: 'Ranking',
    subtitle: 'Ranking dan pencapaian',
    buttonText: 'LIHAT',
    icon: Icons.emoji_events_rounded,
    color: Color(0xFFF59E0B),
    imageUrl:
        'https://cdn-icons-png.flaticon.com/512/2583/2583344.png',
    pageType: 'ranking',
  ),
];

  Color get backgroundColor =>
      _darkMode ? const Color(0xFF0B1020) : const Color(0xFFF6F7FB);

  Color get cardColor =>
      _darkMode ? const Color(0xFF151B2C) : Colors.white;

  Color get textColor =>
      _darkMode ? Colors.white : const Color(0xFF172033);

  Color get secondaryTextColor =>
      _darkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  static const Color primaryColor = Color(0xFF4F46E5);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // NAMA SISWA
  // ============================================================

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'Siswa';
    }

    final displayName = user.displayName?.trim() ?? '';

    if (displayName.isNotEmpty) {
      return displayName;
    }

    final email = user.email?.trim() ?? '';

    if (email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'Siswa';
  }

  // ============================================================
  // BUKA HALAMAN
  // ============================================================

  void _openPage(String pageType) {
    Widget? page;

    switch (pageType) {
      case 'materi':
        page = const MateriPage();
        break;

      case 'video':
        page = const VideoPage();
        break;

      case 'quiz':
        page = const QuizPage();
        break;

      case 'latihan':
        page = const LatihanPage();
        break;

      case 'simulasi':
        page = const SimulasiPage();
        break;

      case 'ranking':
        page = const RankingPage();
        break;
    }

    if (page == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page!,
      ),
    );
  }

  // ============================================================
  // THEME
  // ============================================================

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _darkMode
              ? 'Mode gelap aktif'
              : 'Mode terang aktif',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomePage(),
              _buildLearningPage(),
              const RankingPage(),
              const ProfilePage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final horizontalPadding = width < 360
              ? 10.0
              : width < 600
                  ? 14.0
                  : 20.0;

          final crossAxisCount = width >= 1200
              ? 4
              : width >= 900
                  ? 3
                  : 2;

          final spacing = width < 600 ? 10.0 : 14.0;

          final cardWidth =
              (width -
                      horizontalPadding * 2 -
                      spacing * (crossAxisCount - 1)) /
                  crossAxisCount;

          final cardHeight =
              (cardWidth * 1.30)
                  .clamp(215.0, 285.0)
                  .toDouble();

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // TOP BAR
              SliverToBoxAdapter(
                child: _buildTopBar(),
              ),

              // WELCOME
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    18,
                    horizontalPadding,
                    28,
                  ),
                  child: _buildWelcomeCard(),
                ),
              ),

              // SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: _buildSectionTitle(
                    'Menu Pembelajaran',
                    'Pilih fitur untuk mulai belajar',
                    Icons.auto_stories_rounded,
                  ),
                ),
              ),

              // CARD
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14,
                  horizontalPadding,
                  30,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = _menus[index];

                      return _AnimatedStudentCard(
                        menu: item,
                        cardColor: cardColor,
                        secondaryTextColor:
                            secondaryTextColor,
                        onTap: () {
                          _openPage(item.pageType);
                        },
                      );
                    },
                    childCount: _menus.length,
                  ),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: cardHeight,
                  ),
                ),
              ),

              // MOTIVATION
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    30,
                  ),
                  child: _buildMotivationCard(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        0,
      ),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.menu_rounded,
            onTap: _showStudentMenu,
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
            icon: _darkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            onTap: _toggleTheme,
          ),

          const SizedBox(width: 8),

          _circleButton(
            icon: Icons.person_outline_rounded,
            onTap: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
        ],
      ),
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
              color: _darkMode
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
                        'Halo, ${_getUserName()}! 👋',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Siap belajar dan mengasah '
                        'kemampuan hari ini?',
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
            color:
                primaryColor.withValues(alpha: .10),
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

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color:
                primaryColor.withValues(alpha: .08),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Text(
            '${_menus.length} menu',
            style: const TextStyle(
              color: primaryColor,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOTIVATION
  // ============================================================

  Widget _buildMotivationCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF312E81),
                Color(0xFF5B4BE0),
                Color(0xFF7C3AED),
              ],
            ),
            borderRadius:
                BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B4BE0)
                    .withValues(alpha: .20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 57,
                height: 57,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: .14),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Color(0xFFFDE68A),
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terus tingkatkan kemampuanmu 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.2,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Lihat ranking dan jadikan '
                      'progresmu sebagai motivasi.',
                      style: TextStyle(
                        color: Color(0xFFE0E7FF),
                        fontSize: 10.3,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 7),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 17,
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
    final learningMenus = _menus
        .where((item) => item.pageType != 'ranking')
        .toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              0,
            ),
            child: _buildLearningHeader(),
          ),
        ),

        SliverPadding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            35,
          ),
          sliver: SliverList.separated(
            itemCount: learningMenus.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 13),
            itemBuilder: (context, index) {
              final item = learningMenus[index];

              return _LearningCard(
                item: item,
                cardColor: cardColor,
                textColor: textColor,
                secondaryTextColor:
                    secondaryTextColor,
                onTap: () {
                  _openPage(item.pageType);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLearningHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F766E),
            Color(0xFF0891B2),
            Color(0xFF2563EB),
          ],
        ),
        borderRadius:
            BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2)
                .withValues(alpha: .20),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: .16),
              borderRadius:
                  BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Pusat Belajar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Belajar dari konsep sampai praktik',
                  style: TextStyle(
                    color: Color(0xD9FFFFFF),
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
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: cardColor,
      surfaceTintColor: Colors.transparent,
      indicatorColor:
          primaryColor.withValues(alpha: .12),
      elevation: 8,
      height: 70,
      labelBehavior:
          NavigationDestinationLabelBehavior
              .alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon:
              Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon:
              Icon(Icons.menu_book_outlined),
          selectedIcon:
              Icon(Icons.menu_book_rounded),
          label: 'Belajar',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.emoji_events_outlined,
          ),
          selectedIcon: Icon(
            Icons.emoji_events_rounded,
          ),
          label: 'Progress',
        ),
        NavigationDestination(
          icon:
              Icon(Icons.person_outline_rounded),
          selectedIcon:
              Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }

  // ============================================================
  // MENU BUTTON
  // ============================================================

  void _showStudentMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardColor,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              5,
              20,
              25,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home_rounded,
                    color: primaryColor,
                  ),
                  title:
                      const Text('Beranda'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF3B82F6),
                  ),
                  title:
                      const Text('Pusat Belajar'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF10B981),
                  ),
                  title:
                      const Text('Profil'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// MODEL MENU
// ================================================================

class _StudentMenu {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final Color color;
  final String imageUrl;
  final String pageType;

  const _StudentMenu({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.color,
    required this.imageUrl,
    required this.pageType,
  });
}

// ================================================================
// ANIMATED CARD
// ================================================================

class _AnimatedStudentCard extends StatefulWidget {
  final _StudentMenu menu;
  final Color cardColor;
  final Color secondaryTextColor;
  final VoidCallback onTap;

  const _AnimatedStudentCard({
    required this.menu,
    required this.cardColor,
    required this.secondaryTextColor,
    required this.onTap,
  });

  @override
  State<_AnimatedStudentCard> createState() =>
      _AnimatedStudentCardState();
}

class _AnimatedStudentCardState
    extends State<_AnimatedStudentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? .965 : 1,
      duration:
          const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });

          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final offset =
                -3.0 * _controller.value;

            return Transform.translate(
              offset: Offset(0, offset),
              child: child,
            );
          },
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    final color = widget.menu.color;

    return Container(
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color:
              color.withValues(alpha: .10),
        ),
        boxShadow: [
          BoxShadow(
            color:
                color.withValues(alpha: .08),
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
                widget.menu.title,
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

          // ICON / ILLUSTRATION
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
                      shape:
                          BoxShape.circle,
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
                      shape:
                          BoxShape.circle,
                      color: color
                          .withValues(
                        alpha: .06,
                      ),
                    ),
                  ),
                ),

               Padding(
  padding: const EdgeInsets.all(12),
  child: Image.network(
    widget.menu.imageUrl,
    width: 78,
    height: 78,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) {
      return Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          widget.menu.icon,
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
                  widget.menu.subtitle,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        widget.secondaryTextColor,
                    fontSize: 9.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 9),

                Container(
                  height: 34,
                  width: 100,
                  decoration:
                      BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(
                            20),
                    boxShadow: [
                      BoxShadow(
                        color: color
                            .withValues(
                          alpha: .20,
                        ),
                        blurRadius: 7,
                        offset:
                            const Offset(
                          0,
                          3,
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Text(
                        widget.menu
                            .buttonText,
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 9.5,
                          fontWeight:
                              FontWeight.w900,
                          letterSpacing: .3,
                        ),
                      ),
                      const SizedBox(
                          width: 4),
                      const Icon(
                        Icons
                            .arrow_forward_rounded,
                        color:
                            Colors.white,
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
    );
  }
}

// ================================================================
// LEARNING CARD
// ================================================================

class _LearningCard extends StatelessWidget {
  final _StudentMenu item;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onTap;

  const _LearningCard({
    required this.item,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(24),
        child: Ink(
          padding:
              const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: item.color
                  .withValues(alpha: .10),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration:
                    BoxDecoration(
                  color: item.color
                      .withValues(alpha: .10),
                  borderRadius:
                      BorderRadius.circular(
                          18),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 30,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                        height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color: item.color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}