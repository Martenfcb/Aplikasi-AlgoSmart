import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/video_service.dart';
import 'edit_video_page.dart';
import 'tambah_video_page.dart';

class KelolaVideoPage extends StatefulWidget {
  const KelolaVideoPage({super.key});

  @override
  State<KelolaVideoPage> createState() =>
      _KelolaVideoPageState();
}

class _KelolaVideoPageState extends State<KelolaVideoPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchKeyword = '';

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color violet = Color(0xFF7C3AED);
  static const Color red = Color(0xFFEF4444);
  static const Color green = Color(0xFF10B981);
  static const Color orange = Color(0xFFF59E0B);

  static const Color background = Color(0xFFF6F7FB);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF667085);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // TAMBAH VIDEO
  // ============================================================

  Future<void> _tambahVideo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahVideoPage(),
      ),
    );
  }

  // ============================================================
  // EDIT VIDEO
  // ============================================================

  Future<void> _editVideo({
    required String id,
    required String judul,
    required String deskripsi,
    required String link,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditVideoPage(
          id: id,
          judul: judul,
          deskripsi: deskripsi,
          link: link,
        ),
      ),
    );
  }

  // ============================================================
  // HAPUS VIDEO
  // ============================================================

  Future<void> _hapusVideo(
    String id,
    String judul,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              12,
              22,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444)
                        .withValues(alpha: .10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color(0xFFEF4444),
                    size: 35,
                  ),
                ),

                const SizedBox(height: 17),

                const Text(
                  'Hapus Video?',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Video "$judul" akan dihapus '
                  'secara permanen.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                            false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                            true,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFEF4444),
                          minimumSize:
                              const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
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

    if (result != true) return;

    try {
      await VideoService().hapusVideo(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF10B981),
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Video berhasil dihapus.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      _showError(
        e.message ?? 'Gagal menghapus video.',
      );
    } catch (_) {
      if (!mounted) return;
      _showError(
        'Terjadi kesalahan saat menghapus video.',
      );
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFEF4444),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
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
  // SEARCH
  // ============================================================

  bool _sesuaiPencarian(
    String judul,
    String deskripsi,
  ) {
    final keyword =
        _searchKeyword.trim().toLowerCase();

    if (keyword.isEmpty) {
      return true;
    }

    return judul.toLowerCase().contains(keyword) ||
        deskripsi.toLowerCase().contains(keyword);
  }

  // ============================================================
  // YOUTUBE ID
  // ============================================================

String _getYoutubeId(String link) {
  final value = link.trim();

  if (value.isEmpty) {
    return '';
  }

  try {
    final uri = Uri.tryParse(value);

    if (uri == null) {
      return '';
    }

    // ============================================================
    // youtube.com/watch?v=VIDEO_ID
    // ============================================================

    final queryId = uri.queryParameters['v'];

    if (queryId != null && queryId.trim().isNotEmpty) {
      return _cleanYoutubeId(queryId);
    }

    // ============================================================
    // youtu.be/VIDEO_ID
    // ============================================================

    if (uri.host.toLowerCase().contains('youtu.be')) {
      if (uri.pathSegments.isNotEmpty) {
        return _cleanYoutubeId(
          uri.pathSegments.first,
        );
      }
    }

    // ============================================================
    // youtube.com/embed/VIDEO_ID
    // ============================================================

    final embedIndex =
        uri.pathSegments.indexOf('embed');

    if (embedIndex >= 0 &&
        embedIndex + 1 < uri.pathSegments.length) {
      return _cleanYoutubeId(
        uri.pathSegments[embedIndex + 1],
      );
    }

    // ============================================================
    // youtube.com/shorts/VIDEO_ID
    // ============================================================

    final shortsIndex =
        uri.pathSegments.indexOf('shorts');

    if (shortsIndex >= 0 &&
        shortsIndex + 1 < uri.pathSegments.length) {
      return _cleanYoutubeId(
        uri.pathSegments[shortsIndex + 1],
      );
    }

    return '';
  } catch (_) {
    return '';
  }
}

String _cleanYoutubeId(String id) {
  return id
      .trim()
      .split('?')
      .first
      .split('&')
      .first
      .split('/')
      .first
      .trim();
}

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(int jumlahVideo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3730A3),
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5)
                .withValues(alpha: .20),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -60,
            top: -70,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: .06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: .14),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.ondemand_video_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelola Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Kelola video pembelajaran '
                      'AlgoSmart.',
                      style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: .78),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: .13),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Text(
                      '$jumlahVideo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: .70),
                        fontSize: 8,
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
  // SEARCH
  // ============================================================

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: .035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchKeyword = value;
          });
        },
        decoration: InputDecoration(
          hintText:
              'Cari video pembelajaran...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5)
                  .withValues(alpha: .10),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF4F46E5),
              size: 20,
            ),
          ),
          suffixIcon:
              _searchKeyword.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _searchKeyword = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 20,
                      ),
                    )
                  : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // VIDEO CARD
  // ============================================================

  Widget _buildVideoCard(
    String id,
    Map<String, dynamic> data,
  ) {
    final judul =
        (data['judul'] ?? 'Tanpa Judul')
            .toString();

    final deskripsi =
        (data['deskripsi'] ?? '')
            .toString();

    final link =
        (data['link'] ?? '')
            .toString();

    final createdAt =
        data['createdAt'];

    String tanggal = '';

    if (createdAt is Timestamp) {
      final date =
          createdAt.toDate();

      tanggal =
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    return Container(
      margin:
          const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFE7E8EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: .045),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _VideoPreview(
            url: link,
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        judul,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF111827),
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                    ),

                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color:
                            Color(0xFF667085),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editVideo(
                            id: id,
                            judul: judul,
                            deskripsi: deskripsi,
                            link: link,
                          );
                        }

                        if (value == 'hapus') {
                          _hapusVideo(
                            id,
                            judul,
                          );
                        }
                      },
                      itemBuilder: (_) =>
                          const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'hapus',
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .delete_outline_rounded,
                                color:
                                    Color(0xFFEF4444),
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Hapus',
                                style: TextStyle(
                                  color:
                                      Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (deskripsi.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    deskripsi,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color:
                          Color(0xFF667085),
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _badge(
                      Icons
                          .play_circle_fill_rounded,
                      'Video',
                      const Color(0xFFEF4444),
                    ),
                    if (tanggal.isNotEmpty)
                      _badge(
                        Icons.calendar_today_rounded,
                        tanggal,
                        const Color(0xFF4F46E5),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                if (link.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(0xFFF8F9FC),
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFEF4444,
                            ).withValues(
                              alpha: .10,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              9,
                            ),
                          ),
                          child: const Icon(
                            Icons.link_rounded,
                            color:
                                Color(0xFFEF4444),
                            size: 17,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            link,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              color:
                                  Color(0xFF667085),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton.icon(
                        onPressed: () {
                          _editVideo(
                            id: id,
                            judul: judul,
                            deskripsi:
                                deskripsi,
                            link: link,
                          );
                        },
                        icon: const Icon(
                          Icons.edit_rounded,
                          size: 16,
                        ),
                        label:
                            const Text('Edit'),
                        style:
                            OutlinedButton
                                .styleFrom(
                          foregroundColor:
                              const Color(
                            0xFF4F46E5,
                          ),
                          side: BorderSide(
                            color:
                                const Color(
                              0xFF4F46E5,
                            ).withValues(
                              alpha: .20,
                            ),
                          ),
                          minimumSize:
                              const Size.fromHeight(
                            44,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              13,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 9),

                    SizedBox(
                      width: 48,
                      height: 44,
                      child: FilledButton(
                        onPressed: () {
                          _hapusVideo(
                            id,
                            judul,
                          );
                        },
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFFEF4444,
                          ).withValues(
                            alpha: .10,
                          ),
                          foregroundColor:
                              const Color(
                            0xFFEF4444,
                          ),
                          elevation: 0,
                          padding:
                              EdgeInsets.zero,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              13,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .delete_outline_rounded,
                          size: 20,
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
    );
  }

  // ============================================================
  // BADGE
  // ============================================================

  Widget _badge(
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: .09),
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 8.5,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    final searching =
        _searchKeyword.isNotEmpty;

    return Center(
      child: SingleChildScrollView(
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
                  const BoxDecoration(
                gradient:
                    LinearGradient(
                  colors: [
                    Color(0xFFEDE9FE),
                    Color(0xFFDBEAFE),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.ondemand_video_rounded,
                color: Color(0xFF4F46E5),
                size: 50,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              searching
                  ? 'Video Tidak Ditemukan'
                  : 'Belum Ada Video',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              searching
                  ? 'Tidak ada video yang cocok '
                    'dengan pencarian.'
                  : 'Belum ada video pembelajaran '
                    'yang ditambahkan.',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color: Color(0xFF667085),
                fontSize: 12,
                height: 1.5,
              ),
            ),

            if (!searching) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _tambahVideo,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: const Text(
                  'Tambah Video',
                ),
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4F46E5),
                  minimumSize:
                      const Size(190, 48),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child:
                CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFF4F46E5),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Memuat video...',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(
    String error,
  ) {
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
                    const Color(
                  0xFFEF4444,
                ).withValues(
                  alpha: .08,
                ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  const Icon(
                Icons.cloud_off_rounded,
                color:
                    Color(0xFFEF4444),
                size: 40,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Gagal Memuat Video',
              style: TextStyle(
                color:
                    Color(0xFF111827),
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    Color(0xFF667085),
                fontSize: 11,
                height: 1.5,
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
    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration:
            const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            _bottomItem(
              Icons.dashboard_rounded,
              'Dashboard',
              false,
              () {
                Navigator.pop(context);
              },
            ),
            _bottomItem(
              Icons.ondemand_video_rounded,
              'Video',
              true,
              () {},
            ),
            _bottomItem(
              Icons.menu_book_rounded,
              'Materi',
              false,
              () {},
            ),
            _bottomItem(
              Icons.quiz_rounded,
              'Quiz',
              false,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: active ? 44 : 38,
              height: 31,
              decoration: BoxDecoration(
                color: active
                    ? const Color(
                        0xFF4F46E5,
                      ).withValues(
                        alpha: .10,
                      )
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                color: active
                    ? const Color(
                        0xFF4F46E5,
                      )
                    : const Color(
                        0xFF98A2B3,
                      ),
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? const Color(
                        0xFF4F46E5,
                      )
                    : const Color(
                        0xFF98A2B3,
                      ),
                fontSize: 8.5,
                fontWeight: active
                    ? FontWeight.w800
                    : FontWeight.w600,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color(0xFFF6F7FB),
        surfaceTintColor:
            Colors.transparent,
        title: const Text(
          'Kelola Video',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 19,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _tambahVideo,
            icon: Container(
              width: 38,
              height: 38,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF4F46E5,
                ).withValues(
                  alpha: .10,
                ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                color:
                    Color(0xFF4F46E5),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      bottomNavigationBar:
          _buildBottomNavigation(),

      floatingActionButton:
          FloatingActionButton(
        onPressed: _tambahVideo,
        backgroundColor:
            const Color(0xFF4F46E5),
        foregroundColor:
            Colors.white,
        elevation: 7,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.video_call_rounded,
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot<
              Map<String, dynamic>>>(
        stream: FirebaseFirestore
            .instance
            .collection('video')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),

        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return _buildLoading();
          }

          if (snapshot.hasError) {
            return _buildError(
              snapshot.error.toString(),
            );
          }

          final docs =
              snapshot.data?.docs ?? [];

          final filteredDocs =
              docs.where((doc) {
            final data = doc.data();

            final judul =
                (data['judul'] ?? '')
                    .toString();

            final deskripsi =
                (data['deskripsi'] ?? '')
                    .toString();

            return _sesuaiPencarian(
              judul,
              deskripsi,
            );
          }).toList();

          return LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final width =
                  constraints.maxWidth;

              final horizontal =
                  width >= 800 ? 0.0 : 16.0;

              final maxWidth =
                  width >= 1200
                      ? 1000.0
                      : width >= 800
                          ? 760.0
                          : double.infinity;

              return Center(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(
                          horizontal,
                          8,
                          horizontal,
                          0,
                        ),
                        child: _buildHeader(
                          docs.length,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal:
                              horizontal,
                        ),
                        child:
                            _buildSearchBox(),
                      ),

                      const SizedBox(height: 14),

                      Expanded(
                        child: filteredDocs
                                .isEmpty
                            ? _buildEmpty()
                            : ListView.builder(
                                physics:
                                    const BouncingScrollPhysics(),
                                padding:
                                    EdgeInsets.fromLTRB(
                                  horizontal,
                                  0,
                                  horizontal,
                                  100,
                                ),
                                itemCount:
                                    filteredDocs.length,
                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  final doc =
                                      filteredDocs[
                                          index];

                                  return _buildVideoCard(
                                    doc.id,
                                    doc.data(),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ===================================================================
// VIDEO PREVIEW
// FINAL - menggunakan metode player yang sama dengan VideoPlayerPage Siswa
// ===================================================================

// ===================================================================
// VIDEO PREVIEW
// FINAL
//
// Player Guru dibuat menggunakan metode yang sama dengan
// VideoPlayerPage Siswa:
//
// 1. convertUrlToId()
// 2. YoutubePlayerController()
// 3. loadVideoById()
//
// Tidak mengubah Firestore / CRUD / search / card.
// ===================================================================

class _VideoPreview extends StatefulWidget {
  final String url;

  const _VideoPreview({
    required this.url,
  });

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  YoutubePlayerController? _controller;
  String? _videoId;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Sama dengan player Siswa:
    // convertUrlToId -> controller -> loadVideoById.
    _videoId = YoutubePlayerController.convertUrlToId(
      widget.url.trim(),
    );
  }

  @override
  void didUpdateWidget(covariant _VideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _controller?.close();
      _controller = null;

      _videoId = YoutubePlayerController.convertUrlToId(
        widget.url.trim(),
      );

      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _playVideo() {
  final videoId = _videoId?.trim();

  if (videoId == null || videoId.isEmpty) {
    _showError('Link YouTube tidak valid.');
    return;
  }

  // Tutup controller lama jika ada
  _controller?.close();

  // ============================================================
  // PLAYER SAMA DENGAN HALAMAN SISWA
  // ============================================================

  final controller = YoutubePlayerController.fromVideoId(
    videoId: videoId,
    autoPlay: true,
    params: const YoutubePlayerParams(
      showControls: true,
      showFullscreenButton: true,
      enableCaption: true,
      playsInline: true,
      strictRelatedVideos: true,

      // Penting untuk Android / WebView
      enableJavaScript: true,

      // Gunakan origin yang sama dengan player Siswa
      origin: 'https://www.youtube-nocookie.com',
    ),
  );

  if (!mounted) {
    controller.close();
    return;
  }

  setState(() {
    _controller = controller;
    _isPlaying = true;
  });
}

  void _stopVideo() {
    _controller?.close();
    _controller = null;

    if (!mounted) return;

    setState(() {
      _isPlaying = false;
    });
  }

  // Fallback Android jika video memang tidak mengizinkan
  // embedded playback, misalnya YouTube Error 152.
  Future<void> _openYoutube() async {
    final url = widget.url.trim();

    if (url.isEmpty) {
      _showError('Link YouTube tidak tersedia.');
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      _showError('Link YouTube tidak valid.');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showError('Tidak dapat membuka YouTube.');
      }
    } catch (_) {
      if (mounted) {
        _showError('Tidak dapat membuka YouTube.');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFFEF4444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildInvalidVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3730A3),
              Color(0xFF4F46E5),
              Color(0xFF7C3AED),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_library_rounded,
              color: Colors.white,
              size: 46,
            ),
            const SizedBox(height: 10),
            const Text(
              'Link YouTube tidak valid',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _openYoutube,
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Buka Link'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
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
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.ondemand_video_rounded,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final id = _videoId;

    if (id == null || id.isEmpty) {
      return _buildInvalidVideo();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(23),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://img.youtube.com/vi/$id/hqdefault.jpg',
              fit: BoxFit.cover,
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF312E81),
                        Color(0xFF4F46E5),
                        Color(0xFF7C3AED),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                );
              },
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return _thumbnailFallback();
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.58),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _playVideo,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFFEF4444),
                      size: 43,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Putar Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final player = _controller;

    if (player == null) {
      return _buildThumbnail();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(23),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            YoutubePlayer(
              controller: player,
              aspectRatio: 16 / 9,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.black.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _stopVideo,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _videoId!.isEmpty) {
      return _buildInvalidVideo();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isPlaying && _controller != null
            ? _buildPlayer()
            : _buildThumbnail(),

        // Fallback jika YouTube menolak embedded playback.
        if (_isPlaying && _controller != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            color: const Color(0xFFF8F9FC),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: Color(0xFF667085),
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Jika video tidak dapat diputar di aplikasi, '
                    'buka langsung di YouTube.',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 9.5,
                      height: 1.3,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openYoutube,
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 14,
                  ),
                  label: const Text(
                    'YouTube',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }
}
