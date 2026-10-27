import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'kerjakan_quiz_page.dart';
import 'widgets/siswa_bottom_navigation.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController =
      TextEditingController();

  String _keyword = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    _searchController.addListener(() {
      if (!mounted) return;

      setState(() {
        _keyword =
            _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                SliverToBoxAdapter(
                  child: _buildSearch(),
                ),

                SliverToBoxAdapter(
                  child: _buildInfoBanner(),
                ),

                SliverToBoxAdapter(
                  child: _buildSectionTitle(),
                ),

                _buildQuizList(),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 35),
                ),
              ],
            ),
          ),
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 3,
      ),
);
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFEC4899),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1)
                .withValues(alpha: 0.25),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBackButton(),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz External',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kerjakan quiz dan lihat seberapa jauh pemahamanmu.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      Colors.white.withValues(alpha: 0.16),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color:
                  Colors.white.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color:
                    Colors.white.withValues(alpha: 0.14),
              ),
            ),
            child: const Row(
              children: [
                _HeaderIcon(),

                SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiz external untuk menguji pemahamanmu setelah belajar.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Baca materi terlebih dahulu sebelum mengerjakan quiz.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.35,
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
  // BACK BUTTON
  // ============================================================

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
        },
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color:
                Colors.white.withValues(alpha: 0.16),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari quiz...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF6366F1),
            ),
            suffixIcon:
                _keyword.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                      )
                    : Container(
                        margin:
                            const EdgeInsets.all(8),
                        decoration:
                            BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO BANNER
  // ============================================================

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        4,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF7ED),
            Color(0xFFFFF1F2),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFE4E6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFFF97316),
                  Color(0xFFEF4444),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Belajar',
                  style: TextStyle(
                    color: Color(0xFF9A3412),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Baca materi terlebih dahulu sebelum mengerjakan quiz.',
                  style: TextStyle(
                    color: Color(0xFF7C2D12),
                    fontSize: 11,
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
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        26,
        18,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz Tersedia',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pilih quiz external dan mulai tantanganmu',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
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
  // QUIZ LIST
  // ============================================================

  Widget _buildQuizList() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('quiz')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(35),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: _buildStateCard(
              icon: Icons.error_outline_rounded,
              title: 'Gagal memuat quiz',
              subtitle:
                  'Terjadi kesalahan saat mengambil data quiz.',
              color: const Color(0xFFEF4444),
            ),
          );
        }

        final docs =
            snapshot.data?.docs ?? [];

        final filteredQuiz =
            docs.where((doc) {
          final data = doc.data();

          final judul =
              (data['judul'] ?? '')
                  .toString()
                  .toLowerCase();

          final pertanyaan =
              (data['pertanyaan'] ?? '')
                  .toString()
                  .toLowerCase();

          return judul.contains(_keyword) ||
              pertanyaan.contains(_keyword);
        }).toList();

        if (filteredQuiz.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildStateCard(
              icon: _keyword.isNotEmpty
                  ? Icons.search_off_rounded
                  : Icons.quiz_outlined,
              title: _keyword.isNotEmpty
                  ? 'Quiz tidak ditemukan'
                  : 'Belum ada quiz',
              subtitle: _keyword.isNotEmpty
                  ? 'Coba gunakan kata kunci lainnya.'
                  : 'Quiz akan muncul setelah guru membuat soal.',
              color: _keyword.isNotEmpty
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF6366F1),
            ),
          );
        }

        return SliverPadding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          sliver: SliverList(
            delegate:
                SliverChildBuilderDelegate(
              (context, index) {
                final item =
                    filteredQuiz[index];

                final data =
                    item.data();

                final judul =
                    data['judul']
                            ?.toString() ??
                        'Quiz External';

                final pertanyaan =
                    data['pertanyaan']
                            ?.toString() ??
                        'Uji kemampuanmu melalui quiz ini.';

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: _QuizCard(
                    title: judul,
                    question:
                        pertanyaan,
                    index: index,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              KerjakanQuizPage(
                            quizId: item.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount:
                  filteredQuiz.length,
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // STATE CARD
  // ============================================================

  Widget _buildStateCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        10,
      ),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color:
                  color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// HEADER ICON
// ================================================================

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.emoji_events_rounded,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}

// ================================================================
// QUIZ CARD
// ================================================================

class _QuizCard extends StatefulWidget {
  final String title;
  final String question;
  final int index;
  final VoidCallback onTap;

  const _QuizCard({
    required this.title,
    required this.question,
    required this.index,
    required this.onTap,
  });

  @override
  State<_QuizCard> createState() =>
      _QuizCardState();
}

class _QuizCardState extends State<_QuizCard> {
  bool _pressed = false;

  final List<List<Color>> _gradients = const [
    [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
    ],
    [
      Color(0xFFEC4899),
      Color(0xFFF43F5E),
    ],
    [
      Color(0xFF0EA5E9),
      Color(0xFF2563EB),
    ],
    [
      Color(0xFF10B981),
      Color(0xFF14B8A6),
    ],
    [
      Color(0xFFF59E0B),
      Color(0xFFF97316),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final gradient =
        _gradients[
            widget.index %
                _gradients.length];

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration:
          const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
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
          },
          borderRadius:
              BorderRadius.circular(25),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: gradient.first
                      .withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildTop(gradient),

                  const SizedBox(height: 17),

                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.question,
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildBottom(gradient),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP
  // ============================================================

  Widget _buildTop(
      List<Color> gradient) {
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradient.first
                    .withValues(alpha: 0.22),
                blurRadius: 12,
                offset:
                    const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.quiz_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: gradient.first
                      .withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(9),
                ),
                child: Text(
                  'QUIZ',
                  style: TextStyle(
                    color: gradient.first,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              const Spacer(),

              Icon(
                Icons.more_horiz_rounded,
                color:
                    Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM
  // ============================================================

  Widget _buildBottom(
      List<Color> gradient) {
    return Row(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color:
                const Color(0xFFF3F4F6),
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons.school_rounded,
                size: 15,
                color:
                    Colors.grey.shade600,
              ),
              const SizedBox(width: 5),
              Text(
                'Latihan',
                style: TextStyle(
                  color:
                      Colors.grey.shade700,
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient:
                LinearGradient(
              colors: gradient,
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                'Mulai Quiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}