import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

class RiwayatLatihanPage
    extends StatelessWidget {
  const RiwayatLatihanPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Silakan login.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF4F46E5),
        foregroundColor:
            Colors.white,
        centerTitle: true,
        title: const Text(
          'Riwayat Latihan',
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
                .where(
                  'userId',
                  isEqualTo:
                      user.uid,
                )
                .snapshots(),

        builder:
            (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat riwayat.',
              ),
            );
          }

          final docs =
              snapshot.data?.docs ??
                  [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada latihan yang dikerjakan.',
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(
              16,
            ),

            itemCount:
                docs.length,

            itemBuilder:
                (context, index) {
              final data =
                  docs[index].data()
                      as Map<String,
                          dynamic>;

              final bool benar =
                  data['benar'] ==
                      true;

              final int poin =
                  int.tryParse(
                        data['poin']
                                ?.toString() ??
                            '',
                      ) ??
                      0;

              final int total =
                  int.tryParse(
                        data['totalPoin']
                                ?.toString() ??
                            '',
                      ) ??
                      0;

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
                      width: 48,
                      height: 48,

                      decoration:
                          BoxDecoration(
                        color: (benar
                                ? Colors.green
                                : Colors.red)
                            .withValues(
                          alpha: .10,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: Icon(
                        benar
                            ? Icons
                                .check_circle_rounded
                            : Icons
                                .cancel_rounded,

                        color: benar
                            ? Colors.green
                            : Colors.red,
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

                        children: [
                          Text(
                            data['judul']
                                    ?.toString() ??
                                'Latihan',

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w900,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            benar
                                ? 'Benar'
                                : 'Salah',

                            style:
                                TextStyle(
                              color: benar
                                  ? Colors
                                      .green
                                  : Colors
                                      .red,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '$poin/$total',

                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF4F46E5,
                        ),
                        fontSize: 16,
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
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 3,
      ),
);
  }
}