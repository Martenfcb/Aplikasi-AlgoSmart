import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'tambah_cp_atp_page.dart';

// ============================================================
// COLORS
// ============================================================

const Color _primary = Color(0xFF6366F1);
const Color _primaryDark = Color(0xFF4F46E5);
const Color _violet = Color(0xFF7C3AED);
const Color _blue = Color(0xFF2563EB);
const Color _red = Color(0xFFEF4444);
const Color _green = Color(0xFF10B981);
const Color _orange = Color(0xFFF59E0B);

const Color _lightBackground = Color(0xFFF6F7FB);
const Color _darkBackground = Color(0xFF080D1A);

const Color _lightText = Color(0xFF172033);
const Color _lightSubtitle = Color(0xFF64748B);

const Color _darkText = Colors.white;
const Color _darkSubtitle = Color(0xFF94A3B8);

// ============================================================
// PAGE
// ============================================================

class KelolaCPATPPage extends StatefulWidget {
  const KelolaCPATPPage({
    super.key,
  });

  @override
  State<KelolaCPATPPage> createState() =>
      _KelolaCPATPPageState();
}

class _KelolaCPATPPageState
    extends State<KelolaCPATPPage> {
  // ==========================================================
  // CONTROLLER
  // ==========================================================

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  String _filterKategori = 'Semua';

  // ==========================================================
  // THEME
  // ==========================================================

  bool get isDark =>
      Theme.of(context).brightness ==
      Brightness.dark;

  Color get backgroundColor =>
      isDark
          ? _darkBackground
          : _lightBackground;

  Color get cardColor =>
      isDark
          ? const Color(0xFF111827)
          : Colors.white;

  Color get textColor =>
      isDark
          ? _darkText
          : _lightText;

  Color get subtitleColor =>
      isDark
          ? _darkSubtitle
          : _lightSubtitle;

  Color get borderColor =>
      isDark
          ? Colors.white.withValues(alpha: 0.07)
          : const Color(0xFFE5E7EB);

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // TAMBAH CP ATP
  // ==========================================================

  Future<void> _tambahData() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const TambahCPATPPage(),
      ),
    );
  }

  // ==========================================================
  // HAPUS DATA
  // ==========================================================

  Future<void> _hapusData({
    required String id,
    required String judul,
  }) async {
    final hasil =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              Theme.of(dialogContext)
                  .colorScheme
                  .surface,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(26),
          ),
          titlePadding:
              const EdgeInsets.fromLTRB(
            22,
            22,
            22,
            8,
          ),
          contentPadding:
              const EdgeInsets.fromLTRB(
            22,
            8,
            22,
            10,
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            18,
            6,
            18,
            18,
          ),
          title: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(
                  color: _red.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: _red,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  'Hapus Data?',
                  style: TextStyle(
                    color: Theme.of(
                      dialogContext,
                    )
                        .colorScheme
                        .onSurface,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Data "$judul" akan dihapus '
            'secara permanen.\n\n'
            'Tindakan ini tidak dapat '
            'dibatalkan.',
            style: TextStyle(
              color: Theme.of(
                dialogContext,
              )
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.62),
              height: 1.5,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Batal',
              ),
            ),
            const SizedBox(width: 6),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  FilledButton.styleFrom(
                backgroundColor: _red,
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
              ),
              label: const Text(
                'Hapus',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (hasil != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('cp_atp')
          .doc(id)
          .delete();

      if (!mounted) return;

      _showMessage(
        'Data CP & ATP berhasil dihapus.',
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      _showMessage(
        e.message ??
            'Gagal menghapus data.',
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan saat menghapus data.',
        isError: true,
      );
    }
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(
    String message, {
    bool isError = false,
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
              isError
                  ? _red
                  : _green,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style:
                      const TextStyle(
                    color: Colors.white,
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

  // ==========================================================
  // SEARCH
  // ==========================================================

  bool _sesuaiFilter(
    Map<String, dynamic> data,
  ) {
    final judul =
        (data['judul'] ?? '')
            .toString()
            .trim()
            .toLowerCase();

    final isi =
        (data['isi'] ?? '')
            .toString()
            .trim()
            .toLowerCase();

    final kategori =
        (data['kategori'] ?? '')
            .toString()
            .trim()
            .toLowerCase();

    final keyword =
        _searchQuery
            .trim()
            .toLowerCase();

    final cocokSearch =
        keyword.isEmpty ||
        judul.contains(keyword) ||
        isi.contains(keyword) ||
        kategori.contains(keyword);

    final cocokKategori =
        _filterKategori == 'Semua' ||
        kategori ==
            _filterKategori
                .toLowerCase();

    return cocokSearch &&
        cocokKategori;
  }

  // ==========================================================
  // FORMAT TANGGAL
  // ==========================================================

  String _formatTanggal(
    dynamic value,
  ) {
    if (value is Timestamp) {
      final date =
          value.toDate();

      final day = date.day
          .toString()
          .padLeft(2, '0');

      final month = date.month
          .toString()
          .padLeft(2, '0');

      final year =
          date.year.toString();

      return '$day/$month/$year';
    }

    if (value is DateTime) {
      final day = value.day
          .toString()
          .padLeft(2, '0');

      final month = value.month
          .toString()
          .padLeft(2, '0');

      final year =
          value.year.toString();

      return '$day/$month/$year';
    }

    return 'Tanggal belum tersedia';
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor:
            backgroundColor,
        surfaceTintColor:
            Colors.transparent,
        centerTitle: false,
        titleSpacing: 18,
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Kelola CP & ATP',
              style: TextStyle(
                color: textColor,
                fontSize: 21,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Capaian Pembelajaran & Alur Tujuan',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 10.5,
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
              color: cardColor,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: IconButton(
              tooltip:
                  'Tambah CP & ATP',
              onPressed: _tambahData,
              icon: const Icon(
                Icons.add_rounded,
                color: _primary,
              ),
            ),
          ),
        ],
      ),

      // ========================================================
      // FLOATING BUTTON
      // ========================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _tambahData,
        backgroundColor:
            _primary,
        foregroundColor:
            Colors.white,
        elevation: 7,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Tambah CP & ATP',
          style: TextStyle(
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
      // BODY
      // ========================================================

      body: StreamBuilder<
          QuerySnapshot<
              Map<String, dynamic>>>(
        stream:
            FirebaseFirestore
                .instance
                .collection('cp_atp')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),

        builder:
            (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const _LoadingView();
          }

          if (snapshot.hasError) {
            return _ErrorView(
              error: snapshot.error
                  .toString(),
              onRetry: () {
                setState(() {});
              },
            );
          }

          final docs =
              snapshot.data?.docs ??
                  [];

          final filteredDocs =
              docs.where(
            (doc) {
              return _sesuaiFilter(
                doc.data(),
              );
            },
          ).toList();

          return RefreshIndicator(
            color: _primary,
            onRefresh: () async {
              setState(() {});
              await Future.delayed(
                const Duration(
                  milliseconds: 400,
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
                // ==================================================
                // HEADER
                // ==================================================

                SliverToBoxAdapter(
                  child:
                      _buildHeader(
                    docs.length,
                  ),
                ),

                // ==================================================
                // SEARCH
                // ==================================================

                SliverToBoxAdapter(
                  child:
                      _buildSearch(),
                ),

                // ==================================================
                // FILTER
                // ==================================================

                SliverToBoxAdapter(
                  child:
                      _buildFilter(),
                ),

                // ==================================================
                // EMPTY
                // ==================================================

                if (docs.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody:
                        false,
                    child:
                        _EmptyView(),
                  )

                // ==================================================
                // SEARCH EMPTY
                // ==================================================

                else if (
                    filteredDocs.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody:
                        false,
                    child:
                        _NoSearchView(),
                  )

                // ==================================================
                // LIST
                // ==================================================

                else
                  SliverPadding(
                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      16,
                      2,
                      16,
                      120,
                    ),
                    sliver:
                        SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (
                          context,
                          index,
                        ) {
                          final doc =
                              filteredDocs[
                                  index];

                          return Padding(
                            padding:
                                const EdgeInsets
                                    .only(
                              bottom: 14,
                            ),
                            child:
                                _CPATPCard(
                              id: doc.id,
                              data:
                                  doc.data(),
                              index:
                                  index,
                              onDelete:
                                  () {
                                final judul =
                                    (doc.data()['judul'] ??
                                            'Data CP & ATP')
                                        .toString();

                                _hapusData(
                                  id: doc.id,
                                  judul:
                                      judul,
                                );
                              },
                            ),
                          );
                        },
                        childCount:
                            filteredDocs
                                .length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(
    int totalData,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        15,
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(21),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              _primary,
              _primaryDark,
              _violet,
            ],
          ),
          borderRadius:
              BorderRadius.circular(
            27,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  _primary.withValues(
                alpha: 0.24,
              ),
              blurRadius: 25,
              offset:
                  const Offset(0, 11),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -45,
              child: Container(
                width: 135,
                height: 135,
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withValues(
                    alpha: 0.07,
                  ),
                  shape:
                      BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -60,
              child: Container(
                width: 105,
                height: 105,
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
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
                  width: 62,
                  height: 62,
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white
                            .withValues(
                      alpha: 0.15,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      19,
                    ),
                    border:
                        Border.all(
                      color:
                          Colors.white
                              .withValues(
                        alpha: 0.17,
                      ),
                    ),
                  ),
                  child:
                      const Icon(
                    Icons
                        .account_tree_rounded,
                    color:
                        Colors.white,
                    size: 31,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'CP & ATP',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize: 19,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Kelola capaian pembelajaran '
                        'dan alur tujuan pembelajaran.',
                        maxLines: 2,
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
                          fontSize: 10.5,
                          height: 1.4,
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
                    horizontal: 13,
                    vertical: 10,
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
                  child: Column(
                    children: [
                      Text(
                        '$totalData',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 21,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),
                      Text(
                        'Data',
                        style:
                            TextStyle(
                          color: Colors
                              .white
                              .withValues(
                            alpha:
                                0.72,
                          ),
                          fontSize: 9,
                          fontWeight:
                              FontWeight
                                  .w600,
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

  // ==========================================================
  // SEARCH
  // ==========================================================

  Widget _buildSearch() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        12,
      ),
      child: Container(
        decoration:
            BoxDecoration(
          color: cardColor,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: Border.all(
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha:
                    isDark
                        ? 0.10
                        : 0.035,
              ),
              blurRadius: 18,
              offset:
                  const Offset(0, 7),
            ),
          ],
        ),
        child: TextField(
          controller:
              _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery =
                  value;
            });
          },
          style: TextStyle(
            color: textColor,
            fontSize: 13,
          ),
          decoration:
              InputDecoration(
            hintText:
                'Cari CP, ATP, kategori...',
            hintStyle:
                TextStyle(
              color:
                  subtitleColor
                      .withValues(
                alpha: 0.65,
              ),
              fontSize: 12,
            ),
            prefixIcon:
                Container(
              margin:
                  const EdgeInsets
                      .all(8),
              decoration:
                  BoxDecoration(
                color:
                    _primary.withValues(
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
                    _primary,
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

                          setState(() {
                            _searchQuery =
                                '';
                          });
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
              vertical: 17,
              horizontal: 8,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // FILTER
  // ==========================================================

  Widget _buildFilter() {
    return SizedBox(
      height: 48,
      child: ListView(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 16,
        ),
        scrollDirection:
            Axis.horizontal,
        children: [
          _filterChip(
            'Semua',
            Icons.apps_rounded,
          ),
          const SizedBox(width: 8),
          _filterChip(
            'CP',
            Icons.flag_rounded,
          ),
          const SizedBox(width: 8),
          _filterChip(
            'ATP',
            Icons.route_rounded,
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
    String value,
    IconData icon,
  ) {
    final active =
        _filterKategori ==
            value;

    return FilterChip(
      selected: active,
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 17,
        color: active
            ? Colors.white
            : _primary,
      ),
      label: Text(
        value,
        style: TextStyle(
          color: active
              ? Colors.white
              : textColor,
          fontSize: 11,
          fontWeight:
              FontWeight.w800,
        ),
      ),
      selectedColor:
          _primary,
      backgroundColor:
          cardColor,
      side: BorderSide(
        color: active
            ? _primary
            : borderColor,
      ),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          13,
        ),
      ),
      onSelected: (_) {
        setState(() {
          _filterKategori =
              value;
        });
      },
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomNavigation() {
    return NavigationBar(
      height: 70,
      backgroundColor:
          cardColor,
      surfaceTintColor:
          Colors.transparent,
      elevation: 8,
      selectedIndex: 3,
      onDestinationSelected:
          (index) {
        if (index == 3) return;

        _showMessage(
          'Navigasi ${_navigationName(index)} '
          'dapat dihubungkan ke halaman dashboard guru.',
        );
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.dashboard_outlined,
          ),
          selectedIcon: Icon(
            Icons.dashboard_rounded,
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
          label: 'Materi',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.video_library_outlined,
          ),
          selectedIcon: Icon(
            Icons.video_library_rounded,
          ),
          label: 'Video',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.account_tree_outlined,
          ),
          selectedIcon: Icon(
            Icons.account_tree_rounded,
          ),
          label: 'CP & ATP',
        ),
      ],
    );
  }

  String _navigationName(
    int index,
  ) {
    switch (index) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Materi';
      case 2:
        return 'Video';
      default:
        return 'CP & ATP';
    }
  }
}

// ============================================================
// CP ATP CARD
// ============================================================

class _CPATPCard
    extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;
  final int index;
  final VoidCallback onDelete;

  const _CPATPCard({
    required this.id,
    required this.data,
    required this.index,
    required this.onDelete,
  });

  // ==========================================================
  // FORMAT TANGGAL
  // ==========================================================

  String _formatTanggal(
    dynamic value,
  ) {
    if (value is Timestamp) {
      final date =
          value.toDate();

      final day = date.day
          .toString()
          .padLeft(2, '0');

      final month = date.month
          .toString()
          .padLeft(2, '0');

      final year =
          date.year.toString();

      return '$day/$month/$year';
    }

    if (value is DateTime) {
      final day = value.day
          .toString()
          .padLeft(2, '0');

      final month = value.month
          .toString()
          .padLeft(2, '0');

      final year =
          value.year.toString();

      return '$day/$month/$year';
    }

    return 'Tanggal belum tersedia';
  }

  // ==========================================================
  // CATEGORY COLOR
  // ==========================================================

  Color _kategoriColor(
    String kategori,
  ) {
    final value =
        kategori.toLowerCase();

    if (value == 'atp') {
      return _blue;
    }

    if (value == 'cp') {
      return _violet;
    }

    return _primary;
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final cardColor =
        isDark
            ? const Color(
                0xFF111827,
              )
            : Colors.white;

    final textColor =
        isDark
            ? Colors.white
            : _lightText;

    final subtitleColor =
        isDark
            ? _darkSubtitle
            : _lightSubtitle;

    final borderColor =
        isDark
            ? Colors.white
                .withValues(
                alpha: 0.07,
              )
            : const Color(
                0xFFE5E7EB,
              );

    final judul =
        (data['judul'] ??
                'Tanpa Judul')
            .toString()
            .trim();

    final isi =
        (data['isi'] ?? '')
            .toString()
            .trim();

    final kategori =
        (data['kategori'] ??
                'CP')
            .toString()
            .trim()
            .toUpperCase();

    final tanggal =
        _formatTanggal(
      data['createdAt'],
    );

    final categoryColor =
        _kategoriColor(
      kategori,
    );

    return Container(
      width: double.infinity,
      decoration:
          BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha:
                  isDark
                      ? 0.14
                      : 0.045,
            ),
            blurRadius: 20,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        child: Column(
          children: [
            // ==================================================
            // CARD HEADER
            // ==================================================

            Container(
              height: 88,
              width: double.infinity,
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topLeft,
                  end:
                      Alignment.bottomRight,
                  colors: [
                    categoryColor,
                    categoryColor
                        .withValues(
                      alpha: 0.78,
                    ),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -25,
                    top: -40,
                    child:
                        Container(
                      width: 120,
                      height: 120,
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .white
                            .withValues(
                          alpha: 0.07,
                        ),
                        shape:
                            BoxShape
                                .circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    bottom: -55,
                    child:
                        Container(
                      width: 100,
                      height: 100,
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .white
                            .withValues(
                          alpha: 0.05,
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
                            .all(15),
                    child: Row(
                      children: [
                        Container(
                          width: 53,
                          height: 53,
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withValues(
                              alpha:
                                  0.16,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            border:
                                Border.all(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha:
                                    0.18,
                              ),
                            ),
                          ),
                          child:
                              Icon(
                            kategori ==
                                    'ATP'
                                ? Icons
                                    .route_rounded
                                : Icons
                                    .flag_rounded,
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
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Text(
                                kategori,
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white
                                      .withValues(
                                    alpha:
                                        0.80,
                                  ),
                                  fontSize:
                                      9,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                  letterSpacing:
                                      1.2,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                'Pembelajaran',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize:
                                      14,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),
                            ],
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
                          color:
                              cardColor,
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
                                'delete') {
                              onDelete();
                            }
                          },
                          itemBuilder:
                              (_) =>
                                  const [
                            PopupMenuItem(
                              value:
                                  'delete',
                              child:
                                  Row(
                                children: [
                                  Icon(
                                    Icons
                                        .delete_outline_rounded,
                                    color:
                                        _red,
                                    size:
                                        19,
                                  ),
                                  SizedBox(
                                    width:
                                        10,
                                  ),
                                  Text(
                                    'Hapus',
                                    style:
                                        TextStyle(
                                      color:
                                          _red,
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
                ],
              ),
            ),

            // ==================================================
            // CARD CONTENT
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                15,
                16,
                16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    judul.isEmpty
                        ? 'Tanpa Judul'
                        : judul,
                    maxLines: 3,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color:
                          textColor,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w900,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons
                            .calendar_today_rounded,
                        size: 12,
                        color:
                            subtitleColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        tanggal,
                        style:
                            TextStyle(
                          color:
                              subtitleColor,
                          fontSize:
                              10.5,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(
                      14,
                    ),
                    decoration:
                        BoxDecoration(
                      color: isDark
                          ? Colors
                              .white
                              .withValues(
                              alpha:
                                  0.035,
                            )
                          : const Color(
                              0xFFF8FAFC,
                            ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                      border:
                          Border.all(
                        color:
                            borderColor,
                      ),
                    ),
                    child:
                        Text(
                      isi.isEmpty
                          ? 'Belum ada isi CP/ATP.'
                          : isi,
                      maxLines: 5,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          TextStyle(
                        color:
                            subtitleColor,
                        fontSize:
                            11.5,
                        height: 1.55,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          categoryColor
                              .withValues(
                        alpha: 0.09,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize
                              .min,
                      children: [
                        Icon(
                          kategori ==
                                  'ATP'
                              ? Icons
                                  .route_rounded
                              : Icons
                                  .flag_rounded,
                          size: 14,
                          color:
                              categoryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          kategori.isEmpty
                              ? 'CP'
                              : kategori,
                          style:
                              TextStyle(
                            color:
                                categoryColor,
                            fontSize:
                                9.5,
                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 44,
                    child:
                        OutlinedButton
                            .icon(
                      onPressed:
                          onDelete,
                      icon:
                          const Icon(
                        Icons
                            .delete_outline_rounded,
                        size: 18,
                      ),
                      label:
                          const Text(
                        'Hapus Data',
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
                        foregroundColor:
                            _red,
                        side:
                            BorderSide(
                          color:
                              _red.withValues(
                            alpha:
                                0.22,
                          ),
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                      ),
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
}

// ============================================================
// LOADING VIEW
// ============================================================

class _LoadingView
    extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child:
                CircularProgressIndicator(
              strokeWidth: 3,
              color: _primary,
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            'Memuat CP & ATP...',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EMPTY VIEW
// ============================================================

class _EmptyView
    extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  colors: [
                    _primary.withValues(
                      alpha: 0.12,
                    ),
                    _violet.withValues(
                      alpha: 0.08,
                    ),
                  ],
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .account_tree_rounded,
                color: _primary,
                size: 50,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              'Belum Ada CP & ATP',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: theme
                    .colorScheme
                    .onSurface,
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Belum ada data CP atau ATP '
              'yang tersimpan.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
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

// ============================================================
// NO SEARCH RESULT
// ============================================================

class _NoSearchView
    extends StatelessWidget {
  const _NoSearchView();

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons
                  .search_off_rounded,
              size: 70,
              color: theme
                  .colorScheme
                  .primary
                  .withValues(
                alpha: 0.40,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              'Data Tidak Ditemukan',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: theme
                    .colorScheme
                    .onSurface,
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              'Coba gunakan kata kunci '
              'atau kategori lainnya.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.50,
                ),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView
    extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration:
                  BoxDecoration(
                color:
                    _red.withValues(
                  alpha: 0.10,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons
                    .cloud_off_rounded,
                color: _red,
                size: 42,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              'Gagal Memuat Data',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: theme
                    .colorScheme
                    .onSurface,
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              error,
              textAlign:
                  TextAlign.center,
              maxLines: 4,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
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
            const SizedBox(
              height: 18,
            ),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon:
                  const Icon(
                Icons
                    .refresh_rounded,
              ),
              label:
                  const Text(
                'Coba Lagi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}