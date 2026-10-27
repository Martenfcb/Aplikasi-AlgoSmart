import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

import 'detail_materi_page.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: const Color(0xFFF7F8FC),

  body: SafeArea(
    child: Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildMateriList(),
        ),
      ],
    ),
  ),

  bottomNavigationBar: SiswaBottomNavigation(
    currentIndex: 1,
    onTap: (index) {
      if (index == 1) {
        return;
      }

      if (index == 0) {
        Navigator.pop(context);
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              index == 2
                  ? 'Menu Video'
                  : index == 3
                      ? 'Menu Quiz'
                      : 'Menu Profil',
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            duration: const Duration(milliseconds: 900),
          ),
        );
    },
  ),
);
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFF06B6D4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBackButton(),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Materi Pembelajaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Pelajari algoritma dan pemrograman',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildHeaderIcon(
                Icons.book_rounded,
              ),
            ],
          ),

          const SizedBox(height: 22),

          _buildSearchBar(),
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
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.pop(context);
        },
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.16,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.20,
              ),
            ),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER ICON
  // ============================================================

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.16,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 23,
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.10,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _keyword = value.trim().toLowerCase();
          });
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Cari materi pembelajaran...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6366F1),
            size: 23,
          ),
          suffixIcon: _keyword.isNotEmpty
              ? IconButton(
                  tooltip: 'Hapus pencarian',
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _keyword = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF64748B),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MATERI LIST
  // ============================================================

  Widget _buildMateriList() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('materi')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildError(
            snapshot.error.toString(),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        final filteredDocs = docs.where((doc) {
          final data = doc.data();

          final judul =
              data['judul']?.toString().toLowerCase() ??
                  '';

          final deskripsi = data['deskripsi']
                  ?.toString()
                  .toLowerCase() ??
              '';

          return judul.contains(_keyword) ||
              deskripsi.contains(_keyword);
        }).toList();

        if (filteredDocs.isEmpty) {
          if (_keyword.isNotEmpty) {
            return _buildSearchEmpty();
          }

          return _buildEmpty();
        }

        return LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width = constraints.maxWidth;

            if (width >= 900) {
              return _buildGrid(
                filteredDocs,
                crossAxisCount: 3,
              );
            }

            if (width >= 600) {
              return _buildGrid(
                filteredDocs,
                crossAxisCount: 2,
              );
            }

            return _buildList(
              filteredDocs,
            );
          },
        );
      },
    );
  }

  // ============================================================
  // LIST MODE
  // ============================================================

  Widget _buildList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        docs,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        30,
      ),
      itemCount: docs.length,
      itemBuilder: (
        context,
        index,
      ) {
        return _AnimatedMaterialCard(
          index: index,
          child: _buildMaterialCard(
            docs[index],
          ),
        );
      },
    );
  }

  // ============================================================
  // GRID MODE
  // ============================================================

  Widget _buildGrid(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        docs, {
    required int crossAxisCount,
  }) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        30,
      ),
      itemCount: docs.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (
        context,
        index,
      ) {
        return _AnimatedMaterialCard(
          index: index,
          child: _buildMaterialCard(
            docs[index],
            isGrid: true,
          ),
        );
      },
    );
  }

  // ============================================================
  // MATERIAL CARD
  // ============================================================

  Widget _buildMaterialCard(
    QueryDocumentSnapshot<Map<String, dynamic>>
        document, {
    bool isGrid = false,
  }) {
    final data = document.data();

    final judul =
        data['judul']?.toString().trim().isNotEmpty ==
                true
            ? data['judul'].toString()
            : 'Materi Pembelajaran';

    final deskripsi =
        data['deskripsi']?.toString().trim().isNotEmpty ==
                true
            ? data['deskripsi'].toString()
            : 'Pelajari materi Algoritma dan Pemrograman.';

    final link =
        data['link']?.toString() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        splashColor: const Color(0xFF6366F1).withValues(alpha: 0.08),
        highlightColor: const Color(0xFF6366F1).withValues(alpha: 0.04),
        onTap: () {
          _openDetail(
            judul: judul,
            deskripsi: deskripsi,
            link: link,
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: const Color(0xFFE8EAF2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1)
                    .withValues(alpha: 0.07),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: isGrid
                ? _buildGridCardContent(
                    judul,
                    deskripsi,
                  )
                : _buildListCardContent(
                    judul,
                    deskripsi,
                  ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LIST CARD CONTENT
  // ============================================================

  Widget _buildListCardContent(
    String judul,
    String deskripsi,
  ) {
    return Row(
      children: [
        _buildMaterialIcon(),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildBadge(),
              const SizedBox(height: 9),
              Text(
                judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              _buildLearnButton(),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF94A3B8),
          size: 26,
        ),
      ],
    );
  }

  // ============================================================
  // GRID CARD CONTENT
  // ============================================================

  Widget _buildGridCardContent(
    String judul,
    String deskripsi,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildMaterialIcon(
              size: 52,
            ),
            const Spacer(),
            _buildBadge(),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          judul,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            height: 1.25,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 7),
        Expanded(
          child: Text(
            deskripsi,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildLearnButton(),
      ],
    );
  }

  // ============================================================
  // MATERIAL ICON
  // ============================================================

  Widget _buildMaterialIcon({
    double size = 62,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEEF2FF),
            Color(0xFFE0F2FE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            color: Color(0xFF6366F1),
            size: 30,
          ),
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B6B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BADGE
  // ============================================================

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFE4E6),
            Color(0xFFFFEDD5),
          ],
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.picture_as_pdf_rounded,
            color: Color(0xFFEF4444),
            size: 12,
          ),
          SizedBox(width: 4),
          Text(
            'PDF',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARN BUTTON
  // ============================================================

  Widget _buildLearnButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Pelajari',
          style: TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        30,
      ),
      itemCount: 4,
      itemBuilder: (
        context,
        index,
      ) {
        return Container(
          height: 145,
          margin: const EdgeInsets.only(
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEFF5),
                    borderRadius:
                        BorderRadius.circular(19),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFEDEFF5),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFEDEFF5),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFEDEFF5),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(
              Icons.menu_book_rounded,
              const [
                Color(0xFF6366F1),
                Color(0xFF06B6D4),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Belum Ada Materi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Materi yang diunggah guru\nakan muncul di halaman ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH EMPTY
  // ============================================================

  Widget _buildSearchEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(
              Icons.search_off_rounded,
              const [
                Color(0xFFF97316),
                Color(0xFFEF4444),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Materi Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba gunakan kata kunci pencarian\n'
              'yang berbeda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _keyword = '';
                });
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Tampilkan semua materi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY ICON
  // ============================================================

  Widget _buildEmptyIcon(
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(
              alpha: 0.20,
            ),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 46,
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(
              Icons.cloud_off_rounded,
              const [
                Color(0xFFEF4444),
                Color(0xFFF97316),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Gagal Memuat Materi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terjadi masalah saat mengambil data\n'
              'dari server.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              error,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // OPEN DETAIL
  // ============================================================

  void _openDetail({
    required String judul,
    required String deskripsi,
    required String link,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailMateriPage(
          judul: judul,
          deskripsi: deskripsi,
          link: link,
        ),
      ),
    );
  }
}


// ================================================================
// SAFE ENTRY ANIMATION
// ================================================================
//
// Tidak menggunakan AnimationController / late variable.
// Jadi aman dari:
//
// LateInitializationError:
// Field '_fadeAnimation' has not been initialized.
//
// ================================================================


class _AnimatedMaterialCard extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedMaterialCard({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedMaterialCard> createState() =>
      _AnimatedMaterialCardState();
}

class _AnimatedMaterialCardState extends State<_AnimatedMaterialCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Satu controller untuk semua animasi agar ringan dan mudah dirawat.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<double>(
      begin: 28,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _floatAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -4,
        ).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -4,
          end: 0,
        ).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.65,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );

    // Setiap kartu mulai sedikit berbeda supaya halaman terasa hidup,
    // bukan semua kartu bergerak bersamaan.
    Future<void>.delayed(
      Duration(
        milliseconds: 80 + (widget.index * 90),
      ),
      () {
        if (!mounted) return;

        _controller.repeat();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final double slide = _slideAnimation.value;
        final double scale = _scaleAnimation.value;
        final double floating = _floatAnimation.value;

        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, slide + floating),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
