import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'widgets/siswa_bottom_navigation.dart';

class DetailMateriPage extends StatelessWidget {
  final String judul;
  final String deskripsi;
  final String link;

  const DetailMateriPage({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.link,
  });

  // ============================================================
  // BUKA MATERI
  // ============================================================

  void bukaMateri(BuildContext context) {
    final String urlText = link.trim();

    if (urlText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xffDC2626),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
                  "Link materi tidak tersedia.",
                ),
              ),
            ],
          ),
        ),
      );

      return;
    }

    final Uri? uri = Uri.tryParse(urlText);

    if (uri == null ||
        !(uri.scheme == 'http' ||
            uri.scheme == 'https')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xffDC2626),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Row(
            children: [
              Icon(
                Icons.link_off_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Format link materi tidak valid.",
                ),
              ),
            ],
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MateriWebViewPage(
          judul: judul,
          link: urlText,
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
      backgroundColor: const Color(0xffF4F7FC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff172033),

        title: const Text(
          "Detail Materi",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double horizontalPadding =
                constraints.maxWidth >= 900 ? 50 : 20;

            final double maxWidth =
                constraints.maxWidth >= 1000
                    ? 900
                    : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),

                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // ==========================================
                      // HEADER MATERI
                      // ==========================================

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(25),

                        decoration:
                            BoxDecoration(
                          gradient:
                              const LinearGradient(
                            begin:
                                Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff4F46E5),
                              Color(0xff7C3AED),
                            ],
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xff4F46E5,
                              ).withValues(
                                alpha: .25,
                              ),
                              blurRadius: 25,
                              offset:
                                  const Offset(
                                0,
                                12,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            // LOGO

                            Container(
                              width: 58,
                              height: 58,

                              decoration:
                                  BoxDecoration(
                                color: Colors.white
                                    .withValues(
                                  alpha: .18,
                                ),
                                shape:
                                    BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons
                                    .menu_book_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),

                            const SizedBox(
                              height: 22,
                            ),

                            // JUDUL

                            Text(
                              judul.isEmpty
                                  ? "Materi Pembelajaran"
                                  : judul,

                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight:
                                    FontWeight.w900,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Row(
                              children: [
                                Icon(
                                  Icons
                                      .school_rounded,
                                  color:
                                      Colors.white70,
                                  size: 16,
                                ),

                                SizedBox(width: 7),

                                Text(
                                  "Materi Pembelajaran",
                                  style: TextStyle(
                                    color:
                                        Colors.white70,
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==========================================
                      // DESKRIPSI
                      // ==========================================

                      const Text(
                        "Deskripsi Materi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w900,
                          color: Color(0xff172033),
                        ),
                      ),

                      const SizedBox(height: 13),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(20),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),

                          border: Border.all(
                            color: Colors.black
                                .withValues(
                              alpha: .04,
                            ),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: .04,
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

                        child: Text(
                          deskripsi.isEmpty
                              ? "Tidak ada deskripsi materi."
                              : deskripsi,

                          style:
                              const TextStyle(
                            color:
                                Color(0xff4B5563),
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==========================================
                      // FILE MATERI
                      // ==========================================

                      const Text(
                        "File Materi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w900,
                          color: Color(0xff172033),
                        ),
                      ),

                      const SizedBox(height: 13),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(18),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: .04,
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

                        child: Row(
                          children: [
                            // ICON PDF

                            Container(
                              width: 60,
                              height: 60,

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xffEF4444,
                                ).withValues(
                                  alpha: .10,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  17,
                                ),
                              ),

                              child: const Icon(
                                Icons
                                    .picture_as_pdf_rounded,
                                color:
                                    Color(0xffEF4444),
                                size: 31,
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // TEXT

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  Text(
                                    "Materi Pembelajaran",
                                    style:
                                        TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight
                                              .w800,
                                      color: Color(
                                        0xff172033,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),

                                  Text(
                                    "Materi tersedia dalam bentuk PDF.",
                                    style:
                                        TextStyle(
                                      color: Color(
                                        0xff6B7280,
                                      ),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==========================================
                      // TOMBOL BACA MATERI
                      // ==========================================

                      SizedBox(
                        width: double.infinity,
                        height: 58,

                        child:
                            ElevatedButton.icon(
                          onPressed: () {
                            bukaMateri(context);
                          },

                          icon: const Icon(
                            Icons
                                .menu_book_rounded,
                            size: 21,
                          ),

                          label: const Text(
                            "BACA MATERI",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w900,
                              letterSpacing: .6,
                            ),
                          ),

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xff4F46E5,
                            ),

                            foregroundColor:
                                Colors.white,

                            elevation: 5,

                            shadowColor:
                                const Color(
                              0xff4F46E5,
                            ).withValues(
                              alpha: .30,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==========================================
                      // INFO
                      // ==========================================

                      Center(
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons
                                  .security_rounded,
                              size: 13,
                              color:
                                  Colors.grey.shade500,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Text(
                              "Materi dibuka di dalam aplikasi",
                              style: TextStyle(
                                color: Colors
                                    .grey
                                    .shade500,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 1,
      ),
);
  }
}

// =================================================================
// HALAMAN WEBVIEW MATERI
// =================================================================

class MateriWebViewPage extends StatefulWidget {
  final String judul;
  final String link;

  const MateriWebViewPage({
    super.key,
    required this.judul,
    required this.link,
  });

  @override
  State<MateriWebViewPage> createState() =>
      _MateriWebViewPageState();
}

// =================================================================
// STATE WEBVIEW
// =================================================================

class _MateriWebViewPageState
    extends State<MateriWebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // WEBVIEW CONTROLLER
    // ==========================================================

    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..loadRequest(
        Uri.parse(widget.link),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
            const Color(0xff4F46E5),

        foregroundColor: Colors.white,

        elevation: 0,

        title: Text(
          widget.judul.isEmpty
              ? "Materi"
              : widget.judul,

          maxLines: 1,

          overflow:
              TextOverflow.ellipsis,

          style: const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        actions: [
          // ====================================================
          // REFRESH
          // ====================================================

          IconButton(
            tooltip: "Muat ulang materi",

            onPressed: () {
              controller.reload();
            },

            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      // ========================================================
      // WEBVIEW
      // ========================================================

      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}