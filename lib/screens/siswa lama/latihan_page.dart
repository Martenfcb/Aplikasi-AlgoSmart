import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'kerjakan_latihan_page.dart';

class LatihanPage extends StatelessWidget {
  const LatihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color background = dark
        ? const Color(0xFF080D1A)
        : const Color(0xFFF7F8FC);

    final Color card = dark
        ? const Color(0xFF111827)
        : Colors.white;

    final Color text = dark
        ? Colors.white
        : const Color(0xFF172033);

    final Color subtitle = dark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Silakan login terlebih dahulu.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Latihan',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('latihan')
            .where(
              'aktif',
              isEqualTo: true,
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(0xFF4F46E5),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat latihan.\n${snapshot.error}',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: text,
                ),
              ),
            );
          }

          final docs =
              snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return _emptyState(
              text,
              subtitle,
            );
          }

          return StreamBuilder<
              QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection(
                      'hasil_latihan',
                    )
                    .where(
                      'userId',
                      isEqualTo: user.uid,
                    )
                    .snapshots(),

            builder:
                (context, hasilSnapshot) {
              final Map<String, dynamic>
                  hasil = {};

              if (hasilSnapshot
                      .hasData) {
                for (final doc
                    in hasilSnapshot
                        .data!.docs) {
                  final data =
                      doc.data()
                          as Map<String,
                              dynamic>;

                  final latihanId =
                      data['latihanId']
                          ?.toString();

                  if (latihanId != null) {
                    hasil[latihanId] =
                        data;
                  }
                }
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  18,
                  16,
                  30,
                ),

                itemCount:
                    docs.length,

                itemBuilder:
                    (context, index) {
                  final doc =
                      docs[index];

                  final data =
                      doc.data()
                          as Map<String,
                              dynamic>;

                  final sudah =
                      hasil.containsKey(
                    doc.id,
                  );

                  return _LatihanCard(
                    documentId:
                        doc.id,
                    data: data,
                    sudahDikerjakan:
                        sudah,
                    hasil:
                        sudah
                            ? hasil[
                                doc.id]
                            : null,
                    cardColor:
                        card,
                    textColor:
                        text,
                    subtitleColor:
                        subtitle,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _emptyState(
    Color text,
    Color subtitle,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF4F46E5,
                ).withValues(
                  alpha: .10,
                ),
                shape:
                    BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color:
                    Color(0xFF4F46E5),
                size: 45,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Belum Ada Latihan',
              style: TextStyle(
                color: text,
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Guru belum menambahkan latihan.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: subtitle,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatihanCard
    extends StatelessWidget {
  final String documentId;
  final Map<String, dynamic> data;
  final bool sudahDikerjakan;
  final Map<String, dynamic>? hasil;

  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const _LatihanCard({
    required this.documentId,
    required this.data,
    required this.sudahDikerjakan,
    required this.hasil,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final String judul =
        data['judul']?.toString() ??
            'Latihan';

    final String materi =
        data['materi']?.toString() ??
            '-';

    final String tingkat =
        data['tingkat']?.toString() ??
            'mudah';

    final int poin =
        int.tryParse(
              data['poin']
                      ?.toString() ??
                  '',
            ) ??
            0;

    final int nilai =
        int.tryParse(
              hasil?['poin']
                      ?.toString() ??
                  '',
            ) ??
            0;

    final Color warna =
        _tingkatColor(tingkat);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),

      decoration:
          BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border:
            Border.all(
          color: warna.withValues(
            alpha: .12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: .035,
            ),
            blurRadius: 18,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(17),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(
                          0xFF4F46E5,
                        ),
                        Color(
                          0xFF7C3AED,
                        ),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      17,
                    ),
                  ),
                  child: const Icon(
                    Icons
                        .assignment_rounded,
                    color:
                        Colors.white,
                    size: 27,
                  ),
                ),

                const SizedBox(
                  width: 13,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        judul,
                        maxLines: 2,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            TextStyle(
                          color:
                              textColor,
                          fontSize: 16,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        'Materi: $materi',
                        style:
                            TextStyle(
                          color:
                              subtitleColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                if (sudahDikerjakan)
                  const Icon(
                    Icons
                        .check_circle_rounded,
                    color:
                        Color(0xFF10B981),
                  ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            Row(
              children: [
                _chip(
                  Icons
                      .signal_cellular_alt_rounded,
                  tingkat.toUpperCase(),
                  warna,
                ),

                const SizedBox(
                  width: 8,
                ),

                _chip(
                  Icons.stars_rounded,
                  '$poin poin',
                  const Color(
                    0xFFF59E0B,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            if (sudahDikerjakan)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                  13,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF10B981,
                  ).withValues(
                    alpha: .08,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .check_circle_rounded,
                      color:
                          Color(0xFF10B981),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        'Sudah dikerjakan • '
                        'Nilai $nilai/$poin',
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF059669,
                          ),
                          fontWeight:
                              FontWeight
                                  .w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width:
                    double.infinity,
                height: 44,
                child:
                    ElevatedButton.icon(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KerjakanLatihanPage(
                      latihanId: documentId,
                    ),
                  ),
                );
              },
                  icon: const Icon(
                    Icons
                        .play_arrow_rounded,
                  ),
                  label:
                      const Text(
                    'Kerjakan Latihan',
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF4F46E5,
                    ),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
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
          ],
        ),
      ),
    );
  }

  Widget _chip(
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha: .08,
        ),
        borderRadius:
            BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 9.5,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Color _tingkatColor(
    String tingkat,
  ) {
    switch (
        tingkat.toLowerCase()) {
      case 'mudah':
        return const Color(
          0xFF10B981,
        );

      case 'sedang':
        return const Color(
          0xFFF59E0B,
        );

      case 'sulit':
        return const Color(
          0xFFEF4444,
        );

      default:
        return const Color(
          0xFF4F46E5,
        );
    }
  }
}