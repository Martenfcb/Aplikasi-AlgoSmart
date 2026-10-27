import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/materi_service.dart';
import 'edit_materi_page.dart';
import 'tambah_materi_page.dart';
import 'kelola_video_page.dart';
import 'guru_dashboard.dart';

// ============================================================
// GLOBAL COLORS
// ============================================================

const Color kPrimary = Color(0xFF6366F1);
const Color kPrimaryDark = Color(0xFF4F46E5);
const Color kViolet = Color(0xFF8B5CF6);
const Color kBlue = Color(0xFF2563EB);
const Color kGreen = Color(0xFF10B981);
const Color kOrange = Color(0xFFF59E0B);
const Color kRed = Color(0xFFEF4444);

const Color kLightBackground = Color(0xFFF6F7FB);
const Color kDarkBackground = Color(0xFF080D1A);

// ============================================================
// KELOLA MATERI
// ============================================================

class KelolaMateriPage extends StatefulWidget {
  const KelolaMateriPage({super.key});

  @override
  State<KelolaMateriPage> createState() =>
      _KelolaMateriPageState();
}

class _KelolaMateriPageState extends State<KelolaMateriPage> {
  // ============================================================
  // SERVICE
  // ============================================================

  final MateriService _materiService = MateriService();

  final TextEditingController _searchController =
      TextEditingController();

  String _searchKeyword = '';

  // ============================================================
  // THEME
  // ============================================================

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDark ? kDarkBackground : kLightBackground;

  Color get cardColor =>
      isDark ? const Color(0xFF111827) : Colors.white;

  Color get textColor =>
      isDark ? Colors.white : const Color(0xFF172033);

  Color get subtitleColor =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  Color get borderColor => isDark
      ? Colors.white.withValues(alpha: 0.07)
      : const Color(0xFFE5E7EB);

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SAFE STRING
  // ============================================================

  String _readString(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key];

    if (value == null) {
      return '';
    }

