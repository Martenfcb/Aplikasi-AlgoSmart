import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingLatihanPage
    extends StatelessWidget {
  const RankingLatihanPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF59E0B),
        foregroundColor:
            Colors.white,
        centerTitle: true,
        title: const Text(
          'Ranking Latihan',
          style:
              TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot>(
        stream:
            FirebaseFirestore
                .instance
                .collection(
                  'hasil_latihan',
                )
                .snapshots(),

        builder:
            (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final Map<String,
                  Map<String, dynamic>>
              siswa = {};

          for (final doc
              in snapshot.data!.docs) {
            final data =
                doc.data()
                    as Map<String,
                        dynamic>;

            final uid =
                data['userId']
                        ?.toString() ??
                    '';

            final nama =
                data['namaSiswa']
                        ?.toString() ??
                    'Siswa';

            final poin =
                int.tryParse(
                      data['poin']
                              ?.toString() ??
                          '',
                    ) ??
                    0;

            if (!siswa
                .containsKey(uid)) {
              siswa[uid] = {
                'nama': nama,
                'poin': 0,
              };
            }

            siswa[uid]!['poin'] =
                (siswa[uid]!['poin']
                        as int) +
                    poin;
          }

          final ranking =
              siswa.values.toList();

          ranking.sort(
            (a, b) =>
                (b['poin'] as int)
                    .compareTo(
              a['poin'] as int,
            ),
          );

          if (ranking.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada ranking.',
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(
              16,
            ),

            itemCount:
                ranking.length,

            itemBuilder:
                (context, index) {
              final siswa =
                  ranking[index];

              final int posisi =
                  index + 1;

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                padding:
                    const EdgeInsets.all(
                  17,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,

                      alignment:
                          Alignment.center,

                      decoration:
                          BoxDecoration(
                        color:
                            _rankColor(
                          posisi,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),

                      child: Text(
                        '$posisi',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              18,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        siswa['nama']
                            .toString(),
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),
                    ),

                    Text(
                      '${siswa['poin']} poin',
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFFF59E0B,
                        ),
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _rankColor(
    int rank,
  ) {
    if (rank == 1) {
      return const Color(
        0xFFF59E0B,
      );
    }

    if (rank == 2) {
      return const Color(
        0xFF94A3B8,
      );
    }

    if (rank == 3) {
      return const Color(
        0xFFB45309,
      );
    }

    return const Color(
      0xFF4F46E5,
    );
  }
}