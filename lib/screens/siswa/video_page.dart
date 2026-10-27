import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../services/video_service.dart';
import 'widgets/siswa_bottom_navigation.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  final VideoService _videoService = VideoService();
  final TextEditingController _searchController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  String _searchQuery = '';

  String? _selectedVideoId;
  String? _selectedTitle;
  String? _selectedDescription;

  YoutubePlayerController? _youtubeController;

  bool _isVideoSelected = false;
  bool _isPlaying = false;

  YoutubeError _youtubeError = YoutubeError.none;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.forward();

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();

    _youtubeController?.close();

    _animationController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // ==================================================
              // ACTIVE VIDEO
              // ==================================================

              if (_isVideoSelected)
                SliverToBoxAdapter(
                  child: _buildActiveVideo(),
                ),

              SliverToBoxAdapter(
                child: _buildSearch(),
              ),

              SliverToBoxAdapter(
                child: _buildSectionHeader(),
              ),

              _buildVideoList(),

              const SliverToBoxAdapter(
                child: SizedBox(height: 35),
              ),
            ],
          ),
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 2,
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
            color: const Color(0xFF6366F1).withValues(alpha: 0.25),
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Video Pembelajaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Belajar melalui video interaktif 🎬',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
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
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.video_library_rounded,
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
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Siap untuk belajar?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Tonton video dan pahami konsep algoritma.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 11,
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
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
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
  // ACTIVE VIDEO
  // ============================================================

  Widget _buildActiveVideo() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      child: Container(
        key: ValueKey(_selectedVideoId),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlayer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedTitle ?? 'Video Pembelajaran',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF111827),
                            height: 1.25,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFEF4444),
                              Color(0xFFF97316),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'VIDEO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _selectedDescription ??
                        'Video pembelajaran Algoritma dan Pemrograman.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPlaying
                                  ? Icons.equalizer_rounded
                                  : Icons.play_circle_outline_rounded,
                              size: 16,
                              color: const Color(0xFF6366F1),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isPlaying
                                  ? 'Sedang diputar'
                                  : 'Siap ditonton',
                              style: const TextStyle(
                                color: Color(0xFF4F46E5),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      TextButton.icon(
                        onPressed: _closeActiveVideo,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 17,
                        ),
                        label: const Text(
                          'Tutup',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
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

  // ============================================================
  // PLAYER
  // ============================================================

  Widget _buildPlayer() {
    if (_youtubeController == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: _buildPlayerError(
          'Video tidak dapat diputar',
          'Link video tidak valid atau bukan link YouTube.',
          showYoutubeButton: false,
        ),
      );
    }

    if (_youtubeError != YoutubeError.none) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: _buildYoutubeError(),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: _youtubeController!,
        aspectRatio: 16 / 9,
      ),
    );
  }

  // ============================================================
  // PLAYER ERROR
  // ============================================================

  Widget _buildPlayerError(
    String title,
    String subtitle, {
    bool showYoutubeButton = true,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF312E81),
            Color(0xFF7C3AED),
            Color(0xFFBE185D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.video_library_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 11,
                ),
              ),

              if (showYoutubeButton) ...[
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _openYoutube,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 20,
                  ),
                  label: const Text('Tonton di YouTube'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4F46E5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYoutubeError() {
    String title = 'Video tidak tersedia';
    String subtitle =
        'Video ini tidak dapat diputar langsung di dalam aplikasi.';

    IconData icon = Icons.video_library_rounded;

    switch (_youtubeError) {
      case YoutubeError.notEmbeddable:
      case YoutubeError.sameAsNotEmbeddable:
        title = 'Video tidak bisa diputar di aplikasi';
        subtitle =
            'Pemilik video tidak mengizinkan video diputar melalui aplikasi.';
        icon = Icons.open_in_new_rounded;
        break;
      case YoutubeError.videoNotFound:
      case YoutubeError.cannotFindVideo:
        title = 'Video tidak ditemukan';
        subtitle =
            'Video mungkin sudah dihapus atau dibuat menjadi private.';
        icon = Icons.video_library_rounded;
        break;
      case YoutubeError.invalidParam:
        title = 'Link video tidak valid';
        subtitle = 'ID video YouTube yang digunakan tidak valid.';
        icon = Icons.link_off_rounded;
        break;
      case YoutubeError.html5Error:
        title = 'Video gagal diputar';
        subtitle = 'Terjadi masalah pada pemutar video YouTube.';
        icon = Icons.error_outline_rounded;
        break;
      case YoutubeError.unknown:
        title = 'Video tidak tersedia';
        subtitle =
            'YouTube tidak dapat memutar video ini di dalam aplikasi.';
        icon = Icons.warning_amber_rounded;
        break;
      case YoutubeError.none:
        break;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF111827),
            Color(0xFF312E81),
            Color(0xFF4F46E5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _openYoutube,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 20,
                ),
                label: const Text('Tonton di YouTube'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4F46E5),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openYoutube() async {
    final videoId = _selectedVideoId;

    if (videoId == null || videoId.isEmpty) {
      return;
    }

    final youtubeUrl = Uri.parse(
      'https://www.youtube.com/watch?v=$videoId',
    );

    try {
      final launched = await launchUrl(
        youtubeUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showYoutubeOpenError();
      }
    } catch (_) {
      if (mounted) {
        _showYoutubeOpenError();
      }
    }
  }

  void _showYoutubeOpenError() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFEF4444),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: const Text(
          'Tidak dapat membuka YouTube.',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari video pembelajaran...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),

            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF6366F1),
            ),

            suffixIcon: _searchQuery.isNotEmpty
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
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6366F1),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),

            border: InputBorder.none,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 27, 18, 14),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEF4444),
                  Color(0xFFF97316),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video Terbaru',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pilih video untuk mulai belajar',
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
  // VIDEO LIST
  // ============================================================

  Widget _buildVideoList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _videoService.getVideo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
              title: 'Gagal memuat video',
              subtitle:
                  'Terjadi kesalahan saat mengambil data video.',
              color: const Color(0xFFEF4444),
            ),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildStateCard(
              icon: Icons.video_library_outlined,
              title: 'Belum ada video',
              subtitle:
                  'Video pembelajaran akan muncul di sini.',
              color: const Color(0xFF6366F1),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        final filteredDocs = docs.where((doc) {
          final data = doc.data();

          final title =
              data['judul']?.toString().toLowerCase() ?? '';

          final description =
              data['deskripsi']?.toString().toLowerCase() ?? '';

          return title.contains(_searchQuery) ||
              description.contains(_searchQuery);
        }).toList();

        if (filteredDocs.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildStateCard(
              icon: Icons.search_off_rounded,
              title: 'Video tidak ditemukan',
              subtitle:
                  'Coba gunakan kata kunci pencarian lainnya.',
              color: const Color(0xFFF59E0B),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final data =
                    filteredDocs[index].data();

                final title =
                    data['judul']?.toString() ??
                        'Video Pembelajaran';

                final description =
                    data['deskripsi']?.toString() ??
                        'Video pembelajaran Algoritma dan Pemrograman.';

                final link =
                    data['link']?.toString() ?? '';

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16),
                  child: _VideoCard(
                    title: title,
                    description: description,
                    link: link,
                    index: index,
                    isSelected:
                        _selectedVideoId ==
                            _extractYoutubeId(link),
                    onTap: () {
                      _playVideo(
                        link: link,
                        title: title,
                        description: description,
                      );
                    },
                  ),
                );
              },
              childCount: filteredDocs.length,
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PLAY VIDEO
  // ============================================================

  void _playVideo({
    required String link,
    required String title,
    required String description,
  }) {
    final videoId = _extractYoutubeId(link);

    if (videoId == null || videoId.isEmpty) {
      _showInvalidVideoMessage();
      return;
    }

    _youtubeController?.close();

    final controller =
    YoutubePlayerController.fromVideoId(
  videoId: videoId,
  autoPlay: true,
  params: const YoutubePlayerParams(
    showControls: true,
    showFullscreenButton: true,
    enableCaption: true,
    playsInline: true,
    strictRelatedVideos: true,
    enableJavaScript: true,
    origin: 'https://www.youtube-nocookie.com',
  ),
);

    controller.listen((value) {
      if (!mounted) return;

      setState(() {
        _isPlaying = value.playerState == PlayerState.playing;
        _youtubeError = value.error;
      });
    });

    setState(() {
      _youtubeController = controller;
      _selectedVideoId = videoId;
      _selectedTitle = title;
      _selectedDescription = description;
      _isVideoSelected = true;
      _isPlaying = true;
      _youtubeError = YoutubeError.none;
    });

    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        if (!mounted) return;

        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      },
    );
  }

  // ============================================================
  // CLOSE VIDEO
  // ============================================================

  void _closeActiveVideo() {
    _youtubeController?.close();

    setState(() {
      _youtubeController = null;

      _selectedVideoId = null;
      _selectedTitle = null;
      _selectedDescription = null;

      _isVideoSelected = false;
      _isPlaying = false;
      _youtubeError = YoutubeError.none;
    });
  }

  // ============================================================
  // INVALID VIDEO MESSAGE
  // ============================================================

  void _showInvalidVideoMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFEF4444),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: const Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Link video tidak valid. Gunakan link YouTube.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EXTRACT YOUTUBE ID
  // ============================================================

  String? _extractYoutubeId(String url) {
    final value = url.trim();

    if (value.isEmpty) {
      return null;
    }

    try {
      final uri = Uri.tryParse(value);

      if (uri == null) {
        return null;
      }

      // ------------------------------------------
      // youtube.com/watch?v=XXXXXXXX
      // ------------------------------------------

      final queryId = uri.queryParameters['v'];

      if (queryId != null &&
          queryId.trim().isNotEmpty) {
        return _cleanYoutubeId(queryId);
      }

      // ------------------------------------------
      // youtu.be/XXXXXXXX
      // ------------------------------------------

      if (uri.host.contains('youtu.be')) {
        if (uri.pathSegments.isNotEmpty) {
          return _cleanYoutubeId(
            uri.pathSegments.first,
          );
        }
      }

      // ------------------------------------------
      // youtube.com/embed/XXXXXXXX
      // ------------------------------------------

      final embedIndex =
          uri.pathSegments.indexOf('embed');

      if (embedIndex >= 0 &&
          embedIndex + 1 <
              uri.pathSegments.length) {
        return _cleanYoutubeId(
          uri.pathSegments[embedIndex + 1],
        );
      }

      // ------------------------------------------
      // youtube.com/shorts/XXXXXXXX
      // ------------------------------------------

      final shortsIndex =
          uri.pathSegments.indexOf('shorts');

      if (shortsIndex >= 0 &&
          shortsIndex + 1 <
              uri.pathSegments.length) {
        return _cleanYoutubeId(
          uri.pathSegments[shortsIndex + 1],
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  String _cleanYoutubeId(String id) {
    return id
        .replaceAll('?', '')
        .replaceAll('&', '')
        .replaceAll('/', '')
        .trim();
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
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 31,
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
// VIDEO CARD
// ================================================================

class _VideoCard extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _VideoCard({
    required this.title,
    required this.description,
    required this.link,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF6366F1)
              : const Color(0xFFE5E7EB),
          width: isSelected ? 1.7 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF6366F1)
                    .withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isSelected ? 20 : 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(23),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _buildThumbnail(),

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
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w900,
                                color:
                                    Color(0xFF111827),
                                height: 1.25,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          if (isSelected)
                            const Icon(
                              Icons.equalizer_rounded,
                              color: Color(0xFF6366F1),
                              size: 19,
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        description,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFFEF2F2),
                              borderRadius:
                                  BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: const Text(
                              'VIDEO',
                              style: TextStyle(
                                color:
                                    Color(0xFFEF4444),
                                fontSize: 8,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
                          ),

                          const Spacer(),

                          Text(
                            isSelected
                                ? 'Sedang dipilih'
                                : 'Tonton',
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(
                                      0xFF6366F1,
                                    )
                                  : const Color(
                                      0xFF4F46E5,
                                    ),
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Icon(
                            isSelected
                                ? Icons
                                    .check_circle_rounded
                                : Icons
                                    .arrow_forward_rounded,
                            color: const Color(
                              0xFF6366F1,
                            ),
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // THUMBNAIL
  // ============================================================

  Widget _buildThumbnail() {
    final videoId = _extractId(link);

    return SizedBox(
      width: 118,
      height: 82,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (videoId != null)
              Image.network(
                'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return _thumbnailFallback();
                },
              )
            else
              _thumbnailFallback(),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.38),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Center(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.94,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFEF4444),
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF312E81),
            Color(0xFF7C3AED),
            Color(0xFFEC4899),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.video_library_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  String? _extractId(String url) {
    final value = url.trim();

    if (value.isEmpty) {
      return null;
    }

    try {
      final uri = Uri.tryParse(value);

      if (uri == null) {
        return null;
      }

      final queryId = uri.queryParameters['v'];

      if (queryId != null &&
          queryId.isNotEmpty) {
        return _cleanId(queryId);
      }

      if (uri.host.contains('youtu.be')) {
        if (uri.pathSegments.isNotEmpty) {
          return _cleanId(
            uri.pathSegments.first,
          );
        }
      }

      final embedIndex =
          uri.pathSegments.indexOf('embed');

      if (embedIndex >= 0 &&
          embedIndex + 1 <
              uri.pathSegments.length) {
        return _cleanId(
          uri.pathSegments[embedIndex + 1],
        );
      }

      final shortsIndex =
          uri.pathSegments.indexOf('shorts');

      if (shortsIndex >= 0 &&
          shortsIndex + 1 <
              uri.pathSegments.length) {
        return _cleanId(
          uri.pathSegments[shortsIndex + 1],
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  String _cleanId(String id) {
    return id
        .replaceAll('?', '')
        .replaceAll('&', '')
        .replaceAll('/', '')
        .trim();
  }
}