    return value.toString();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  bool _sesuaiPencarian(
    Map<String, dynamic> data,
  ) {
    final keyword = _searchKeyword.toLowerCase();

    if (keyword.isEmpty) {
      return true;
    }

    final judul = _readString(
      data,
      'judul',
    ).toLowerCase();

    final deskripsi = _readString(
      data,
      'deskripsi',
    ).toLowerCase();

    return judul.contains(keyword) ||
        deskripsi.contains(keyword);
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String formatTanggal(dynamic timestamp) {
    if (timestamp == null) {
      return 'Tanggal belum tersedia';
    }

    if (timestamp is! Timestamp) {
      return 'Tanggal belum tersedia';
    }

    final date = timestamp.toDate();

    final hari = date.day.toString().padLeft(2, '0');
    final bulan = date.month.toString().padLeft(2, '0');
    final tahun = date.year.toString();

    return '$hari/$bulan/$tahun';
  }

  // ============================================================
  // TAMBAH MATERI
  // ============================================================

  Future<void> tambahMateri() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahMateriPage(),
      ),
    );

    if (result == true && mounted) {
      _showMessage(
        'Materi berhasil ditambahkan ✓',
      );
    }
  }

  // ============================================================
  // EDIT MATERI
  // ============================================================

  Future<void> editMateri({
    required String docId,
    required String judul,
    required String deskripsi,
    required String link,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMateriPage(
          docId: docId,
          judul: judul,
          deskripsi: deskripsi,
          link: link,
        ),
      ),
    );

    if (result == true && mounted) {
      _showMessage(
        'Materi berhasil diperbarui ✓',
      );
    }
  }

  // ============================================================
  // HAPUS MATERI
  // ============================================================

  Future<void> hapusMateri(
    String docId,
    String judul,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: kRed.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: kRed,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Hapus Materi?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Materi "$judul" akan dihapus dari sistem.\n\nTindakan ini tidak dapat dibatalkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            false,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            true,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: kRed,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size.fromHeight(48),
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

    if (result != true) {
      return;
    }

    try {
      await _materiService.hapusMateri(docId);

      if (!mounted) {
        return;
      }

      _showMessage(
        'Materi berhasil dihapus ✓',
      );
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        e.message ?? 'Gagal menghapus materi.',
        isError: true,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Gagal menghapus materi.',
        isError: true,
      );
    }
  }

  // ============================================================
  // BUKA MATERI DI DALAM APLIKASI
  // ============================================================

  Future<void> bukaMateri(
    String link,
    String judul,
  ) async {
    final value = link.trim();

    if (value.isEmpty) {
      _showMessage(
        'Link materi belum tersedia.',
        isError: true,
      );
      return;
    }

    Uri? uri;

    try {
      uri = Uri.parse(value);
    } catch (_) {
      uri = null;
    }

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' &&
            uri.scheme != 'https')) {
      _showMessage(
        'Link materi tidak valid.',
        isError: true,
      );
      return;
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup materi',
      barrierColor: Colors.black.withValues(
        alpha: 0.72,
      ),
      transitionDuration:
          const Duration(milliseconds: 250),
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return MaterialViewer(
          title: judul,
          url: value,
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.96,
              end: 1.0,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? kRed : kGreen,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          duration:
              const Duration(seconds: 2),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        10,
        14,
        10,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.12 : 0.035,
            ),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  kPrimary,
                  kViolet,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: kPrimary.withValues(
                    alpha: 0.20,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelola Materi',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Materi pembelajaran',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Material(
            color: kPrimary.withValues(
              alpha: 0.10,
            ),
            borderRadius:
                BorderRadius.circular(13),
            child: InkWell(
              onTap: tambahMateri,
              borderRadius:
                  BorderRadius.circular(13),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.add_rounded,
                  color: kPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        2,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          if (!mounted) {
            return;
          }

          setState(() {
            _searchKeyword = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari materi...',
          hintStyle: TextStyle(
            color: subtitleColor,
            fontSize: 12,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: kPrimary.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: kPrimary,
              size: 20,
            ),
          ),
          suffixIcon:
              _searchKeyword.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();

                        if (!mounted) {
                          return;
                        }

                        setState(() {
                          _searchKeyword = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    )
                  : null,
          filled: true,
          fillColor: cardColor,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide:
                const BorderSide(
              color: kPrimary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO HEADER
  // ============================================================

  Widget _buildInfoHeader(
    int jumlah,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        17,
        16,
        4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _searchKeyword.isEmpty
                      ? 'Semua Materi'
                      : 'Hasil Pencarian',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$jumlah materi tersedia',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: kPrimary.withValues(
                alpha: 0.09,
              ),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.library_books_rounded,
                  color: kPrimary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '$jumlah',
                  style: const TextStyle(
                    color: kPrimary,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w900,
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
  // MATERI CARD
  // ============================================================

  Widget _buildMateriCard({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    final judul =
        _readString(data, 'judul');

    final deskripsi =
        _readString(data, 'deskripsi');

    final link =
        _readString(data, 'link');

    final judulTampilan =
        judul.isEmpty
            ? 'Tanpa Judul'
            : judul;

    final tanggal =
        formatTanggal(
      data['createdAt'],
    );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.14 : 0.045,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        kPrimary,
                        kViolet,
                      ],
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      17,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            kPrimary.withValues(
                          alpha: 0.20,
                        ),
                        blurRadius: 12,
                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),
                  child:
                      const Icon(
                    Icons
                        .menu_book_rounded,
                    color:
                        Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        judulTampilan,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w900,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons
                                .calendar_today_rounded,
                            color:
                                subtitleColor,
                            size: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              tanggal,
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style: TextStyle(
                                color:
                                    subtitleColor,
                                fontSize: 9.5,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: subtitleColor,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'lihat') {
                      if (link.isEmpty) {
                        _showMessage(
                          'Link materi belum tersedia.',
                          isError: true,
                        );
                        return;
                      }

                      bukaMateri(
                        link,
                        judulTampilan,
                      );
                    }

                    if (value == 'edit') {
                      editMateri(
                        docId: docId,
                        judul: judul,
                        deskripsi: deskripsi,
                        link: link,
                      );
                    }

                    if (value == 'hapus') {
                      hapusMateri(
                        docId,
                        judulTampilan,
                      );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'lihat',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .visibility_rounded,
                            color: kBlue,
                            size: 19,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Lihat Materi',
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            color: kOrange,
                            size: 19,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Edit Materi',
                          ),
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
                            color: kRed,
                            size: 19,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Hapus Materi',
                            style: TextStyle(
                              color: kRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ==================================================
            // DESKRIPSI
            // ==================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(
                        alpha: 0.035,
                      )
                    : const Color(0xFFF8FAFC),
                borderRadius:
                    BorderRadius.circular(15),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: deskripsi.isEmpty
                  ? Text(
                      'Tidak ada deskripsi materi.',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 10.5,
                        fontStyle:
                            FontStyle.italic,
                      ),
                    )
                  : Text(
                      deskripsi,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // LINK
            // ==================================================

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
                      kBlue.withValues(
                    alpha:
                        isDark ? 0.10 : 0.055,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration:
                          BoxDecoration(
                        color:
                            kBlue.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child:
                          const Icon(
                        Icons.link_rounded,
                        color: kBlue,
                        size: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Expanded(
                      child: Text(
                        link,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color: kBlue,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 13),

            // ==================================================
            // ACTION
            // ==================================================

            Row(
              children: [
                Expanded(
                  flex: 5,
                  child:
                      FilledButton.icon(
                    onPressed:
                        link.isEmpty
                            ? null
                            : () {
                                bukaMateri(
                                  link,
                                  judulTampilan,
                                );
                              },
                    icon: const Icon(
                      Icons.visibility_rounded,
                      size: 17,
                    ),
                    label: const Text(
                      'Lihat Materi',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    style:
                        FilledButton.styleFrom(
                      backgroundColor:
                          kPrimary,
                      foregroundColor:
                          Colors.white,
                      disabledBackgroundColor:
                          subtitleColor
                              .withValues(
                        alpha: 0.12,
                      ),
                      disabledForegroundColor:
                          subtitleColor,
                      minimumSize:
                          const Size.fromHeight(
                        45,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  flex: 4,
                  child:
                      OutlinedButton.icon(
                    onPressed: () {
                      editMateri(
                        docId: docId,
                        judul: judul,
                        deskripsi:
                            deskripsi,
                        link: link,
                      );
                    },
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 17,
                    ),
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          kOrange,
                      side: BorderSide(
                        color:
                            kOrange.withValues(
                          alpha: 0.35,
                        ),
                      ),
                      minimumSize:
                          const Size.fromHeight(
                        45,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                SizedBox(
                  width: 45,
                  height: 45,
                  child: Material(
                    color:
                        kRed.withValues(
                      alpha: 0.09,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    child: InkWell(
                      onTap: () {
                        hapusMateri(
                          docId,
                          judulTampilan,
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      child: const Icon(
                        Icons
                            .delete_outline_rounded,
                        color: kRed,
                        size: 20,
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
            const EdgeInsets.all(28),
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
                    const LinearGradient(
                  colors: [
                    kPrimary,
                    kViolet,
                  ],
                  begin:
                      Alignment.topLeft,
                  end:
                      Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(
                  32,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        kPrimary.withValues(
                      alpha: 0.20,
                    ),
                    blurRadius: 25,
                    offset:
                        const Offset(
                      0,
                      10,
                    ),
                  ),
                ],
              ),
              child: Icon(
                searching
                    ? Icons
                        .search_off_rounded
                    : Icons
                        .menu_book_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              searching
                  ? 'Materi Tidak Ditemukan'
                  : 'Belum Ada Materi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              searching
                  ? 'Tidak ada materi yang sesuai dengan pencarian.'
                  : 'Belum ada materi pembelajaran yang ditambahkan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            if (!searching) ...[
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: tambahMateri,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: const Text(
                  'Tambah Materi',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      kPrimary,
                  foregroundColor:
                      Colors.white,
                  minimumSize:
                      const Size(
                    180,
                    48,
                  ),
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
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration:
                BoxDecoration(
              color:
                  kPrimary.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),
            child: const Padding(
              padding:
                  EdgeInsets.all(20),
              child:
                  CircularProgressIndicator(
                strokeWidth: 3,
                color: kPrimary,
              ),
            ),
          ),

          const SizedBox(height: 17),

          Text(
            'Memuat materi...',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Mengambil data pembelajaran',
            style: TextStyle(
              color: subtitleColor,
              fontSize: 11,
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
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(28),
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
                    kRed.withValues(
                  alpha: 0.09,
                ),
                shape:
                    BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: kRed,
                size: 42,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Gagal Memuat Materi',
              style: TextStyle(
                color: textColor,
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Terjadi masalah saat mengambil data dari Firebase.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 17),

            OutlinedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Coba Lagi',
              ),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    kPrimary,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
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

  Widget _buildBottomNavigation(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.25 : 0.08,
            ),
            blurRadius: 20,
            offset:
                const Offset(0, -5),
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
              _buildNavItem(
                icon:
                    Icons.dashboard_rounded,
                label: 'Dashboard',
                selected: false,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const GuruDashboard(),
                    ),
                  );
                },
              ),

              _buildNavItem(
                icon:
                    Icons.menu_book_rounded,
                label: 'Materi',
                selected: true,
                onTap: () {},
              ),

              _buildNavItem(
                icon:
                    Icons
                        .ondemand_video_rounded,
                label: 'Video',
                selected: false,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const KelolaVideoPage(),
                    ),
                  );
                },
              ),

              _buildNavItem(
                icon:
                    Icons
                        .account_circle_rounded,
                label: 'Profil',
                selected: false,
                onTap: () {
                  _showMessage(
                    'Menu profil tersedia melalui menu guru.',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              vertical: 6,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 180,
                  ),
                  width:
                      selected ? 48 : 42,
                  height:
                      selected ? 34 : 30,
                  decoration:
                      BoxDecoration(
                    color: selected
                        ? kPrimary.withValues(
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
                    color: selected
                        ? kPrimary
                        : subtitleColor,
                    size:
                        selected ? 21 : 20,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? kPrimary
                        : subtitleColor,
                    fontSize: 9,
                    fontWeight: selected
                        ? FontWeight.w900
                        : FontWeight.w600,
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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      body: SafeArea(
        bottom: false,
        child: StreamBuilder<
            QuerySnapshot<
                Map<String, dynamic>>>(
          stream:
              _materiService.getMateri(),

          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child:
                        _buildLoading(),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child:
                        _buildError(
                      snapshot.error
                          .toString(),
                    ),
                  ),
                ],
              );
            }

            final docs =
                snapshot.data?.docs ?? [];

            final filtered =
                docs.where((doc) {
              final data =
                  doc.data();

              return _sesuaiPencarian(
                data,
              );
            }).toList();

            return Column(
              children: [
                _buildAppBar(),

                _buildSearch(),

                _buildInfoHeader(
                  filtered.length,
                ),

                Expanded(
                  child:
                      filtered.isEmpty
                          ? _buildEmpty()
                          : RefreshIndicator(
                              color:
                                  kPrimary,
                              onRefresh:
                                  () async {
                                setState(
                                  () {},
                                );

                                await Future
                                    .delayed(
                                  const Duration(
                                    milliseconds:
                                        300,
                                  ),
                                );
                              },
                              child:
                                  ListView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(
                                  parent:
                                      BouncingScrollPhysics(),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  25,
                                ),
                                itemCount:
                                    filtered.length,
                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  final doc =
                                      filtered[
                                          index];

                                  return _buildMateriCard(
                                    docId:
                                        doc.id,
                                    data:
                                        doc.data(),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: tambahMateri,
        backgroundColor:
            kPrimary,
        foregroundColor:
            Colors.white,
        elevation: 6,
        child: const Icon(
          Icons.add_rounded,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .endFloat,

      bottomNavigationBar:
          _buildBottomNavigation(
        context,
      ),
    );
  }
}

// ==================================================================
// MATERIAL VIEWER
// ==================================================================

class MaterialViewer extends StatefulWidget {
  final String title;
  final String url;

  const MaterialViewer({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<MaterialViewer> createState() =>
      _MaterialViewerState();
}

class _MaterialViewerState extends State<MaterialViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // WEBVIEW
    // ============================================================

    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ==========================================================
      // APP BAR VIEWER
      // ==========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          tooltip: 'Tutup',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_rounded,
            size: 25,
          ),
        ),

        titleSpacing: 4,

        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    kPrimary,
                    kViolet,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: 'Tutup',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check_rounded,
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),

      // ==========================================================
      // WEBVIEW
      // ==========================================================

      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}