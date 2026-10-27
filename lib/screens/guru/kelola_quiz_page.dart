import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/quiz_service.dart';
import 'edit_quiz_page.dart';
import 'tambah_quiz_page.dart';
import 'guru_dashboard.dart';
import 'kelola_materi_page.dart';
import 'kelola_video_page.dart';

class KelolaQuizPage extends StatefulWidget {
  const KelolaQuizPage({super.key});

  @override
  State<KelolaQuizPage> createState() => _KelolaQuizPageState();
}

class _KelolaQuizPageState extends State<KelolaQuizPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color blue = Color(0xFF2563EB);
  static const Color red = Color(0xFFEF4444);
  static const Color green = Color(0xFF16A34A);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // NAVIGASI
  // ============================================================

  void _openDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const GuruDashboard(),
      ),
    );
  }

  void _openMateri() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const KelolaMateriPage(),
      ),
    );
  }

  void _openVideo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const KelolaVideoPage(),
      ),
    );
  }

  // ============================================================
  // TAMBAH QUIZ
  // ============================================================

  Future<void> _tambahQuiz() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahQuizPage(),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ============================================================
  // EDIT QUIZ
  // ============================================================

  Future<void> _editQuiz(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditQuizPage(
          quizId: id,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ============================================================
  // HAPUS QUIZ
  // ============================================================

  Future<void> _hapusQuiz(
    String id,
    String judul,
  ) async {
    final theme = Theme.of(context);

    final hasil = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor:
              theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(28),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration:
                      BoxDecoration(
                    color:
                        red.withValues(
                      alpha: 0.10,
                    ),
                    shape:
                        BoxShape.circle,
                  ),
                  child:
                      const Icon(
                    Icons
                        .delete_forever_rounded,
                    color: red,
                    size: 35,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Text(
                  'Hapus Quiz?',
                  style: TextStyle(
                    color: theme
                        .colorScheme
                        .onSurface,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  'Quiz "$judul" akan dihapus '
                  'secara permanen.\n\n'
                  'Tindakan ini tidak dapat '
                  'dibatalkan.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: theme
                        .colorScheme
                        .onSurface
                        .withValues(
                      alpha: 0.60,
                    ),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            false,
                          );
                        },
                        style:
                            OutlinedButton
                                .styleFrom(
                          minimumSize:
                              const Size
                                  .fromHeight(
                            50,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),
                        ),
                        child:
                            const Text(
                          'Batal',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child:
                          FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            true,
                          );
                        },
                        style:
                            FilledButton
                                .styleFrom(
                          backgroundColor:
                              red,
                          foregroundColor:
                              Colors.white,
                          minimumSize:
                              const Size
                                  .fromHeight(
                            50,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),
                        ),
                        child:
                            const Text(
                          'Hapus',
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (hasil != true) return;

    try {
      await QuizService()
          .hapusQuiz(id);

      if (!mounted) return;

      _showMessage(
        'Quiz berhasil dihapus.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal menghapus quiz: $e',
        error: true,
      );
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool error = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(16),
          backgroundColor:
              error ? red : green,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              15,
            ),
          ),
          content: Row(
            children: [
              Icon(
                error
                    ? Icons
                        .error_outline_rounded
                    : Icons
                        .check_circle_rounded,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  message,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    final theme =
        Theme.of(context);

    final dark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      decoration:
          BoxDecoration(
        color:
            theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme
                .dividerColor
                .withValues(
              alpha:
                  dark ? 0.12 : 0.06,
            ),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha:
                  dark ? 0.22 : 0.07,
            ),
            blurRadius: 22,
            offset:
                const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(
            8,
            8,
            8,
            8,
          ),
          child: Row(
            children: [
              Expanded(
                child: _navItem(
                  icon:
                      Icons.dashboard_rounded,
                  label:
                      'Dashboard',
                  color:
                      const Color(
                    0xFF6366F1,
                  ),
                  active: false,
                  onTap:
                      _openDashboard,
                ),
              ),

              Expanded(
                child: _navItem(
                  icon:
                      Icons.menu_book_rounded,
                  label:
                      'Materi',
                  color: blue,
                  active: false,
                  onTap:
                      _openMateri,
                ),
              ),

              Expanded(
                child: _navItem(
                  icon:
                      Icons
                          .play_circle_fill_rounded,
                  label:
                      'Video',
                  color: red,
                  active: false,
                  onTap:
                      _openVideo,
                ),
              ),

              Expanded(
                child: _navItem(
                  icon:
                      Icons.quiz_rounded,
                  label:
                      'Quiz',
                  color:
                      primary,
                  active: true,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required Color color,
    required bool active,
    required VoidCallback onTap,
  }) {
    final theme =
        Theme.of(context);

    final inactive =
        theme.colorScheme.onSurface
            .withValues(
      alpha: 0.48,
    );

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(
        17,
      ),
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),
        margin:
            const EdgeInsets
                .symmetric(
          horizontal: 3,
        ),
        padding:
            const EdgeInsets
                .symmetric(
          vertical: 5,
        ),
        decoration:
            BoxDecoration(
          color: active
              ? color.withValues(
                  alpha: 0.09,
                )
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            17,
          ),
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width:
                  active ? 48 : 42,
              height:
                  active ? 32 : 30,
              decoration:
                  BoxDecoration(
                color: active
                    ? color.withValues(
                        alpha: 0.12,
                      )
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Icon(
                icon,
                size:
                    active ? 22 : 21,
                color:
                    active
                        ? color
                        : inactive,
              ),
            ),

            const SizedBox(
              height: 3,
            ),

            Text(
              label,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  TextStyle(
                color:
                    active
                        ? color
                        : inactive,
                fontSize: 10,
                fontWeight:
                    active
                        ? FontWeight
                            .w900
                        : FontWeight
                            .w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final dark =
        theme.brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor: dark
          ? const Color(
              0xFF0B1120,
            )
          : const Color(
              0xFFF6F8FC,
            ),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor:
            Colors.transparent,
        surfaceTintColor:
            Colors.transparent,

        titleSpacing: 18,

        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Kelola Quiz',
              style:
                  TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Kelola quiz pembelajaran siswa',
              style:
                  TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin:
                const EdgeInsets.only(
              right: 14,
              top: 8,
              bottom: 8,
            ),
            decoration:
                BoxDecoration(
              color:
                  theme.colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              border: Border.all(
                color: theme
                    .dividerColor
                    .withValues(
                  alpha: 0.08,
                ),
              ),
            ),
            child:
                IconButton(
              onPressed:
                  _tambahQuiz,
              tooltip:
                  'Tambah Quiz',
              icon:
                  const Icon(
                Icons.add_rounded,
                color: primary,
              ),
            ),
          ),
        ],
      ),

      // ========================================================
      // FAB
      // ========================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            _tambahQuiz,
        elevation: 7,
        backgroundColor:
            primary,
        foregroundColor:
            Colors.white,
        icon:
            const Icon(
          Icons.add_rounded,
        ),
        label:
            const Text(
          'Tambah Quiz',
          style:
              TextStyle(
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar:
          _buildBottomNavigation(),

      // ========================================================
      // FIRESTORE
      // ========================================================

      body: StreamBuilder<
          QuerySnapshot<
              Map<String, dynamic>>>(
        stream:
            FirebaseFirestore
                .instance
                .collection(
                  'quiz',
                )
                .orderBy(
                  'createdAt',
                  descending:
                      true,
                )
                .snapshots(),

        builder: (
          context,
          snapshot,
        ) {
          // ====================================================
          // LOADING
          // ====================================================

          if (snapshot
                  .connectionState ==
              ConnectionState
                  .waiting) {
            return const _LoadingView();
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (snapshot.hasError) {
            return _ErrorView(
              error: snapshot
                  .error
                  .toString(),
            );
          }

          // ====================================================
          // DATA FIRESTORE
          // ====================================================

          final docs =
              snapshot.data?.docs ??
                  <QueryDocumentSnapshot<
                      Map<String,
                          dynamic>>>[];

          // ====================================================
          // SEARCH
          // ====================================================

          final filteredDocs =
              docs.where((doc) {
            final data =
                doc.data();

            final judul =
                (data['judul'] ??
                        '')
                    .toString()
                    .toLowerCase();

            final deskripsi =
                (data['deskripsi'] ??
                        '')
                    .toString()
                    .toLowerCase();

            return judul.contains(
                  _searchQuery,
                ) ||
                deskripsi.contains(
                  _searchQuery,
                );
          }).toList();

          // ====================================================
          // LIST
          // ====================================================

          return RefreshIndicator(
            color: primary,

            onRefresh: () async {
              setState(() {});
              await Future.delayed(
                const Duration(
                  milliseconds: 300,
                ),
              );
            },

            child:
                CustomScrollView(
              physics:
                  const BouncingScrollPhysics(
                parent:
                    AlwaysScrollableScrollPhysics(),
              ),

              slivers: [
                // HEADER
                SliverToBoxAdapter(
                  child:
                      _buildHeader(
                    docs.length,
                  ),
                ),

                // SEARCH
                SliverToBoxAdapter(
                  child:
                      _buildSearch(),
                ),

                // DATA KOSONG
                if (docs.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody:
                        false,
                    child:
                        _EmptyQuizView(),
                  )

                // SEARCH KOSONG
                else if (
                    filteredDocs.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody:
                        false,
                    child:
                        _NoSearchResultView(),
                  )

                // DATA ADA
                else
                  _buildQuizList(
                    filteredDocs,
                  ),

                // SPACE BAWAH
                const SliverPadding(
                  padding:
                      EdgeInsets.only(
                    bottom: 125,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    int totalQuiz,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16,
      ),
      child: Container(
        width:
            double.infinity,
        padding:
            const EdgeInsets.all(
          21,
        ),
        decoration:
            BoxDecoration(
          gradient:
              const LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              primary,
              primaryDark,
              blue,
            ],
          ),
          borderRadius:
              BorderRadius.circular(
            28,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  primary.withValues(
                alpha: 0.25,
              ),
              blurRadius: 24,
              offset:
                  const Offset(
                0,
                11,
              ),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: -45,
              child:
                  Container(
                width: 145,
                height: 145,
                decoration:
                    BoxDecoration(
                  color: Colors
                      .white
                      .withValues(
                    alpha: 0.07,
                  ),
                  shape:
                      BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              right: 45,
              bottom: -65,
              child:
                  Container(
                width: 115,
                height: 115,
                decoration:
                    BoxDecoration(
                  color: Colors
                      .white
                      .withValues(
                    alpha: 0.06,
                  ),
                  shape:
                      BoxShape.circle,
                ),
              ),
            ),

            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .white
                        .withValues(
                      alpha: 0.16,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      19,
                    ),
                  ),
                  child:
                      const Icon(
                    Icons
                        .quiz_rounded,
                    color:
                        Colors.white,
                    size: 31,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child:
                      Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'Quiz Pembelajaran',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              18,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        'Kelola evaluasi dan latihan siswa',
                        maxLines:
                            2,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            TextStyle(
                          color: Colors
                              .white
                              .withValues(
                            alpha:
                                0.78,
                          ),
                          fontSize:
                              11,
                          height:
                              1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        13,
                    vertical:
                        10,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .white
                        .withValues(
                      alpha: 0.14,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),
                  ),
                  child:
                      Column(
                    children: [
                      Text(
                        '$totalQuiz',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              21,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),
                      Text(
                        'Quiz',
                        style:
                            TextStyle(
                          color: Colors
                              .white
                              .withValues(
                            alpha:
                                0.75,
                          ),
                          fontSize:
                              9,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    final theme =
        Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16,
      ),
      child: Container(
        decoration:
            BoxDecoration(
          color: theme
              .colorScheme
              .surface,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: Border.all(
            color: theme
                .dividerColor
                .withValues(
              alpha: 0.07,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha:
                    theme.brightness ==
                            Brightness.dark
                        ? 0.10
                        : 0.035,
              ),
              blurRadius: 18,
              offset:
                  const Offset(
                0,
                7,
              ),
            ),
          ],
        ),
        child:
            TextField(
          controller:
              _searchController,

          onChanged:
              (value) {
            setState(() {
              _searchQuery =
                  value
                      .trim()
                      .toLowerCase();
            });
          },

          decoration:
              InputDecoration(
            hintText:
                'Cari judul atau deskripsi quiz...',

            hintStyle:
                TextStyle(
              fontSize: 12,
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(
                alpha: 0.42,
              ),
            ),

            prefixIcon:
                Container(
              margin:
                  const EdgeInsets
                      .all(8),
              decoration:
                  BoxDecoration(
                color:
                    primary.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
              ),
              child:
                  const Icon(
                Icons
                    .search_rounded,
                color:
                    primary,
              ),
            ),

            suffixIcon:
                _searchQuery
                        .isNotEmpty
                    ? IconButton(
                        onPressed:
                            () {
                          _searchController
                              .clear();

                          setState(
                            () {
                              _searchQuery =
                                  '';
                            },
                          );
                        },
                        icon:
                            const Icon(
                          Icons
                              .close_rounded,
                        ),
                      )
                    : null,

            border:
                InputBorder.none,

            contentPadding:
                const EdgeInsets
                    .symmetric(
              vertical: 18,
              horizontal: 8,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LIST QUIZ
  // ============================================================

  Widget _buildQuizList(
    List<QueryDocumentSnapshot<
            Map<String, dynamic>>>
        docs,
  ) {
    return SliverPadding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 16,
      ),
      sliver:
          SliverList(
        delegate:
            SliverChildBuilderDelegate(
          (context, index) {
            final doc =
                docs[index];

            final data =
                doc.data();

            return Padding(
              padding:
                  const EdgeInsets
                      .only(
                bottom: 16,
              ),
              child:
                  _QuizCard(
                id: doc.id,
                judul:
                    (data['judul'] ??
                            '')
                        .toString(),
                deskripsi:
                    (data['deskripsi'] ??
                            '')
                        .toString(),
                index: index,
                onEdit: () {
                  _editQuiz(
                    doc.id,
                  );
                },
                onDelete: () {
                  _hapusQuiz(
                    doc.id,
                    (data['judul'] ??
                            'Quiz')
                        .toString(),
                  );
                },
              ),
            );
          },
          childCount:
              docs.length,
        ),
      ),
    );
  }
}

// ================================================================
// QUIZ CARD
// ================================================================

class _QuizCard
    extends StatelessWidget {
  final String id;
  final String judul;
  final String deskripsi;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuizCard({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(
      BuildContext context) {
    final theme =
        Theme.of(context);

    final gradients =
        <List<Color>>[
      const [
        Color(0xFF7C3AED),
        Color(0xFF4F46E5),
      ],
      const [
        Color(0xFF2563EB),
        Color(0xFF0891B2),
      ],
      const [
        Color(0xFFDB2777),
        Color(0xFF9333EA),
      ],
      const [
        Color(0xFFEA580C),
        Color(0xFFDC2626),
      ],
    ];

    final gradient =
        gradients[
            index %
                gradients.length];

    return Container(
      decoration:
          BoxDecoration(
        color: theme
            .colorScheme
            .surface,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color: theme
              .dividerColor
              .withValues(
            alpha: 0.08,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.045,
            ),
            blurRadius: 20,
            offset:
                const Offset(
              0,
              8,
            ),
          ),
        ],
      ),
      child:
          ClipRRect(
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        child:
            Column(
          children: [
            Container(
              height: 105,
              width:
                  double.infinity,
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  colors:
                      gradient,
                  begin:
                      Alignment.topLeft,
                  end:
                      Alignment.bottomRight,
                ),
              ),
              child:
                  Stack(
                children: [
                  Positioned(
                    right: -25,
                    top: -35,
                    child:
                        Container(
                      width: 115,
                      height: 115,
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .white
                            .withValues(
                          alpha:
                              0.08,
                        ),
                        shape:
                            BoxShape
                                .circle,
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets
                            .all(
                      16,
                    ),
                    child:
                        Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withValues(
                              alpha:
                                  0.17,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              17,
                            ),
                          ),
                          child:
                              const Icon(
                            Icons
                                .quiz_rounded,
                            color:
                                Colors.white,
                            size: 27,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child:
                              Text(
                            'QUIZ #${index + 1}',
                            style:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha:
                                    0.82,
                              ),
                              fontSize:
                                  10,
                              fontWeight:
                                  FontWeight
                                      .w900,
                              letterSpacing:
                                  1,
                            ),
                          ),
                        ),

                        PopupMenuButton<
                            String>(
                          tooltip:
                              'Menu',
                          icon:
                              const Icon(
                            Icons
                                .more_horiz_rounded,
                            color:
                                Colors.white,
                          ),
                          color: theme
                              .colorScheme
                              .surface,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                          ),
                          onSelected:
                              (value) {
                            if (value ==
                                'edit') {
                              onEdit();
                            } else if (value ==
                                'hapus') {
                              onDelete();
                            }
                          },
                          itemBuilder:
                              (_) =>
                                  const [
                            PopupMenuItem(
                              value:
                                  'edit',
                              child:
                                  Row(
                                children: [
                                  Icon(
                                    Icons
                                        .edit_rounded,
                                    size:
                                        19,
                                  ),
                                  SizedBox(
                                    width:
                                        10,
                                  ),
                                  Text(
                                    'Edit',
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value:
                                  'hapus',
                              child:
                                  Row(
                                children: [
                                  Icon(
                                    Icons
                                        .delete_outline_rounded,
                                    color:
                                        Colors.red,
                                    size:
                                        19,
                                  ),
                                  SizedBox(
                                    width:
                                        10,
                                  ),
                                  Text(
                                    'Hapus',
                                  ),
                                ],
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

            Padding(
              padding:
                  const EdgeInsets
                      .all(
                16,
              ),
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    judul.isEmpty
                        ? 'Tanpa Judul'
                        : judul,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color: theme
                          .colorScheme
                          .onSurface,
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w900,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    deskripsi
                            .isEmpty
                        ? 'Tidak ada deskripsi quiz.'
                        : deskripsi,
                    maxLines: 4,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color: theme
                          .colorScheme
                          .onSurface
                          .withValues(
                        alpha:
                            0.52,
                      ),
                      fontSize: 11.5,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child:
                            OutlinedButton
                                .icon(
                          onPressed:
                              onEdit,
                          icon:
                              const Icon(
                            Icons
                                .edit_rounded,
                            size:
                                17,
                          ),
                          label:
                              const Text(
                            'Edit',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                          style:
                              OutlinedButton
                                  .styleFrom(
                            minimumSize:
                                const Size
                                    .fromHeight(
                              45,
                            ),
                            foregroundColor:
                                const Color(
                              0xFF7C3AED,
                            ),
                            side:
                                BorderSide(
                              color:
                                  const Color(
                                0xFF7C3AED,
                              ).withValues(
                                alpha:
                                    0.25,
                              ),
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 9,
                      ),

                      SizedBox(
                        width: 48,
                        height: 45,
                        child:
                            IconButton(
                          onPressed:
                              onDelete,
                          tooltip:
                              'Hapus',
                          style:
                              IconButton
                                  .styleFrom(
                            backgroundColor:
                                Colors.red
                                    .withValues(
                              alpha:
                                  0.08,
                            ),
                            foregroundColor:
                                Colors.red,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                          ),
                          icon:
                              const Icon(
                            Icons
                                .delete_outline_rounded,
                            size:
                                20,
                          ),
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
}

// ================================================================
// LOADING
// ================================================================

class _LoadingView
    extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(
      BuildContext context) {
    return const Center(
      child:
          Column(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child:
                CircularProgressIndicator(
              strokeWidth: 3,
              color:
                  Color(0xFF7C3AED),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            'Memuat quiz...',
            style:
                TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// EMPTY
// ================================================================

class _EmptyQuizView
    extends StatelessWidget {
  const _EmptyQuizView();

  @override
  Widget build(
      BuildContext context) {
    final theme =
        Theme.of(context);

    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets
                .all(
          30,
        ),
        child:
            Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration:
                  BoxDecoration(
                color: const Color(
                  0xFF7C3AED,
                ).withValues(
                  alpha: 0.09,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .quiz_rounded,
                size: 50,
                color: Color(
                  0xFF7C3AED,
                ),
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            Text(
              'Belum Ada Quiz',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color: theme
                    .colorScheme
                    .onSurface,
                fontSize: 21,
                fontWeight:
                    FontWeight
                        .w900,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Belum ada quiz pembelajaran '
              'yang dibuat.\n'
              'Tambahkan quiz untuk '
              'mulai mengevaluasi siswa.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.50,
                ),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// SEARCH EMPTY
// ================================================================

class _NoSearchResultView
    extends StatelessWidget {
  const _NoSearchResultView();

  @override
  Widget build(
      BuildContext context) {
    final theme =
        Theme.of(context);

    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets
                .all(
          30,
        ),
        child:
            Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration:
                  BoxDecoration(
                color: const Color(
                  0xFF7C3AED,
                ).withValues(
                  alpha: 0.08,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .search_off_rounded,
                size: 40,
                color: Color(
                  0xFF7C3AED,
                ),
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              'Quiz Tidak Ditemukan',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight
                        .w900,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),

            const SizedBox(
              height: 7,
            ),

            Text(
              'Coba gunakan kata kunci '
              'pencarian lain.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// ERROR
// ================================================================

class _ErrorView
    extends StatelessWidget {
  final String error;

  const _ErrorView({
    required this.error,
  });

  @override
  Widget build(
      BuildContext context) {
    final theme =
        Theme.of(context);

    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets
                .all(
          30,
        ),
        child:
            Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration:
                  BoxDecoration(
                color: Colors.red
                    .withValues(
                  alpha: 0.10,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .cloud_off_rounded,
                color:
                    Colors.red,
                size: 42,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              'Gagal Memuat Quiz',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color: theme
                    .colorScheme
                    .onSurface,
                fontSize: 19,
                fontWeight:
                    FontWeight
                        .w900,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              error,
              textAlign:
                  TextAlign.center,
              maxLines: 5,
              overflow:
                  TextOverflow
                      .ellipsis,
              style:
                  TextStyle(
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.50,
                ),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}