import 'package:flutter/material.dart';

import '../../models/latihan_model.dart';
import '../../services/latihan_service.dart';
import 'tambah_latihan_page.dart';

class KelolaLatihanPage extends StatefulWidget {
  const KelolaLatihanPage({
    super.key,
  });

  @override
  State<KelolaLatihanPage> createState() =>
      _KelolaLatihanPageState();
}

class _KelolaLatihanPageState
    extends State<KelolaLatihanPage> {
  final LatihanService _service =
      LatihanService();

  Future<void> _hapus(
    LatihanModel latihan,
  ) async {
    final konfirmasi =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Hapus Latihan?'),

          content: Text(
            'Latihan "${latihan.judul}" '
            'beserta ${latihan.jumlahSoal} soal '
            'akan dihapus.',
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child:
                  const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),
              child:
                  const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) {
      return;
    }

    try {
      await _service.hapusLatihan(
        latihan.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Latihan berhasil dihapus.'),
          backgroundColor:
              Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text('Gagal menghapus: $e'),
          backgroundColor:
              Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      appBar: AppBar(
        title:
            const Text('Kelola Latihan'),
        backgroundColor:
            const Color(0xFF4F46E5),
        foregroundColor:
            Colors.white,
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor:
            const Color(0xFF4F46E5),

        foregroundColor:
            Colors.white,

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const TambahLatihanPage(),
            ),
          );
        },

        icon:
            const Icon(Icons.add),

        label:
            const Text('Latihan Baru'),
      ),

      body: StreamBuilder<List<LatihanModel>>(
        stream:
            _service.streamLatihan(),

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
                'Terjadi kesalahan:\n'
                '${snapshot.error}',
                textAlign:
                    TextAlign.center,
              ),
            );
          }

          final data =
              snapshot.data ?? [];

          if (data.isEmpty) {
            return _empty();
          }

          return ListView.builder(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),

            itemCount:
                data.length,

            itemBuilder:
                (context, index) {
              final latihan =
                  data[index];

              return _item(
                latihan,
              );
            },
          );
        },
      ),
    );
  }

  Widget _item(
    LatihanModel latihan,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

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
                    0xFFEEF2FF,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child:
                    const Icon(
                  Icons.assignment,
                  color:
                      Color(0xFF4F46E5),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      latihan.judul,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      latihan.materi,
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton(
                itemBuilder:
                    (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child:
                        Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'hapus',
                    child:
                        Text('Hapus'),
                  ),
                ],

                onSelected:
                    (value) async {
                  if (value ==
                      'edit') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TambahLatihanPage(
                          latihanId:
                              latihan.id,
                        ),
                      ),
                    );
                  }

                  if (value ==
                      'hapus') {
                    await _hapus(
                      latihan,
                    );
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              _badge(
                Icons.help_outline,
                '${latihan.jumlahSoal} Soal',
              ),

              const SizedBox(width: 8),

              _badge(
                Icons.speed,
                latihan.tingkat,
              ),

              const Spacer(),

              Text(
                latihan.aktif
                    ? 'Aktif'
                    : 'Nonaktif',
                style:
                    TextStyle(
                  color:
                      latihan.aktif
                          ? Colors.green
                          : Colors.red,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color:
                const Color(0xFF4F46E5),
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style:
                const TextStyle(
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 90,
              height: 90,

              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFEEF2FF),
                shape:
                    BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons.assignment,
                size: 45,
                color:
                    Color(0xFF4F46E5),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Belum Ada Latihan',
              style:
                  TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Buat satu tema latihan '
              'dengan beberapa soal.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}