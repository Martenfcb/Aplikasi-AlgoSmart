import 'package:flutter/material.dart';

import '../../services/latihan_service.dart';

class TambahLatihanPage extends StatefulWidget {
  final String? latihanId;

  const TambahLatihanPage({
    super.key,
    this.latihanId,
  });

  @override
  State<TambahLatihanPage> createState() =>
      _TambahLatihanPageState();
}

class _SoalForm {
  String tipe = 'pilihan_ganda';

  final pertanyaanController =
      TextEditingController();

  final opsiAController =
      TextEditingController();

  final opsiBController =
      TextEditingController();

  final opsiCController =
      TextEditingController();

  final opsiDController =
      TextEditingController();

  final jawabanController =
      TextEditingController();

  int poin = 10;

  String jawabanBenar = 'a';

  void dispose() {
    pertanyaanController.dispose();
    opsiAController.dispose();
    opsiBController.dispose();
    opsiCController.dispose();
    opsiDController.dispose();
    jawabanController.dispose();
  }
}

class _TambahLatihanPageState
    extends State<TambahLatihanPage> {
  final LatihanService _service =
      LatihanService();

  final _formKey =
      GlobalKey<FormState>();

  final _judulController =
      TextEditingController();

  final _deskripsiController =
      TextEditingController();

  final _materiController =
      TextEditingController();

  String _tingkat = 'mudah';

  final List<_SoalForm> _soal = [];

  bool _loading = false;

  bool get isEdit =>
      widget.latihanId != null;

  String get title =>
      isEdit
          ? 'Edit Latihan'
          : 'Tambah Latihan';

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _loadData();
    } else {
      _tambahSoal();
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _materiController.dispose();

    for (final soal in _soal) {
      soal.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // LOAD EDIT
  // ============================================================

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });

    try {
      final latihan =
          await _service.getLatihan(
        widget.latihanId!,
      );

      if (latihan == null) {
        throw Exception(
          'Data latihan tidak ditemukan.',
        );
      }

      _judulController.text =
          latihan.judul;

      _deskripsiController.text =
          latihan.deskripsi;

      _materiController.text =
          latihan.materi;

      _tingkat =
          latihan.tingkat;

      for (final data in latihan.soal) {
        final soal = _SoalForm();

        soal.tipe = data.tipe;

        soal.pertanyaanController.text =
            data.pertanyaan;

        soal.poin = data.poin;

        soal.jawabanBenar =
            data.jawaban;

        soal.jawabanController.text =
            data.jawaban;

        soal.opsiAController.text =
            data.pilihan['a'] ?? '';

        soal.opsiBController.text =
            data.pilihan['b'] ?? '';

        soal.opsiCController.text =
            data.pilihan['c'] ?? '';

        soal.opsiDController.text =
            data.pilihan['d'] ?? '';

        _soal.add(soal);
      }

      if (_soal.isEmpty) {
        _tambahSoal();
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _message(
          'Gagal memuat latihan.',
          Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ============================================================
  // TAMBAH SOAL
  // ============================================================

  void _tambahSoal() {
    if (_soal.length >= 50) {
      _message(
        'Maksimal 50 soal dalam satu latihan.',
        Colors.orange,
      );
      return;
    }

    setState(() {
      _soal.add(_SoalForm());
    });
  }

  // ============================================================
  // HAPUS SOAL
  // ============================================================

  void _hapusSoal(int index) {
    if (_soal.length <= 1) {
      _message(
        'Minimal harus ada 1 soal.',
        Colors.orange,
      );
      return;
    }

    setState(() {
      final soal = _soal.removeAt(index);
      soal.dispose();
    });
  }

  // ============================================================
  // SIMPAN
  // ============================================================

  Future<void> _simpan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_soal.isEmpty) {
      _message(
        'Tambahkan minimal 1 soal.',
        Colors.orange,
      );
      return;
    }

    final List<Map<String, dynamic>>
        dataSoal = [];

    for (int i = 0; i < _soal.length; i++) {
      final soal = _soal[i];

      if (soal.tipe ==
          'pilihan_ganda') {
        if (soal.opsiAController.text
                .trim()
                .isEmpty ||
            soal.opsiBController.text
                .trim()
                .isEmpty ||
            soal.opsiCController.text
                .trim()
                .isEmpty ||
            soal.opsiDController.text
                .trim()
                .isEmpty) {
          _message(
            'Pilihan jawaban soal ${i + 1} belum lengkap.',
            Colors.orange,
          );
          return;
        }
      }

      if (soal.tipe ==
          'isian_singkat') {
        if (soal.jawabanController.text
            .trim()
            .isEmpty) {
          _message(
            'Jawaban soal ${i + 1} belum diisi.',
            Colors.orange,
          );
          return;
        }
      }

      final Map<String, String>
          pilihan = {};

      if (soal.tipe ==
          'pilihan_ganda') {
        pilihan.addAll({
          'a': soal.opsiAController.text.trim(),
          'b': soal.opsiBController.text.trim(),
          'c': soal.opsiCController.text.trim(),
          'd': soal.opsiDController.text.trim(),
        });
      }

      final jawaban =
          soal.tipe ==
                  'isian_singkat'
              ? soal.jawabanController.text
                  .trim()
              : soal.jawabanBenar;

      dataSoal.add({
        'pertanyaan':
            soal.pertanyaanController.text
                .trim(),
        'tipe': soal.tipe,
        'pilihan': pilihan,
        'jawaban': jawaban,
        'poin': soal.poin,
      });
    }

    setState(() {
      _loading = true;
    });

    try {
      if (isEdit) {
        await _service.updateLatihan(
          id: widget.latihanId!,
          judul:
              _judulController.text.trim(),
          deskripsi:
              _deskripsiController.text.trim(),
          materi:
              _materiController.text.trim(),
          tingkat: _tingkat,
          soal: dataSoal,
        );
      } else {
        await _service.tambahLatihan(
          judul:
              _judulController.text.trim(),
          deskripsi:
              _deskripsiController.text.trim(),
          materi:
              _materiController.text.trim(),
          tingkat: _tingkat,
          soal: dataSoal,
        );
      }

      if (!mounted) return;

      _message(
        isEdit
            ? 'Latihan berhasil diperbarui.'
            : 'Latihan berhasil dibuat.',
        Colors.green,
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _message(
        'Gagal menyimpan latihan.\n$e',
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _message(
    String text,
    Color color,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loading &&
        isEdit &&
        _soal.isEmpty) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color(0xFF4F46E5),
        foregroundColor: Colors.white,

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,

        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  100,
                ),

                children: [
                  _buildTema(),

                  const SizedBox(
                    height: 16,
                  ),

                  _buildInfoSoal(),

                  const SizedBox(
                    height: 16,
                  ),

                  ...List.generate(
                    _soal.length,
                    (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child:
                            _buildSoalCard(
                          index,
                        ),
                      );
                    },
                  ),

                  _buildTambahSoalButton(),
                ],
              ),
            ),

            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TEMA
  // ============================================================

  Widget _buildTema() {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Tema Latihan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 16),

          _field(
            controller:
                _judulController,
            label: 'Judul latihan',
            hint:
                'Contoh: Latihan Algoritma Dasar',
            icon: Icons.title,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Judul wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          _field(
            controller:
                _materiController,
            label: 'Materi',
            hint:
                'Contoh: Algoritma',
            icon: Icons.menu_book,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Materi wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          _field(
            controller:
                _deskripsiController,
            label: 'Deskripsi',
            hint:
                'Deskripsi singkat latihan',
            icon: Icons.description,
            maxLines: 3,
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value: _tingkat,
            isExpanded: true,

            decoration:
                _inputDecoration(
              'Tingkat kesulitan',
              Icons.speed,
            ),

            items: const [
              DropdownMenuItem(
                value: 'mudah',
                child: Text('Mudah'),
              ),
              DropdownMenuItem(
                value: 'sedang',
                child: Text('Sedang'),
              ),
              DropdownMenuItem(
                value: 'sulit',
                child: Text('Sulit'),
              ),
            ],

            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _tingkat = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO SOAL
  // ============================================================

  Widget _buildInfoSoal() {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.assignment,
            color: Color(0xFF4F46E5),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Soal ${_soal.length} / 50',
              style: const TextStyle(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          Text(
            '${_soal.length} soal',
            style: const TextStyle(
              color:
                  Color(0xFF4F46E5),
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SOAL CARD
  // ============================================================

  Widget _buildSoalCard(
    int index,
  ) {
    final soal = _soal[index];

    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                alignment:
                    Alignment.center,

                decoration:
                    const BoxDecoration(
                  color:
                      Color(0xFF4F46E5),
                  shape: BoxShape.circle,
                ),

                child: Text(
                  '${index + 1}',
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Soal Latihan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              IconButton(
                onPressed: () =>
                    _hapusSoal(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _field(
            controller:
                soal.pertanyaanController,
            label: 'Pertanyaan',
            hint:
                'Tuliskan pertanyaan...',
            icon: Icons.help_outline,
            maxLines: 4,

            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Pertanyaan wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value: soal.tipe,
            isExpanded: true,

            decoration:
                _inputDecoration(
              'Tipe soal',
              Icons.category,
            ),

            items: const [
              DropdownMenuItem(
                value:
                    'pilihan_ganda',
                child:
                    Text('Pilihan Ganda'),
              ),
              DropdownMenuItem(
                value:
                    'benar_salah',
                child:
                    Text('Benar / Salah'),
              ),
              DropdownMenuItem(
                value:
                    'isian_singkat',
                child:
                    Text('Isian Singkat'),
              ),
            ],

            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                soal.tipe = value;

                if (value ==
                    'pilihan_ganda') {
                  soal.jawabanBenar =
                      'a';
                }

                if (value ==
                    'benar_salah') {
                  soal.jawabanBenar =
                      'benar';
                }
              });
            },
          ),

          const SizedBox(height: 16),

          _buildAnswer(
            soal,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.star,
                size: 20,
                color: Colors.orange,
              ),

              const SizedBox(width: 8),

              const Text(
                'Poin',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const Spacer(),

              DropdownButton<int>(
                value: soal.poin,

                items: const [
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5'),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text('10'),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text('15'),
                  ),
                  DropdownMenuItem(
                    value: 20,
                    child: Text('20'),
                  ),
                ],

                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    soal.poin = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER
  // ============================================================

  Widget _buildAnswer(
    _SoalForm soal,
  ) {
    if (soal.tipe ==
        'pilihan_ganda') {
      return Column(
        children: [
          _option(
            soal.opsiAController,
            'A',
          ),
          const SizedBox(height: 10),
          _option(
            soal.opsiBController,
            'B',
          ),
          const SizedBox(height: 10),
          _option(
            soal.opsiCController,
            'C',
          ),
          const SizedBox(height: 10),
          _option(
            soal.opsiDController,
            'D',
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value:
                soal.jawabanBenar,

            decoration:
                _inputDecoration(
              'Jawaban benar',
              Icons.check_circle,
            ),

            items: const [
              DropdownMenuItem(
                value: 'a',
                child:
                    Text('Pilihan A'),
              ),
              DropdownMenuItem(
                value: 'b',
                child:
                    Text('Pilihan B'),
              ),
              DropdownMenuItem(
                value: 'c',
                child:
                    Text('Pilihan C'),
              ),
              DropdownMenuItem(
                value: 'd',
                child:
                    Text('Pilihan D'),
              ),
            ],

            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                soal.jawabanBenar =
                    value;
              });
            },
          ),
        ],
      );
    }

    if (soal.tipe ==
        'benar_salah') {
      return DropdownButtonFormField<String>(
        value:
            soal.jawabanBenar,

        decoration:
            _inputDecoration(
          'Jawaban benar',
          Icons.check,
        ),

        items: const [
          DropdownMenuItem(
            value: 'benar',
            child: Text('Benar'),
          ),
          DropdownMenuItem(
            value: 'salah',
            child: Text('Salah'),
          ),
        ],

        onChanged: (value) {
          if (value == null) {
            return;
          }

          setState(() {
            soal.jawabanBenar =
                value;
          });
        },
      );
    }

    return _field(
      controller:
          soal.jawabanController,
      label: 'Jawaban benar',
      hint:
          'Contoh: algoritma',
      icon: Icons.check_circle,
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return 'Jawaban wajib diisi';
        }

        return null;
      },
    );
  }

  // ============================================================
  // OPTION
  // ============================================================

  Widget _option(
    TextEditingController controller,
    String label,
  ) {
    return TextFormField(
      controller: controller,

      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return 'Pilihan $label wajib diisi';
        }

        return null;
      },

      decoration:
          _inputDecoration(
        'Pilihan $label',
        Icons.radio_button_checked,
      ),
    );
  }

  // ============================================================
  // TAMBAH SOAL
  // ============================================================

  Widget _buildTambahSoalButton() {
    final penuh =
        _soal.length >= 50;

    return SizedBox(
      width: double.infinity,
      height: 52,

      child: OutlinedButton.icon(
        onPressed:
            penuh ? null : _tambahSoal,

        icon: const Icon(
          Icons.add,
        ),

        label: Text(
          penuh
              ? 'Maksimal 50 Soal'
              : 'Tambah Soal Berikutnya',
        ),

        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              const Color(0xFF4F46E5),

          side:
              const BorderSide(
            color:
                Color(0xFF4F46E5),
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM BUTTON
  // ============================================================

  Widget _buildBottomButton() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.08),
            blurRadius: 15,
            offset:
                const Offset(0, -5),
          ),
        ],
      ),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton.icon(
          onPressed:
              _loading
                  ? null
                  : _simpan,

          icon: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.save,
                ),

          label: Text(
            _loading
                ? 'Menyimpan...'
                : isEdit
                    ? 'Simpan Perubahan'
                    : 'Simpan Latihan',
          ),

          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                const Color(
              0xFF4F46E5,
            ),

            foregroundColor:
                Colors.white,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _card({
    required Widget child,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: child,
    );
  }

  // ============================================================
  // FIELD
  // ============================================================

  Widget _field({
    required TextEditingController
        controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)?
        validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,

      decoration:
          _inputDecoration(
        label,
        icon,
        hint: hint,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon:
          Icon(icon),

      filled: true,

      fillColor:
          const Color(0xFFF8FAFC),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFE5E7EB),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            const BorderSide(
          color:
              Color(0xFF4F46E5),
          width: 1.5,
        ),
      ),
    );
  }
}