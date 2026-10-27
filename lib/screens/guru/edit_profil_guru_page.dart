import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilGuruPage extends StatefulWidget {
  const EditProfilGuruPage({super.key});

  @override
  State<EditProfilGuruPage> createState() =>
      _EditProfilGuruPageState();
}

class _EditProfilGuruPageState
    extends State<EditProfilGuruPage> {
  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // CONTROLLER
  // ============================================================

  final _formKey = GlobalKey<FormState>();

  final _namaController =
      TextEditingController();

  final TextEditingController _nipController =
      TextEditingController();

  final TextEditingController _sekolahController =
      TextEditingController();

  final TextEditingController _mapelController =
      TextEditingController();

  final TextEditingController _noHpController =
      TextEditingController();

  final TextEditingController _bioController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool _isLoading = true;
  bool _isSaving = false;

  // ============================================================
  // THEME
  // ============================================================

  bool get isDark =>
      Theme.of(context).brightness ==
      Brightness.dark;

  Color get backgroundColor => isDark
      ? const Color(0xFF080D1A)
      : const Color(0xFFF7F8FC);

  Color get cardColor =>
      isDark
          ? const Color(0xFF111827)
          : Colors.white;

  Color get textColor =>
      isDark
          ? Colors.white
          : const Color(0xFF172033);

  Color get subtitleColor =>
      isDark
          ? const Color(0xFF94A3B8)
          : const Color(0xFF64748B);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadProfile() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        _showMessage(
          'Akun tidak ditemukan.',
          isError: true,
        );

        Navigator.pop(context);
        return;
      }

      // ========================================================
      // NAMA DARI FIREBASE AUTH
      // ========================================================

      _namaController.text =
          user.displayName ?? '';

      // ========================================================
      // DATA TAMBAHAN DARI FIRESTORE
      // ========================================================

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null) {
          _nipController.text =
              data['nip']?.toString() ?? '';

          _sekolahController.text =
              data['sekolah']?.toString() ?? '';

          _mapelController.text =
              data['mataPelajaran']?.toString() ?? '';

          _noHpController.text =
              data['nomorHp']?.toString() ?? '';

          _bioController.text =
              data['bio']?.toString() ?? '';
        }
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal memuat data profil.',
        isError: true,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile() async {
  // ============================================================
  // VALIDASI FORM
  // ============================================================

  if (!_formKey.currentState!.validate()) {
    return;
  }

  // ============================================================
  // CEK USER LOGIN
  // ============================================================

  final user = _auth.currentUser;

  if (user == null) {
    _showMessage(
      'Akun tidak ditemukan. Silakan login kembali.',
      isError: true,
    );
    return;
  }

  // ============================================================
  // AMBIL DATA FORM
  // ============================================================

  final nama = _namaController.text.trim();
  final nip = _nipController.text.trim();
  final sekolah = _sekolahController.text.trim();
  final mataPelajaran = _mapelController.text.trim();
  final noHp = _noHpController.text.trim();
  final bio = _bioController.text.trim();

  // ============================================================
  // VALIDASI TAMBAHAN
  // ============================================================

  if (nama.isEmpty) {
    _showMessage(
      'Nama lengkap wajib diisi.',
      isError: true,
    );
    return;
  }

  if (nip.isEmpty) {
    _showMessage(
      'NIP wajib diisi.',
      isError: true,
    );
    return;
  }

  if (sekolah.isEmpty) {
    _showMessage(
      'Nama sekolah wajib diisi.',
      isError: true,
    );
    return;
  }

  if (mataPelajaran.isEmpty) {
    _showMessage(
      'Mata pelajaran wajib diisi.',
      isError: true,
    );
    return;
  }

  if (noHp.isEmpty) {
    _showMessage(
      'Nomor HP wajib diisi.',
      isError: true,
    );
    return;
  }

  // ============================================================
  // MULAI PROSES SIMPAN
  // ============================================================

  setState(() {
    _isSaving = true;
  });

  try {
    // ==========================================================
    // 1. UPDATE DISPLAY NAME FIREBASE AUTH
    // ==========================================================

    await user.updateDisplayName(nama);

    // ==========================================================
    // 2. SIMPAN DATA PROFIL KE FIRESTORE
    //
    // Struktur:
    //
    // users
    //   └── UID GURU
    //        ├── uid
    //        ├── nama
    //        ├── email
    //        ├── nip
    //        ├── sekolah
    //        ├── mataPelajaran
    //        ├── noHp
    //        ├── bio
    //        ├── role
    //        └── updatedAt
    //
    // ==========================================================

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'uid': user.uid,

        'nama': nama,

        'email': user.email ?? '',

        'nip': nip,

        'sekolah': sekolah,

        'mataPelajaran': mataPelajaran,

        // PENTING:
        // Gunakan noHp, bukan nomorHp
        'noHp': noHp,

        'bio': bio,

        'role': 'guru',

        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // ==========================================================
    // 3. RELOAD FIREBASE AUTH
    // ==========================================================

    await user.reload();

    // ==========================================================
    // 4. CEK WIDGET
    // ==========================================================

    if (!mounted) return;

    // ==========================================================
    // 5. TAMPILKAN PESAN BERHASIL
    // ==========================================================

    _showMessage(
      'Profil berhasil diperbarui ✓',
    );

    // ==========================================================
    // 6. TUNGGU SEBENTAR AGAR SNACKBAR TERLIHAT
    // ==========================================================

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    // ==========================================================
    // 7. KEMBALI KE HALAMAN PROFIL
    //
    // true = memberi tahu ProfilGuruPage bahwa data berubah
    // ==========================================================

    Navigator.pop(
      context,
      true,
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    String message = 'Gagal memperbarui akun.';

    switch (e.code) {
      case 'network-request-failed':
        message =
            'Tidak dapat terhubung ke internet.';
        break;

      case 'requires-recent-login':
        message =
            'Silakan login kembali untuk melanjutkan.';
        break;

      case 'user-disabled':
        message =
            'Akun ini telah dinonaktifkan.';
        break;

      case 'user-not-found':
        message =
            'Akun tidak ditemukan.';
        break;

      default:
        message =
            e.message ??
                'Gagal memperbarui akun.';
    }

    _showMessage(
      message,
      isError: true,
    );
  } on FirebaseException catch (e) {
    if (!mounted) return;

    String message =
        'Gagal menyimpan data ke Firebase.';

    if (e.code == 'permission-denied') {
      message =
          'Anda tidak memiliki izin untuk menyimpan profil.';
    } else if (e.code == 'unavailable') {
      message =
          'Firebase sedang tidak tersedia. Coba lagi.';
    } else if (e.message != null &&
        e.message!.isNotEmpty) {
      message = e.message!;
    }

    _showMessage(
      message,
      isError: true,
    );
  } catch (e) {
    if (!mounted) return;

    _showMessage(
      'Terjadi kesalahan saat menyimpan profil.',
      isError: true,
    );
  } finally {
    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });
  }
}

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _sekolahController.dispose();
    _mapelController.dispose();
    _noHpController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        surfaceTintColor:
            Colors.transparent,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: _isSaving
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),

        title: Text(
          'Edit Profil Guru',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        centerTitle: true,
      ),

      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color:
                    const Color(0xFF6366F1),
              ),
            )
          : SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),

                  padding:
                      const EdgeInsets.fromLTRB(
                    18,
                    10,
                    18,
                    35,
                  ),

                  child: Column(
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 20),

                      _buildFormCard(),

                      const SizedBox(height: 20),

                      _buildSaveButton(),

                      const SizedBox(height: 20),

                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        22,
      ),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFDB2777),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF6366F1)
                    .withValues(alpha: 0.22),
            blurRadius: 25,
            offset:
                const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Lengkapi Profil Anda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Lengkapi informasi guru '
                  'agar profil Anda lebih lengkap.',
                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.78),
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: isDark
              ? Colors.white
                  .withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
                  isDark ? 0.14 : 0.035,
            ),
            blurRadius: 20,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _sectionTitle(
            icon: Icons.person_rounded,
            title: 'Data Guru',
            subtitle:
                'Informasi pribadi dan pekerjaan',
            color:
                const Color(0xFF6366F1),
          ),

          const SizedBox(height: 20),

          _buildTextField(
            controller: _namaController,
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap',
            icon: Icons.badge_rounded,
            color:
                const Color(0xFF6366F1),
            textCapitalization:
                TextCapitalization.words,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Nama lengkap wajib diisi';
              }

              return null;
            },
          ),

          const SizedBox(height: 15),

          _buildTextField(
            controller: _nipController,
            label: 'NIP',
            hint: 'Masukkan NIP',
            icon: Icons.credit_card_rounded,
            color:
                const Color(0xFF2563EB),
            keyboardType:
                TextInputType.number,
          ),

          const SizedBox(height: 15),

          _buildTextField(
            controller:
                _sekolahController,
            label: 'Sekolah',
            hint: 'Masukkan nama sekolah',
            icon: Icons.school_rounded,
            color:
                const Color(0xFF8B5CF6),
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 15),

          _buildTextField(
            controller:
                _mapelController,
            label: 'Mata Pelajaran',
            hint:
                'Contoh: Algoritma dan Pemrograman',
            icon:
                Icons.menu_book_rounded,
            color:
                const Color(0xFFF59E0B),
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 15),

          _buildTextField(
            controller:
                _noHpController,
            label: 'Nomor HP',
            hint:
                'Contoh: 081234567890',
            icon:
                Icons.phone_rounded,
            color:
                const Color(0xFF10B981),
            keyboardType:
                TextInputType.phone,
          ),

          const SizedBox(height: 15),

          _buildTextField(
            controller:
                _bioController,
            label: 'Bio',
            hint:
                'Ceritakan sedikit tentang Anda',
            icon:
                Icons.description_rounded,
            color:
                const Color(0xFFEC4899),
            maxLines: 5,
            minLines: 3,
            textCapitalization:
                TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,

          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                color,
                color.withValues(
                  alpha: 0.70,
                ),
              ],
            ),
            borderRadius:
                BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    int maxLines = 1,
    int? minLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      textCapitalization:
          textCapitalization,

      maxLines: maxLines,

      minLines: minLines,

      style: TextStyle(
        color: textColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),

      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        labelStyle: TextStyle(
          color: subtitleColor,
          fontSize: 12,
        ),

        hintStyle: TextStyle(
          color: subtitleColor
              .withValues(alpha: 0.65),
          fontSize: 11,
        ),

        prefixIcon: Padding(
          padding:
              const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          child: Icon(
            icon,
            color: color,
            size: 21,
          ),
        ),

        filled: true,

        fillColor: isDark
            ? const Color(0xFF0B1220)
            : const Color(0xFFF8FAFC),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white
                    .withValues(alpha: 0.06)
                : const Color(
                    0xFFE2E8F0,
                  ),
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white
                    .withValues(alpha: 0.06)
                : const Color(
                    0xFFE2E8F0,
                  ),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              BorderSide(
            color: color,
            width: 1.5,
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,

      child: FilledButton.icon(
        onPressed:
            _isSaving ? null : _saveProfile,

        icon: _isSaving
            ? const SizedBox(
                width: 19,
                height: 19,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.save_rounded,
                size: 20,
              ),

        label: Text(
          _isSaving
              ? 'Menyimpan...'
              : 'Simpan Profil',
          style: const TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.w800,
          ),
        ),

        style:
            FilledButton.styleFrom(
          backgroundColor:
              const Color(0xFF6366F1),
          foregroundColor:
              Colors.white,
          disabledBackgroundColor:
              const Color(0xFF6366F1)
                  .withValues(alpha: 0.55),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Data profil disimpan secara aman',
          style: TextStyle(
            color: subtitleColor,
            fontSize: 9.5,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_done_rounded,
              color:
                  Color(0xFF10B981),
              size: 14,
            ),

            const SizedBox(width: 5),

            Text(
              'Cloud Firestore',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 9,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          behavior:
              SnackBarBehavior.floating,

          backgroundColor: isError
              ? Colors.red
              : const Color(0xFF10B981),

          duration:
              const Duration(seconds: 2),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      );
  }
}