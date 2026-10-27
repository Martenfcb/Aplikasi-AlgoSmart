import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KelolaUserPage extends StatefulWidget {
  const KelolaUserPage({super.key});

  @override
  State<KelolaUserPage> createState() => _KelolaUserPageState();
}

class _KelolaUserPageState extends State<KelolaUserPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _searchController = TextEditingController();

  String _filterRole = 'Semua';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // STREAM USER
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> _getUsers() {
    return _firestore.collection('users').snapshots();
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String _formatTanggal(dynamic value) {
    if (value == null) return '-';

    if (value is Timestamp) {
      final date = value.toDate();

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    return value.toString();
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<void> _hapusUser(
    String uid,
    String nama,
  ) async {
    final theme = Theme.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.shade400,
                        Colors.red.shade700,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Hapus User?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Apakah kamu yakin ingin menghapus "$nama"?\n\n'
                  'Data yang sudah dihapus tidak dapat dikembalikan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.60,
                    ),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, true);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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

    if (confirm != true) return;

    try {
      await _firestore.collection('users').doc(uid).delete();

      if (!mounted) return;

      _showSnackBar(
        'User berhasil dihapus',
        Colors.green,
        Icons.check_circle_rounded,
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      _showSnackBar(
        e.message ?? 'Gagal menghapus user',
        Colors.red,
        Icons.error_rounded,
      );
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnackBar(
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
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
  // EDIT
  // ============================================================

  Future<void> _editUser(
    String uid,
    Map<String, dynamic> data,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditUserPage(
          uid: uid,
          data: data,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // TAMBAH
  // ============================================================

  Future<void> _tambahUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahUserPage(),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // FILTER
  // ============================================================

  bool _sesuaiFilter(Map<String, dynamic> data) {
    if (_filterRole == 'Semua') {
      return true;
    }

    return data['role'] == _filterRole;
  }

  // ============================================================
  // SEARCH
  // ============================================================

  bool _sesuaiPencarian(Map<String, dynamic> data) {
    final keyword = _searchController.text.trim().toLowerCase();

    if (keyword.isEmpty) return true;

    final fields = [
      data['nama'],
      data['email'],
      data['nis'],
      data['nip'],
      data['kelas'],
      data['jurusan'],
      data['sekolah'],
      data['mataPelajaran'],
      data['nomorHp'],
      data['noHp'],
    ];

    return fields.any(
      (value) => value
          .toString()
          .toLowerCase()
          .contains(keyword),
    );
  }

  // ============================================================
  // ROLE COLOR
  // ============================================================

  Color _roleColor(String role) {
    return role == 'guru'
        ? const Color(0xFF7C3AED)
        : const Color(0xFF2563EB);
  }

  // ============================================================
  // USER CARD
  // ============================================================

  Widget _buildUserCard(
    BuildContext context,
    String uid,
    Map<String, dynamic> data,
    int index,
  ) {
    final theme = Theme.of(context);

    final nama = (data['nama'] ?? 'Tanpa Nama').toString();
    final email = (data['email'] ?? '-').toString();
    final role = (data['role'] ?? 'siswa').toString();

    final isGuru = role == 'guru';
    final roleColor = _roleColor(role);

    final icon = isGuru
        ? Icons.school_rounded
        : Icons.person_rounded;

    final kelas = (data['kelas'] ?? '').toString();
    final jurusan = (data['jurusan'] ?? '').toString();
    final nip = (data['nip'] ?? '').toString();
    final nis = (data['nis'] ?? '').toString();

    final nomorHp = (
      data['nomorHp'] ??
      data['noHp'] ??
      ''
    ).toString();

    final sekolah = (data['sekolah'] ?? '').toString();

    final mataPelajaran =
        (data['mataPelajaran'] ?? '').toString();

    final createdAt = data['createdAt'];

    return TweenAnimationBuilder<double>(
      duration: Duration(
        milliseconds: 350 + (index * 60),
      ),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: roleColor.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: roleColor.withValues(alpha: 0.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Column(
            children: [
              // ==================================================
              // COLOR HEADER
              // ==================================================

              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      roleColor,
                      roleColor.withValues(alpha: 0.45),
                      Colors.cyanAccent.withValues(
                        alpha: 0.65,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // AVATAR
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                roleColor,
                                roleColor.withValues(
                                  alpha: 0.55,
                                ),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: roleColor.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // NAME
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                nama,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme
                                      .colorScheme
                                      .onSurface,
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                email,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme
                                      .colorScheme
                                      .onSurface
                                      .withValues(
                                    alpha: 0.50,
                                  ),
                                  fontSize: 11,
                                ),
                              ),

                              const SizedBox(height: 9),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 11,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      roleColor.withValues(
                                        alpha: 0.16,
                                      ),
                                      roleColor.withValues(
                                        alpha: 0.07,
                                      ),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 13,
                                      color: roleColor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      isGuru
                                          ? 'GURU'
                                          : 'SISWA',
                                      style: TextStyle(
                                        color: roleColor,
                                        fontSize: 9,
                                        fontWeight:
                                            FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // MENU
                        PopupMenuButton<String>(
                          tooltip: 'Menu',
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editUser(uid, data);
                            }

                            if (value == 'delete') {
                              _hapusUser(uid, nama);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    size: 19,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Edit User'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    size: 19,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Hapus User'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // INFO
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: theme.brightness ==
                                Brightness.dark
                            ? Colors.white.withValues(
                                alpha: 0.035,
                              )
                            : theme.colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.38),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          if (isGuru) ...[
                            _infoRow(
                              context,
                              Icons.badge_rounded,
                              'NIP',
                              nip.isEmpty ? '-' : nip,
                              roleColor,
                            ),
                            _infoRow(
                              context,
                              Icons.business_rounded,
                              'Sekolah',
                              sekolah.isEmpty
                                  ? '-'
                                  : sekolah,
                              roleColor,
                            ),
                            _infoRow(
                              context,
                              Icons.menu_book_rounded,
                              'Mata Pelajaran',
                              mataPelajaran.isEmpty
                                  ? '-'
                                  : mataPelajaran,
                              roleColor,
                            ),
                          ] else ...[
                            _infoRow(
                              context,
                              Icons.badge_rounded,
                              'NIS',
                              nis.isEmpty ? '-' : nis,
                              roleColor,
                            ),
                            _infoRow(
                              context,
                              Icons.class_rounded,
                              'Kelas',
                              kelas.isEmpty ? '-' : kelas,
                              roleColor,
                            ),
                            _infoRow(
                              context,
                              Icons.school_rounded,
                              'Jurusan',
                              jurusan.isEmpty
                                  ? '-'
                                  : jurusan,
                              roleColor,
                            ),
                          ],

                          _infoRow(
                            context,
                            Icons.phone_rounded,
                            'Nomor HP',
                            nomorHp.isEmpty
                                ? '-'
                                : nomorHp,
                            roleColor,
                          ),

                          _infoRow(
                            context,
                            Icons.calendar_month_rounded,
                            'Terdaftar',
                            _formatTanggal(createdAt),
                            roleColor,
                            last: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // ACTION BUTTON
                    // ==================================================

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _editUser(uid, data);
                            },
                            style:
                                OutlinedButton.styleFrom(
                              minimumSize:
                                  const Size.fromHeight(
                                48,
                              ),
                              side: BorderSide(
                                color: roleColor
                                    .withValues(
                                  alpha: 0.25,
                                ),
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  15,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: roleColor,
                            ),
                            label: Text(
                              'Edit',
                              style: TextStyle(
                                color: roleColor,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              _hapusUser(uid, nama);
                            },
                            style:
                                FilledButton.styleFrom(
                              backgroundColor:
                                  Colors.red.shade500,
                              minimumSize:
                                  const Size.fromHeight(
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
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color, {
    bool last = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: last ? 0 : 11,
      ),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 105,
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.48),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
    int total,
    int guru,
    int siswa,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        22,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.brightness == Brightness.dark
              ? const [
                  Color(0xFF312E81),
                  Color(0xFF1E1B4B),
                  Color(0xFF0F172A),
                ]
              : const [
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                  Color(0xFF2563EB),
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius:
                      BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manajemen User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Kelola akun guru dan siswa',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // STATISTICS
          Row(
            children: [
              Expanded(
                child: _statCard(
                  'Total',
                  total.toString(),
                  Icons.people_alt_rounded,
                  Colors.white,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _statCard(
                  'Guru',
                  guru.toString(),
                  Icons.school_rounded,
                  Colors.white,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _statCard(
                  'Siswa',
                  siswa.toString(),
                  Icons.person_rounded,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.13,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
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

  Widget _buildSearch(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: theme.brightness ==
                        Brightness.dark
                    ? 0.15
                    : 0.05,
              ),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText:
                'Cari nama, email, NIS, NIP...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.40),
              fontSize: 12,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      )
                    : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 10,
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

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      child: Row(
        children: [
          _filterButton(
            context,
            'Semua',
            Icons.people_rounded,
          ),

          const SizedBox(width: 8),

          _filterButton(
            context,
            'guru',
            Icons.school_rounded,
          ),

          const SizedBox(width: 8),

          _filterButton(
            context,
            'siswa',
            Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _filterButton(
    BuildContext context,
    String role,
    IconData icon,
  ) {
    final active = _filterRole == role;

    final title = role == 'Semua'
        ? 'Semua'
        : role == 'guru'
            ? 'Guru'
            : 'Siswa';

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filterRole = role;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 11,
          ),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF7C3AED),
                    ],
                  )
                : null,
            color: active
                ? null
                : Theme.of(context)
                    .colorScheme
                    .surface,
            borderRadius:
                BorderRadius.circular(15),
            border: Border.all(
              color: active
                  ? Colors.transparent
                  : Theme.of(context)
                      .dividerColor
                      .withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: active
                    ? Colors.white
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
              ),

              const SizedBox(width: 6),

              Text(
                title,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyView(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4F46E5)
                        .withValues(alpha: 0.12),
                    const Color(0xFF7C3AED)
                        .withValues(alpha: 0.07),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 48,
                color: Color(0xFF6366F1),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'User Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Belum ada data user yang sesuai\ndengan pencarian atau filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.50),
                height: 1.5,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _filterRole = 'Semua';
                });
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Reset Filter',
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

  Widget _errorView(
    BuildContext context,
    String error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.red.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 45,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Kelola User',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: false,
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _tambahUser,
        elevation: 5,
        backgroundColor:
            const Color(0xFF4F46E5),
        icon: const Icon(
          Icons.person_add_alt_1_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'Tambah User',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: _getUsers(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _errorView(
              context,
              snapshot.error.toString(),
            );
          }

          final documents =
              snapshot.data?.docs ?? [];

          final guruCount = documents.where(
            (doc) => doc.data()['role'] == 'guru',
          ).length;

          final siswaCount = documents.where(
            (doc) => doc.data()['role'] == 'siswa',
          ).length;

          final filtered =
              documents.where((doc) {
            final data = doc.data();

            return _sesuaiFilter(data) &&
                _sesuaiPencarian(data);
          }).toList();

          return Column(
            children: [
              _buildHeader(
                context,
                documents.length,
                guruCount,
                siswaCount,
              ),

              _buildSearch(context),

              _buildFilters(context),

              const SizedBox(height: 5),

              Expanded(
                child: filtered.isEmpty
                    ? _emptyView(context)
                    : LayoutBuilder(
                        builder:
                            (context, constraints) {
                          // =================================================
                          // DESKTOP / TABLET
                          // =================================================

                          if (constraints.maxWidth >=
                              800) {
                            final crossAxisCount =
                                constraints.maxWidth >=
                                        1200
                                    ? 3
                                    : 2;

                            return GridView.builder(
                              physics:
                                  const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.fromLTRB(
                                18,
                                10,
                                18,
                                110,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 2,
                                childAspectRatio:
                                    constraints.maxWidth >=
                                            1200
                                        ? 0.73
                                        : 0.70,
                              ),
                              itemCount:
                                  filtered.length,
                              itemBuilder:
                                  (context, index) {
                                final doc =
                                    filtered[index];

                                return _buildUserCard(
                                  context,
                                  doc.id,
                                  doc.data(),
                                  index,
                                );
                              },
                            );
                          }

                          // =================================================
                          // MOBILE
                          // =================================================

                          return ListView.builder(
                            physics:
                                const BouncingScrollPhysics(),
                            padding:
                                const EdgeInsets.fromLTRB(
                              16,
                              10,
                              16,
                              110,
                            ),
                            itemCount:
                                filtered.length,
                            itemBuilder:
                                (context, index) {
                              final doc =
                                  filtered[index];

                              return _buildUserCard(
                                context,
                                doc.id,
                                doc.data(),
                                index,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ====================================================================
// EDIT USER PAGE
// ====================================================================

class EditUserPage extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> data;

  const EditUserPage({
    super.key,
    required this.uid,
    required this.data,
  });

  @override
  State<EditUserPage> createState() =>
      _EditUserPageState();
}

class _EditUserPageState
    extends State<EditUserPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _namaController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _nisController =
      TextEditingController();

  final _nipController =
      TextEditingController();

  final _sekolahController =
      TextEditingController();

  final _mapelController =
      TextEditingController();

  final _kelasController =
      TextEditingController();

  final _jurusanController =
      TextEditingController();

  final _noHpController =
      TextEditingController();

  final _bioController =
      TextEditingController();

  late String _role;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final data = widget.data;

    _namaController.text =
        data['nama']?.toString() ?? '';

    _emailController.text =
        data['email']?.toString() ?? '';

    _nisController.text =
        data['nis']?.toString() ?? '';

    _nipController.text =
        data['nip']?.toString() ?? '';

    _sekolahController.text =
        data['sekolah']?.toString() ?? '';

    _mapelController.text =
        data['mataPelajaran']?.toString() ?? '';

    _kelasController.text =
        data['kelas']?.toString() ?? '';

    _jurusanController.text =
        data['jurusan']?.toString() ?? '';

    _noHpController.text =
        (data['nomorHp'] ??
                data['noHp'] ??
                '')
            .toString();

    _bioController.text =
        data['bio']?.toString() ?? '';

    _role =
        data['role'] == 'guru'
            ? 'guru'
            : 'siswa';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nisController.dispose();
    _nipController.dispose();
    _sekolahController.dispose();
    _mapelController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _noHpController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final updateData =
          <String, dynamic>{
        'nama': _namaController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _role,
        'updatedAt':
            FieldValue.serverTimestamp(),
      };

      if (_role == 'guru') {
        updateData['nip'] =
            _nipController.text.trim();

        updateData['sekolah'] =
            _sekolahController.text.trim();

        updateData['mataPelajaran'] =
            _mapelController.text.trim();

        updateData['nomorHp'] =
            _noHpController.text.trim();

        updateData['bio'] =
            _bioController.text.trim();
      } else {
        updateData['nis'] =
            _nisController.text.trim();

        updateData['kelas'] =
            _kelasController.text.trim();

        updateData['jurusan'] =
            _jurusanController.text.trim();

        updateData['noHp'] =
            _noHpController.text.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update(updateData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Data user berhasil diperbarui.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message ??
                'Gagal memperbarui data.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================================================
  // FIELD
  // ============================================================

  Widget _field(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (label == 'Nama' &&
              (value == null ||
                  value.trim().isEmpty)) {
            return 'Nama wajib diisi';
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              icon == null ? null : Icon(icon),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide(
              color: theme.dividerColor
                  .withValues(alpha: 0.10),
            ),
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Color(0xFF6366F1),
              width: 1.5,
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
    final theme = Theme.of(context);
    final isGuru = _role == 'guru';

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Edit User',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width =
                constraints.maxWidth >= 850
                    ? 760.0
                    : double.infinity;

            return Center(
              child: SizedBox(
                width: width,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // HEADER
                    Container(
                      padding:
                          const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF4F46E5),
                            Color(0xFF7C3AED),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Edit Informasi User',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Perbarui data akun pengguna',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _field(
                      'Nama',
                      _namaController,
                      icon: Icons.person_rounded,
                    ),

                    _field(
                      'Email',
                      _emailController,
                      icon: Icons.email_rounded,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),

                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        prefixIcon:
                            const Icon(
                          Icons.admin_panel_settings_rounded,
                        ),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            17,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'guru',
                          child: Text('Guru'),
                        ),
                        DropdownMenuItem(
                          value: 'siswa',
                          child: Text('Siswa'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _role = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    if (isGuru) ...[
                      _field(
                        'NIP',
                        _nipController,
                        icon: Icons.badge_rounded,
                      ),
                      _field(
                        'Sekolah',
                        _sekolahController,
                        icon:
                            Icons.business_rounded,
                      ),
                      _field(
                        'Mata Pelajaran',
                        _mapelController,
                        icon:
                            Icons.menu_book_rounded,
                      ),
                      _field(
                        'Nomor HP',
                        _noHpController,
                        icon: Icons.phone_rounded,
                        keyboardType:
                            TextInputType.phone,
                      ),
                      _field(
                        'Bio',
                        _bioController,
                        icon:
                            Icons.info_outline_rounded,
                        maxLines: 4,
                      ),
                    ] else ...[
                      _field(
                        'NIS',
                        _nisController,
                        icon: Icons.badge_rounded,
                      ),
                      _field(
                        'Kelas',
                        _kelasController,
                        icon: Icons.class_rounded,
                      ),
                      _field(
                        'Jurusan',
                        _jurusanController,
                        icon:
                            Icons.school_rounded,
                      ),
                      _field(
                        'Nomor HP',
                        _noHpController,
                        icon: Icons.phone_rounded,
                        keyboardType:
                            TextInputType.phone,
                      ),
                    ],

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 55,
                      child: FilledButton.icon(
                        onPressed:
                            _saving ? null : _simpan,
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF4F46E5,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              17,
                            ),
                          ),
                        ),
                        icon: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.save_rounded,
                              ),
                        label: Text(
                          _saving
                              ? 'Menyimpan...'
                              : 'Simpan Perubahan',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ====================================================================
// TAMBAH USER
// ====================================================================

class TambahUserPage extends StatefulWidget {
  const TambahUserPage({super.key});

  @override
  State<TambahUserPage> createState() =>
      _TambahUserPageState();
}

class _TambahUserPageState
    extends State<TambahUserPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _namaController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _nisController =
      TextEditingController();

  final _nipController =
      TextEditingController();

  final _sekolahController =
      TextEditingController();

  final _mapelController =
      TextEditingController();

  final _kelasController =
      TextEditingController();

  final _jurusanController =
      TextEditingController();

  final _noHpController =
      TextEditingController();

  final _bioController =
      TextEditingController();

  String _role = 'siswa';

  bool _saving = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nisController.dispose();
    _nipController.dispose();
    _sekolahController.dispose();
    _mapelController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _noHpController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc();

      final data =
          <String, dynamic>{
        'uid': doc.id,
        'nama':
            _namaController.text.trim(),
        'email':
            _emailController.text.trim(),
        'role': _role,
        'createdAt':
            FieldValue.serverTimestamp(),
        'updatedAt':
            FieldValue.serverTimestamp(),
      };

      if (_role == 'guru') {
        data['nip'] =
            _nipController.text.trim();

        data['sekolah'] =
            _sekolahController.text.trim();

        data['mataPelajaran'] =
            _mapelController.text.trim();

        data['nomorHp'] =
            _noHpController.text.trim();

        data['bio'] =
            _bioController.text.trim();
      } else {
        data['nis'] =
            _nisController.text.trim();

        data['kelas'] =
            _kelasController.text.trim();

        data['jurusan'] =
            _jurusanController.text.trim();

        data['noHp'] =
            _noHpController.text.trim();
      }

      await doc.set(data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'User berhasil ditambahkan.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message ??
                'Gagal menambahkan user.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================================================
  // FIELD
  // ============================================================

  Widget _field(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (label == 'Nama' &&
              (value == null ||
                  value.trim().isEmpty)) {
            return 'Nama wajib diisi';
          }

          if (label == 'Email' &&
              (value == null ||
                  value.trim().isEmpty)) {
            return 'Email wajib diisi';
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              icon == null ? null : Icon(icon),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide(
              color: theme.dividerColor
                  .withValues(alpha: 0.10),
            ),
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Color(0xFF6366F1),
              width: 1.5,
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
    final theme = Theme.of(context);
    final isGuru = _role == 'guru';

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Tambah User',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width =
                constraints.maxWidth >= 850
                    ? 760.0
                    : double.infinity;

            return Center(
              child: SizedBox(
                width: width,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // HEADER
                    Container(
                      padding:
                          const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF2563EB),
                            Color(0xFF4F46E5),
                            Color(0xFF7C3AED),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Tambah User Baru',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tambahkan akun guru atau siswa',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _field(
                      'Nama',
                      _namaController,
                      icon:
                          Icons.person_rounded,
                    ),

                    _field(
                      'Email',
                      _emailController,
                      icon:
                          Icons.email_rounded,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),

                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        prefixIcon:
                            const Icon(
                          Icons.admin_panel_settings_rounded,
                        ),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            17,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'guru',
                          child: Text('Guru'),
                        ),
                        DropdownMenuItem(
                          value: 'siswa',
                          child: Text('Siswa'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _role = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    if (isGuru) ...[
                      _field(
                        'NIP',
                        _nipController,
                        icon:
                            Icons.badge_rounded,
                      ),

                      _field(
                        'Sekolah',
                        _sekolahController,
                        icon:
                            Icons.business_rounded,
                      ),

                      _field(
                        'Mata Pelajaran',
                        _mapelController,
                        icon:
                            Icons.menu_book_rounded,
                      ),

                      _field(
                        'Nomor HP',
                        _noHpController,
                        icon:
                            Icons.phone_rounded,
                        keyboardType:
                            TextInputType.phone,
                      ),

                      _field(
                        'Bio',
                        _bioController,
                        icon:
                            Icons.info_outline_rounded,
                        maxLines: 4,
                      ),
                    ] else ...[
                      _field(
                        'NIS',
                        _nisController,
                        icon:
                            Icons.badge_rounded,
                      ),

                      _field(
                        'Kelas',
                        _kelasController,
                        icon:
                            Icons.class_rounded,
                      ),

                      _field(
                        'Jurusan',
                        _jurusanController,
                        icon:
                            Icons.school_rounded,
                      ),

                      _field(
                        'Nomor HP',
                        _noHpController,
                        icon:
                            Icons.phone_rounded,
                        keyboardType:
                            TextInputType.phone,
                      ),
                    ],

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 55,
                      child: FilledButton.icon(
                        onPressed:
                            _saving
                                ? null
                                : _simpan,
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF4F46E5,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              17,
                            ),
                          ),
                        ),
                        icon: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons
                                    .person_add_alt_1_rounded,
                              ),
                        label: Text(
                          _saving
                              ? 'Menyimpan...'
                              : 'Simpan User',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}