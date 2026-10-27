import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HasilLatihanPage
    extends StatelessWidget {
  const HasilLatihanPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          'Hasil Latihan',
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
                'Gagal memuat hasil.',
              ),
            );
          }

          final docs =
              snapshot.data?.docs ??
                  [];

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  Icon(
                    Icons
                        .assessment_outlined,
                    size: 65,
                    color:
                        Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Belum ada hasil latihan.',
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
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

                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black
                              .withValues(
                        alpha: .035,
                      ),
                      blurRadius:
                          15,
                      offset:
                          const Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF4F46E5,
                            ).withValues(
                              alpha: .10,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),
                          child:
                              const Icon(
                            Icons
                                .person_rounded,
                            color:
                                Color(
                              0xFF4F46E5,
                            ),
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
                                data['namaSiswa']
                                        ?.toString() ??
                                    'Siswa',
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),

                              const SizedBox(
                                height: 3,
                              ),

                              Text(
                                data['emailSiswa']
                                        ?.toString() ??
                                    '',
                                style:
                                    const TextStyle(
                                  fontSize:
                                      10,
                                  color:
                                      Color(
                                    0xFF64748B,
                                  ),
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
                            fontSize:
                                17,
                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                        ),
                      ],
                    ),

                    const Divider(
                      height: 25,
                    ),

                    Text(
                      data['judul']
                              ?.toString() ??
                          'Latihan',

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Row(
                      children: [
                        Icon(
                          benar
                              ? Icons
                                  .check_circle_rounded
                              : Icons
                                  .cancel_rounded,
                          size: 18,
                          color: benar
                              ? Colors
                                  .green
                              : Colors
                                  .red,
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Text(
                          benar
                              ? 'Jawaban Benar'
                              : 'Jawaban Salah',
                          style:
                              TextStyle(
                            color: benar
                                ? Colors
                                    .green
                                : Colors
                                    .red,
                            fontWeight:
                                FontWeight
                                    .w800,
                            fontSize:
                                12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      'Jawaban siswa: '
                      '${data['jawabanSiswa'] ?? '-'}',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Color(
                          0xFF64748B,
                        ),
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
}