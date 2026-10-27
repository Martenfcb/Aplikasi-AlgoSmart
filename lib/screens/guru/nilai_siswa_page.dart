import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NilaiSiswaPage extends StatefulWidget {
  const NilaiSiswaPage({super.key});

  @override
  State<NilaiSiswaPage> createState() => _NilaiSiswaPageState();
}

class _NilaiSiswaPageState extends State<NilaiSiswaPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();

  String selectedKelas = 'Semua';
  String selectedJurusan = 'Semua';
  String keyword = '';

  final List<String> daftarKelas = [
    'Semua',
    'X',
    'XI',
    'XII',
  ];

  final List<String> daftarJurusan = [
    'Semua',
    'RPL',
    'TKJ',
    'MM',
    'AKL',
    'OTKP',
  ];

  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color background = Color(0xFFF6F7FB);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('nilai').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return _buildEmpty();
          }

          final data = _filterData(docs);

          return Column(
            children: [
              _buildHeader(docs),
              _buildSearch(),
              _buildFilters(),
              const SizedBox(height: 12),
              Expanded(
                child: data.isEmpty
                    ? _buildFilteredEmpty()
                    : _buildNilaiList(data),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF1F2937),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nilai Siswa',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Kelola hasil latihan siswa',
            style: TextStyle(
              color: Color(0xFF8A90A3),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Hapus semua nilai',
          onPressed: _confirmDeleteAll,
          icon: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_sweep_rounded,
              color: Color(0xFFEF4444),
              size: 21,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final total = docs.length;

    int lulus = 0;
    int belum = 0;

    for (final doc in docs) {
      final data = doc.data();
      final nilai = _getNilai(data);

      if (nilai >= 70) {
        lulus++;
      } else {
        belum++;
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            primaryDark,
            primary,
            Color(0xFF8B5CF6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.assessment_rounded,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(width: 10),
              Text(
                'Data Nilai Siswa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Nilai terbaru akan muncul secara otomatis.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _buildStatistic(
                  icon: Icons.assignment_rounded,
                  value: total.toString(),
                  label: 'Total',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatistic(
                  icon: Icons.check_circle_rounded,
                  value: lulus.toString(),
                  label: '≥ 70',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatistic(
                  icon: Icons.warning_rounded,
                  value: belum.toString(),
                  label: '< 70',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 9,
              fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFE8EAF2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              keyword = value.trim().toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Cari nama atau NIS...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: primary,
              size: 22,
            ),
            suffixIcon: keyword.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        keyword = '';
                      });
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF94A3B8),
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              label: 'Kelas',
              value: selectedKelas,
              items: daftarKelas,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedKelas = value;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdown(
              label: 'Jurusan',
              value: selectedJurusan,
              items: daftarJurusan,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedJurusan = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 11,
          color: Color(0xFF64748B),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: primary,
            width: 1.4,
          ),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  // ============================================================
  // FILTER DATA
  // ============================================================

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filterData(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final result = docs.where((doc) {
      final value = doc.data();

      final nama = (value['nama'] ?? '').toString().toLowerCase();
      final nis = (value['nis'] ?? '').toString().toLowerCase();
      final kelas = (value['kelas'] ?? '').toString();
      final jurusan = (value['jurusan'] ?? '').toString();

      final cocokSearch =
          nama.contains(keyword) || nis.contains(keyword);

      final cocokKelas =
          selectedKelas == 'Semua' || kelas == selectedKelas;

      final cocokJurusan =
          selectedJurusan == 'Semua' ||
          jurusan == selectedJurusan;

      return cocokSearch && cocokKelas && cocokJurusan;
    }).toList();

    // ============================================================
    // DATA TERBARU DI ATAS
    // ============================================================

    result.sort((a, b) {
      final tanggalA = _getTanggal(a.data());
      final tanggalB = _getTanggal(b.data());

      return tanggalB.compareTo(tanggalA);
    });

    return result;
  }

  // ============================================================
  // NILAI LIST
  // ============================================================

  Widget _buildNilaiList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _NilaiCard(
          document: data[index],
          nomor: index + 1,
          onDelete: () {
            _confirmDelete(data[index]);
          },
        );
      },
    );
  }

  // ============================================================
  // CONFIRM DELETE
  // ============================================================

  Future<void> _confirmDelete(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) async {
    final data = document.data();

    final nama = data['nama']?.toString() ?? 'Siswa';
    final quiz = data['quiz']?.toString() ?? 'Latihan';
    final nilai = data['nilai']?.toString() ?? '0';

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFEF4444),
              ),
              SizedBox(width: 10),
              Text(
                'Hapus Nilai?',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Text(
            'Hapus data nilai $nama?\n\n'
            'Quiz: $quiz\n'
            'Nilai: $nilai\n\n'
            'Data yang dihapus tidak dapat dikembalikan.',
            style: const TextStyle(
              height: 1.5,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    try {
      await firestore
          .collection('nilai')
          .doc(document.id)
          .delete();

      if (!mounted) return;

      _showMessage(
        'Data nilai berhasil dihapus.',
        const Color(0xFF10B981),
        Icons.check_circle_rounded,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal menghapus data nilai.',
        const Color(0xFFEF4444),
        Icons.error_outline_rounded,
      );

      debugPrint('Error delete nilai: $e');
    }
  }

  // ============================================================
  // DELETE ALL
  // ============================================================

  Future<void> _confirmDeleteAll() async {
    final snapshot = await firestore.collection('nilai').limit(1).get();

    if (!mounted) return;

    if (snapshot.docs.isEmpty) {
      _showMessage(
        'Belum ada data nilai untuk dihapus.',
        const Color(0xFFF59E0B),
        Icons.info_outline_rounded,
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.delete_sweep_rounded,
                color: Color(0xFFEF4444),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hapus Semua Nilai?',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Semua data pada koleksi nilai akan dihapus.\n\n'
            'Tindakan ini tidak dapat dibatalkan.',
            style: TextStyle(
              height: 1.5,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus Semua'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    await _deleteAllValues();
  }

  // ============================================================
  // DELETE ALL FIRESTORE
  // ============================================================

  Future<void> _deleteAllValues() async {
    try {
      final snapshot = await firestore
          .collection('nilai')
          .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final batch = firestore.batch();

      for (final document in snapshot.docs) {
        batch.delete(document.reference);
      }

      await batch.commit();

      if (!mounted) return;

      _showMessage(
        '${snapshot.docs.length} data nilai berhasil dihapus.',
        const Color(0xFF10B981),
        Icons.delete_sweep_rounded,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal menghapus semua data.',
        const Color(0xFFEF4444),
        Icons.error_outline_rounded,
      );

      debugPrint('Error delete all nilai: $e');
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // GET NILAI
  // ============================================================

  double _getNilai(Map<String, dynamic> data) {
    final value = data['nilai'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ============================================================
  // GET TANGGAL
  // ============================================================

  DateTime _getTanggal(Map<String, dynamic> data) {
    final value = data['tanggal'];

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String _formatTanggal(Map<String, dynamic> data) {
    final tanggal = _getTanggal(data);

    if (tanggal.millisecondsSinceEpoch == 0) {
      return 'Tanggal tidak tersedia';
    }

    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    final tahun = tanggal.year.toString();

    final jam = tanggal.hour.toString().padLeft(2, '0');
    final menit = tanggal.minute.toString().padLeft(2, '0');

    return '$hari/$bulan/$tahun • $jam:$menit';
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: primary,
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    primary,
                    Color(0xFF8B5CF6),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.20),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.assignment_rounded,
                color: Colors.white,
                size: 45,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Belum Ada Data Nilai',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nilai siswa akan muncul otomatis\n'
              'setelah siswa mengerjakan quiz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILTERED EMPTY
  // ============================================================

  Widget _buildFilteredEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 65,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 15),
            const Text(
              'Data Tidak Ditemukan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Coba ubah kata pencarian atau filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFEF4444),
              size: 65,
            ),
            const SizedBox(height: 15),
            const Text(
              'Gagal Memuat Nilai',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NILAI CARD
// ============================================================================

class _NilaiCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  final int nomor;
  final VoidCallback onDelete;

  const _NilaiCard({
    required this.document,
    required this.nomor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final data = document.data();

    final nama = data['nama']?.toString() ?? '-';
    final nis = data['nis']?.toString() ?? '-';
    final kelas = data['kelas']?.toString() ?? '-';
    final jurusan = data['jurusan']?.toString() ?? '-';
    final quiz = data['quiz']?.toString() ?? 'Latihan Quiz';

    final nilai = _getNilai(data);
    final warna = _getWarnaNilai(nilai);
    final status = _getStatusNilai(nilai);
    final tanggal = _formatTanggal(data);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFE8EAF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOMOR
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      nomor.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // DATA SISWA
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF172033),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIS: $nis',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$kelas • $jurusan',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // NILAI
                Container(
                  width: 67,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: warna.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: warna.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'NILAI',
                        style: TextStyle(
                          fontSize: 8,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatNilai(nilai),
                        style: TextStyle(
                          color: warna,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            // QUIZ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.quiz_rounded,
                    color: Color(0xFF6366F1),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quiz,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: warna.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: warna,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 9),

            // TANGGAL + HAPUS
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: Color(0xFF94A3B8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tanggal,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(11),
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFEF4444),
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Hapus',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
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

  double _getNilai(Map<String, dynamic> data) {
    final value = data['nilai'];

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  Color _getWarnaNilai(double nilai) {
    if (nilai >= 85) {
      return const Color(0xFF10B981);
    }

    if (nilai >= 70) {
      return const Color(0xFFF59E0B);
    }

    return const Color(0xFFEF4444);
  }

  String _getStatusNilai(double nilai) {
    if (nilai >= 85) {
      return 'SANGAT BAIK';
    }

    if (nilai >= 70) {
      return 'BAIK';
    }

    return 'PERLU PERBAIKAN';
  }

  String _formatNilai(double nilai) {
    if (nilai == nilai.roundToDouble()) {
      return nilai.toInt().toString();
    }

    return nilai.toStringAsFixed(1);
  }

  DateTime _getTanggal(Map<String, dynamic> data) {
    final value = data['tanggal'];

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _formatTanggal(Map<String, dynamic> data) {
    final tanggal = _getTanggal(data);

    if (tanggal.millisecondsSinceEpoch == 0) {
      return 'Tanggal tidak tersedia';
    }

    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    final tahun = tanggal.year.toString();

    final jam = tanggal.hour.toString().padLeft(2, '0');
    final menit = tanggal.minute.toString().padLeft(2, '0');

    return '$hari/$bulan/$tahun • $jam:$menit';
  }
}