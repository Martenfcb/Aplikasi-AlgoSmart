import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/latihan_model.dart';
import '../../services/latihan_service.dart';

class KerjakanLatihanPage extends StatefulWidget {
  final String latihanId;

  const KerjakanLatihanPage({
    super.key,
    required this.latihanId,
  });

  @override
  State<KerjakanLatihanPage> createState() =>
      _KerjakanLatihanPageState();
}

class _KerjakanLatihanPageState
    extends State<KerjakanLatihanPage> {
  final LatihanService _service =
      LatihanService();

  bool _loading = true;
  bool _submitting = false;

  LatihanModel? _latihan;

  int _currentIndex = 0;

  final List<dynamic> _jawabanSiswa = [];

  @override
  void initState() {
    super.initState();
    _loadLatihan();
  }

  // ============================================================
  // LOAD LATIHAN
  // ============================================================

  Future<void> _loadLatihan() async {
    setState(() {
      _loading = true;
    });

    try {
      final latihan =
          await _service.getLatihanById(
        widget.latihanId,
      );

      if (latihan == null) {
        throw Exception(
          'Latihan tidak ditemukan.',
        );
      }

      final List<SoalLatihanModel> soal = latihan.soal;

      if (soal.isEmpty) {
        throw Exception(
          'Latihan ini belum memiliki soal.',
        );
      }

      setState(() {
        _latihan = latihan;

        _jawabanSiswa.clear();

        _jawabanSiswa.addAll(
          List<dynamic>.filled(
            soal.length,
            null,
          ),
        );

        _currentIndex = 0;

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Gagal memuat latihan.\n$e',
        Colors.red,
      );
    }
  }

  // ============================================================
  // GET SOAL
  // ============================================================

  List<SoalLatihanModel> get _soalList {
    return _latihan?.soal ?? const <SoalLatihanModel>[];
  }

  SoalLatihanModel get _soalSekarang {
    return _soalList[_currentIndex];
  }

  int get _totalSoal => _soalList.length;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F7FB),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4F46E5),
          ),
        ),
      );
    }

    if (_latihan == null ||
        _soalList.isEmpty) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor:
              const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          title: const Text(
            'Kerjakan Latihan',
          ),
        ),
        body: _buildEmptyState(),
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
        centerTitle: true,

        title: Text(
          _latihan!.judul,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            _buildProgress(),

            Expanded(
              child:
                  SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  30,
                ),

                child: Column(
                  children: [
                    _buildThemeCard(),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildQuestionNumber(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildQuestionCard(),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildAnswerSection(),

                    const SizedBox(
                      height: 25,
                    ),

                    _buildNavigation(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    final progress =
        (_currentIndex + 1) /
            _totalSoal;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding:
          const EdgeInsets.fromLTRB(
        16,
        13,
        16,
        14,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_rounded,
                color:
                    Color(0xFF4F46E5),
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                'Soal ${_currentIndex + 1}',
                style:
                    const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      Color(0xFF1F2937),
                ),
              ),

              const Spacer(),

              Text(
                '$_totalSoal Soal',
                style:
                    TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  const Color(
                0xFFE5E7EB,
              ),
              color:
                  const Color(
                0xFF4F46E5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEMA
  // ============================================================

  Widget _buildThemeCard() {
    final judul = _latihan!.judul;

    final materi =
        _latihan!.materi;

    final tingkat =
        _latihan!.tingkat;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFF4F46E5,
            ).withValues(alpha: .20),
            blurRadius: 18,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withValues(alpha: 
                .15,
              ),
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),

            child: const Icon(
              Icons.assignment_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Materi: $materi',
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    _badge(
                      tingkat
                          .toUpperCase(),
                    ),

                    const SizedBox(
                      width: 7,
                    ),

                    _badge(
                      '$_totalSoal SOAL',
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

  Widget _badge(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 
          .15,
        ),
        borderRadius:
            BorderRadius.circular(
          8,
        ),
      ),

      child: Text(
        text,
        style:
            const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }

  // ============================================================
  // QUESTION NUMBER
  // ============================================================

  Widget _buildQuestionNumber() {
    return Row(
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
            shape:
                BoxShape.circle,
          ),

          child: Text(
            '${_currentIndex + 1}',
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Pertanyaan',
                style:
                    TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Pilih jawaban yang paling tepat.',
                style:
                    TextStyle(
                  fontSize: 11,
                  color:
                      Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard() {
    final pertanyaan =
        _soalSekarang.pertanyaan;

    final poin = _soalSekarang.poin;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFE5E7EB,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(alpha: 
              .035,
            ),
            blurRadius: 15,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color:
                    Color(0xFF4F46E5),
                size: 21,
              ),

              const SizedBox(width: 8),

              const Text(
                'Soal',
                style:
                    TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      Color(0xFF4F46E5),
                ),
              ),

              const Spacer(),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      Colors.orange
                          .withValues(alpha: 
                    .10,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    8,
                  ),
                ),
                child: Text(
                  '$poin poin',
                  style:
                      const TextStyle(
                    color:
                        Colors.orange,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            pertanyaan,
            style:
                const TextStyle(
              fontSize: 16,
              height: 1.65,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER SECTION
  // ============================================================

  Widget _buildAnswerSection() {
    final tipe =
        _soalSekarang.tipe;

    if (tipe ==
        'benar_salah') {
      return _buildBenarSalah();
    }

    if (tipe ==
        'isian_singkat') {
      return _buildIsianSingkat();
    }

    return _buildPilihanGanda();
  }

  // ============================================================
  // PILIHAN GANDA
  // ============================================================

  Widget _buildPilihanGanda() {
    final Map<String, dynamic> pilihan =
        Map<String, dynamic>.from(_soalSekarang.pilihan);

    if (pilihan.isEmpty) {
      return _buildNoAnswer();
    }

    final keys = [
      'a',
      'b',
      'c',
      'd',
    ];

    return Column(
      children: keys
          .where(
            (key) =>
                pilihan.containsKey(
              key,
            ),
          )
          .map(
            (key) {
              final value =
                  pilihan[key]
                          ?.toString() ??
                      '';

              final selected =
                  _jawabanSiswa[
                          _currentIndex]
                      ?.toString() ==
                  key;

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child:
                    _buildOption(
                  key: key,
                  value: value,
                  selected:
                      selected,
                  onTap: () {
                    setState(() {
                      _jawabanSiswa[
                              _currentIndex] =
                          key;
                    });
                  },
                ),
              );
            },
          )
          .toList(),
    );
  }

  // ============================================================
  // OPTION
  // ============================================================

  Widget _buildOption({
    required String key,
    required String value,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),

          width: double.infinity,

          padding:
              const EdgeInsets.all(
            15,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(
                    0xFFEDE9FE,
                  )
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
              17,
            ),

            border: Border.all(
              color: selected
                  ? const Color(
                      0xFF4F46E5,
                    )
                  : const Color(
                      0xFFE5E7EB,
                    ),
              width:
                  selected ? 2 : 1,
            ),

            boxShadow: selected
                ? [
                    BoxShadow(
                      color:
                          const Color(
                        0xFF4F46E5,
                      ).withValues(alpha: 
                        .10,
                      ),
                      blurRadius: 10,
                      offset:
                          const Offset(
                        0,
                        4,
                      ),
                    ),
                  ]
                : null,
          ),

          child: Row(
            children: [
              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),

                width: 40,
                height: 40,

                alignment:
                    Alignment.center,

                decoration:
                    BoxDecoration(
                  color: selected
                      ? const Color(
                          0xFF4F46E5,
                        )
                      : const Color(
                          0xFFF3F4F6,
                        ),
                  shape:
                      BoxShape.circle,
                ),

                child: Text(
                  key.toUpperCase(),
                  style:
                      TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(
                            0xFF4B5563,
                          ),
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child: Text(
                  value,
                  style:
                      TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: selected
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color:
                        const Color(
                      0xFF1F2937,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Icon(
                selected
                    ? Icons
                        .check_circle_rounded
                    : Icons
                        .radio_button_unchecked_rounded,
                color: selected
                    ? const Color(
                        0xFF4F46E5,
                      )
                    : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BENAR SALAH
  // ============================================================

  Widget _buildBenarSalah() {
    final selected =
        _jawabanSiswa[
                  _currentIndex]
              ?.toString();

    return Column(
      children: [
        _buildTrueFalse(
          value: 'benar',
          title: 'Benar',
          icon:
              Icons.check_circle_rounded,
          selected:
              selected == 'benar',
        ),

        const SizedBox(
          height: 12,
        ),

        _buildTrueFalse(
          value: 'salah',
          title: 'Salah',
          icon:
              Icons.cancel_rounded,
          selected:
              selected == 'salah',
        ),
      ],
    );
  }

  Widget _buildTrueFalse({
    required String value,
    required String title,
    required IconData icon,
    required bool selected,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          17,
        ),

        onTap: () {
          setState(() {
            _jawabanSiswa[
                    _currentIndex] =
                value;
          });
        },

        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),

          width: double.infinity,

          padding:
              const EdgeInsets.all(
            18,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(
                    0xFFEDE9FE,
                  )
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
              17,
            ),

            border: Border.all(
              color: selected
                  ? const Color(
                      0xFF4F46E5,
                    )
                  : const Color(
                      0xFFE5E7EB,
                    ),
              width:
                  selected ? 2 : 1,
            ),
          ),

          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? const Color(
                        0xFF4F46E5,
                      )
                    : Colors.grey.shade500,
                size: 30,
              ),

              const SizedBox(
                width: 14,
              ),

              Text(
                title,
                style:
                    TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w900,
                  color: selected
                      ? const Color(
                          0xFF4F46E5,
                        )
                      : const Color(
                          0xFF374151,
                        ),
                ),
              ),

              const Spacer(),

              if (selected)
                const Icon(
                  Icons
                      .check_circle_rounded,
                  color:
                      Color(0xFF4F46E5),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ISIAN SINGKAT
  // ============================================================

  Widget _buildIsianSingkat() {
    final current =
        _jawabanSiswa[
                  _currentIndex]
              ?.toString() ??
            '';

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        17,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              const Color(
            0xFFE5E7EB,
          ),
        ),
      ),

      child: TextFormField(
        initialValue:
            current.isEmpty
                ? null
                : current,

        maxLines: 4,

        onChanged: (value) {
          _jawabanSiswa[
                  _currentIndex] =
              value;
        },

        decoration:
            InputDecoration(
          hintText:
              'Tuliskan jawaban kamu...',

          hintStyle:
              TextStyle(
            color:
                Colors.grey.shade400,
            fontSize: 13,
          ),

          prefixIcon:
              const Padding(
            padding:
                EdgeInsets.only(
              bottom: 55,
            ),
            child: Icon(
              Icons.edit_note_rounded,
              color:
                  Color(0xFF4F46E5),
            ),
          ),

          border:
              InputBorder.none,
        ),
      ),
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  Widget _buildNavigation() {
    final isFirst =
        _currentIndex == 0;

    final isLast =
        _currentIndex ==
            _totalSoal - 1;

    final sudahDijawab =
        _jawabanSiswa[
                _currentIndex] !=
            null &&
        _jawabanSiswa[
                _currentIndex]
            .toString()
            .trim()
            .isNotEmpty;

    return Column(
      children: [
        if (!sudahDijawab)
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              12,
            ),
            margin:
                const EdgeInsets.only(
              bottom: 12,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.orange
                      .withValues(alpha: 
                .08,
              ),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color:
                      Colors.orange,
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pilih jawaban sebelum melanjutkan.',
                    style:
                        TextStyle(
                      color:
                          Colors.orange,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

        Row(
          children: [
            if (!isFirst)
              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed:
                      _submitting
                          ? null
                          : () {
                              setState(() {
                                _currentIndex--;
                              });
                            },

                  icon:
                      const Icon(
                    Icons
                        .arrow_back_rounded,
                  ),

                  label:
                      const Text(
                    'Sebelumnya',
                  ),

                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        const Color(
                      0xFF4F46E5,
                    ),
                    side:
                        const BorderSide(
                      color:
                          Color(
                        0xFF4F46E5,
                      ),
                    ),
                    minimumSize:
                        const Size(
                      double.infinity,
                      52,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        15,
                      ),
                    ),
                  ),
                ),
              ),

            if (!isFirst)
              const SizedBox(
                width: 10,
              ),

            Expanded(
              child:
                  ElevatedButton.icon(
                onPressed:
                    !sudahDijawab ||
                            _submitting
                        ? null
                        : () {
                            if (isLast) {
                              _konfirmasiSelesai();
                            } else {
                              setState(() {
                                _currentIndex++;
                              });
                            }
                          },

                icon: _submitting
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2,
                          color:
                              Colors.white,
                        ),
                      )
                    : Icon(
                        isLast
                            ? Icons
                                .check_rounded
                            : Icons
                                .arrow_forward_rounded,
                      ),

                label:
                    Text(
                  isLast
                      ? 'Selesai'
                      : 'Lanjut',
                ),

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF4F46E5,
                  ),
                  foregroundColor:
                      Colors.white,
                  disabledBackgroundColor:
                      Colors.grey
                          .shade300,
                  disabledForegroundColor:
                      Colors.grey
                          .shade600,
                  minimumSize:
                      const Size(
                    double.infinity,
                    52,
                  ),
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // KONFIRMASI SELESAI
  // ============================================================

  Future<void> _konfirmasiSelesai() async {
    final belumDijawab =
        _jawabanSiswa
            .where(
              (item) =>
                  item == null ||
                  item.toString()
                      .trim()
                      .isEmpty,
            )
            .length;

    if (belumDijawab > 0) {
      final lanjut =
          await showDialog<bool>(
        context: context,
        builder:
            (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),

            title:
                const Row(
              children: [
                Icon(
                  Icons
                      .warning_amber_rounded,
                  color:
                      Colors.orange,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Masih ada soal',
                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),

            content: Text(
              'Masih ada $belumDijawab soal yang belum dijawab. '
              'Apakah kamu yakin ingin menyelesaikan latihan?',
              style:
                  const TextStyle(
                height: 1.5,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  false,
                ),
                child:
                    const Text(
                  'Periksa Lagi',
                ),
              ),

              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  true,
                ),
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF4F46E5,
                  ),
                  foregroundColor:
                      Colors.white,
                ),
                child:
                    const Text(
                  'Tetap Selesai',
                ),
              ),
            ],
          );
        },
      );

      if (lanjut != true) {
        return;
      }
    }

    await _selesaikanLatihan();
  }

  // ============================================================
  // SELESAIKAN
  // ============================================================

  Future<void> _selesaikanLatihan() async {
    if (_submitting) return;

    setState(() {
      _submitting = true;
    });

    try {
      int benar = 0;
      int salah = 0;

      int totalPoin = 0;
      int poinDidapat = 0;

      for (
        int i = 0;
        i < _soalList.length;
        i++
      ) {
        final soal = _soalList[i];

        final jawabanBenar = soal.jawaban;

        final jawabanSiswa = _jawabanSiswa[i];

        final poin = soal.poin;

        totalPoin += poin;

        if (_cekJawaban(
          jawabanSiswa,
          jawabanBenar,
        )) {
          benar++;
          poinDidapat += poin;
        } else {
          salah++;
        }
      }

      await _simpanHasil(
        benar: benar,
        salah: salah,
        poinDidapat:
            poinDidapat,
        totalPoin: totalPoin,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HasilLatihanPage(
            judul: _latihan!.judul,
            totalSoal:
                _totalSoal,
            benar: benar,
            salah: salah,
            poinDidapat:
                poinDidapat,
            totalPoin:
                totalPoin,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _submitting = false;
      });

      _showMessage(
        'Gagal menyelesaikan latihan.\n$e',
        Colors.red,
      );
    }
  }

  // ============================================================
  // SIMPAN HASIL FIRESTORE
  // ============================================================

  Future<void> _simpanHasil({
    required int benar,
    required int salah,
    required int poinDidapat,
    required int totalPoin,
  }) async {
    final user =
        FirebaseAuth
            .instance
            .currentUser;

    if (user == null) {
      return;
    }

    final firestore =
        _service.firestore;

    await firestore
        .collection(
          'hasil_latihan',
        )
        .add({
      'userId': user.uid,

      'latihanId':
          widget.latihanId,

      'judul':
          _latihan!.judul,

      'totalSoal':
          _totalSoal,

      'benar':
          benar,

      'salah':
          salah,

      'poinDidapat':
          poinDidapat,

      'totalPoin':
          totalPoin,

      'nilai':
          totalPoin == 0
              ? 0
              : (poinDidapat /
                      totalPoin) *
                  100,

      'createdAt':
          DateTime.now(),
    });
  }

  // ============================================================
  // CEK JAWABAN
  // ============================================================

  bool _cekJawaban(
    dynamic jawabanSiswa,
    dynamic jawabanBenar,
  ) {
    if (jawabanSiswa == null ||
        jawabanBenar == null) {
      return false;
    }

    final siswa =
        jawabanSiswa
            .toString()
            .trim()
            .toLowerCase();

    final benar =
        jawabanBenar
            .toString()
            .trim()
            .toLowerCase();

    return siswa == benar;
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          25,
        ),

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
                    Color(0xFFEDE9FE),
                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .assignment_late_rounded,
                color:
                    Color(0xFF4F46E5),
                size: 45,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Soal Belum Tersedia',
              style:
                  TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Latihan ini belum memiliki soal yang dapat dikerjakan.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color:
                    Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NO ANSWER
  // ============================================================

  Widget _buildNoAnswer() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          17,
        ),
        border: Border.all(
          color:
              const Color(
            0xFFE5E7EB,
          ),
        ),
      ),

      child: const Text(
        'Pilihan jawaban belum tersedia.',
        textAlign:
            TextAlign.center,
        style:
            TextStyle(
          color:
              Color(0xFF6B7280),
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(
      context,
    )
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            maxLines: 4,
            overflow:
                TextOverflow.ellipsis,
          ),
          backgroundColor:
              color,
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(
            16,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      );
  }

  // ============================================================
  // INTEGER
  // ============================================================

  int _toInt(
    dynamic value,
    int fallback,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ??
              '',
        ) ??
        fallback;
  }
}

// ==================================================================
// HASIL LATIHAN
// ==================================================================

class HasilLatihanPage
    extends StatelessWidget {
  final String judul;

  final int totalSoal;
  final int benar;
  final int salah;

  final int poinDidapat;
  final int totalPoin;

  const HasilLatihanPage({
    super.key,
    required this.judul,
    required this.totalSoal,
    required this.benar,
    required this.salah,
    required this.poinDidapat,
    required this.totalPoin,
  });

  double get nilai {
    if (totalPoin == 0) {
      return 0;
    }

    return (poinDidapat /
            totalPoin) *
        100;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final lulus =
        nilai >= 70;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      appBar: AppBar(
        automaticallyImplyLeading:
            false,

        elevation: 0,

        backgroundColor:
            const Color(0xFF4F46E5),

        foregroundColor:
            Colors.white,

        centerTitle: true,

        title:
            const Text(
          'Hasil Latihan',
          style:
              TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),

      body:
          SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(),

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),

            Container(
              width: 105,
              height: 105,

              decoration:
                  BoxDecoration(
                color: lulus
                    ? const Color(
                        0xFFDCFCE7,
                      )
                    : const Color(
                        0xFFFFEDD5,
                      ),
                shape:
                    BoxShape.circle,
              ),

              child: Icon(
                lulus
                    ? Icons
                        .emoji_events_rounded
                    : Icons
                        .school_rounded,
                color: lulus
                    ? const Color(
                        0xFF16A34A,
                      )
                    : const Color(
                        0xFFF97316,
                      ),
                size: 52,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              lulus
                  ? 'Latihan Selesai! 🎉'
                  : 'Tetap Semangat! 💪',

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF1F2937),
              ),
            ),

            const SizedBox(
              height: 7,
            ),

            Text(
              judul,

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                fontSize: 13,
                color:
                    Colors.grey.shade600,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // NILAI
            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                25,
              ),

              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                  25,
                ),

                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(
                      0xFF4F46E5,
                    ).withValues(alpha: 
                      .18,
                    ),
                    blurRadius: 20,
                    offset:
                        const Offset(
                      0,
                      8,
                    ),
                  ),
                ],
              ),

              child: Column(
                children: [
                  const Text(
                    'NILAI AKHIR',
                    style:
                        TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing:
                          1.2,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    nilai.toStringAsFixed(
                      0,
                    ),

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 55,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  Text(
                    '$poinDidapat / $totalPoin poin',

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      _resultCard(
                    icon: Icons
                        .assignment_rounded,
                    title: 'Soal',
                    value:
                        '$totalSoal',
                    color:
                        const Color(
                      0xFF4F46E5,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child:
                      _resultCard(
                    icon: Icons
                        .check_circle_rounded,
                    title: 'Benar',
                    value:
                        '$benar',
                    color:
                        Colors.green,
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child:
                      _resultCard(
                    icon: Icons
                        .cancel_rounded,
                    title: 'Salah',
                    value:
                        '$salah',
                    color:
                        Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 54,

              child:
                  ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },

                icon:
                    const Icon(
                  Icons
                      .arrow_back_rounded,
                ),

                label:
                    const Text(
                  'Kembali ke Latihan',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                style:
                    ElevatedButton
                        .styleFrom(
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
                        BorderRadius
                            .circular(
                      16,
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

  Widget _resultCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 8,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border: Border.all(
          color:
              color.withValues(alpha: 
            .12,
          ),
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 23,
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            value,
            style:
                TextStyle(
              color: color,
              fontSize: 20,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            title,
            style:
                TextStyle(
              color:
                  Colors.grey.shade600,
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
