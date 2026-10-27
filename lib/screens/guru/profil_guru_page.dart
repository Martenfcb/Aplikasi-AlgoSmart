import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_profil_guru_page.dart';

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // DATA PROFIL
  // ============================================================

  String _nama = 'Guru';
  String _email = 'Email belum tersedia';
  String _nip = 'Belum diisi';
  String _sekolah = 'Belum diisi';
  String _mataPelajaran = 'Belum diisi';
  String _nomorHp = 'Belum diisi';
  String _bio = 'Belum ada bio';
  String _role = 'Guru';

  String? _photo;

  bool _isLoading = true;

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

        setState(() {
          _isLoading = false;
        });

        _showMessage(
          'Akun tidak ditemukan.',
          isError: true,
        );

        return;
      }

      // ========================================================
      // RELOAD FIREBASE AUTH
      // ========================================================

      await user.reload();

      final updatedUser =
          _auth.currentUser;

      // ========================================================
      // DATA AUTH
      // ========================================================

      _nama = updatedUser
                  ?.displayName
                  ?.trim()
                  .isNotEmpty ==
              true
          ? updatedUser!.displayName!.trim()
          : 'Guru';

      _email = updatedUser
                  ?.email
                  ?.trim()
                  .isNotEmpty ==
              true
          ? updatedUser!.email!.trim()
          : 'Email belum tersedia';

      _photo = updatedUser?.photoURL;

      // ========================================================
      // DATA FIRESTORE
      // ========================================================

      final document =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .get();

      if (document.exists) {
        final data = document.data();

        if (data != null) {
          _nip = _readValue(
            data['nip'],
            'Belum diisi',
          );

          _sekolah = _readValue(
            data['sekolah'],
            'Belum diisi',
          );

          _mataPelajaran = _readValue(
            data['mataPelajaran'],
            'Belum diisi',
          );

          _nomorHp = _readValue(
            data['noHp'],
            'Belum diisi',
          );

          _bio = _readValue(
            data['bio'],
            'Belum ada bio',
          );

          _role = _readValue(
            data['role'],
            'Guru',
          );

          // Jika nama di Firestore ada,
          // gunakan nama tersebut.
          final namaFirestore =
              data['nama']?.toString().trim();

          if (namaFirestore != null &&
              namaFirestore.isNotEmpty) {
            _nama = namaFirestore;
          }
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
  // READ FIRESTORE VALUE
  // ============================================================

  String _readValue(
    dynamic value,
    String fallback,
  ) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return fallback;
    }

    return text;
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
    });

    await _loadProfile();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Profil Guru',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator(
                  color:
                      const Color(0xFF6366F1),
                ),
              )
            : RefreshIndicator(
                onRefresh:
                    _refreshProfile,

                child:
                    SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(
                    parent:
                        BouncingScrollPhysics(),
                  ),

                  padding:
                      const EdgeInsets.fromLTRB(
                    18,
                    10,
                    18,
                    35,
                  ),

                  child: Column(
                    children: [
                      _buildProfileHeader(),

                      const SizedBox(height: 22),

                      _buildAccountSection(),

                      const SizedBox(height: 18),

                      _buildProfessionalSection(),

                      const SizedBox(height: 18),

                      _buildContactSection(),

                      const SizedBox(height: 18),

                      _buildBioSection(),

                      const SizedBox(height: 18),

                      _buildSecuritySection(),

                      const SizedBox(height: 18),

                      _buildInformationSection(),

                      const SizedBox(height: 25),

                      _buildFooter(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        22,
        28,
        22,
        25,
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
            BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF6366F1)
                    .withValues(alpha: 0.25),
            blurRadius: 28,
            offset:
                const Offset(0, 12),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -55,
            bottom: -75,
            child: Container(
              width: 140,
              height: 140,
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              _buildAvatar(
                photo: _photo,
                name: _nama,
                size: 96,
              ),

              const SizedBox(height: 15),

              Text(
                _nama,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                _email,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),

              const SizedBox(height: 13),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.13,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                  border: Border.all(
                    color: Colors.white
                        .withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 15,
                    ),

                    const SizedBox(
                      width: 6,
                    ),

                    Text(
                      _role,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar({
    required String? photo,
    required String name,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      padding:
          const EdgeInsets.all(3),

      decoration:
          BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white
            .withValues(alpha: 0.95),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.18),
            blurRadius: 18,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),

      child: ClipOval(
        child: photo != null &&
                photo.isNotEmpty
            ? Image.network(
                photo,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) {
                  return _avatarFallback(
                    name,
                    size,
                  );
                },
              )
            : _avatarFallback(
                name,
                size,
              ),
      ),
    );
  }

  Widget _avatarFallback(
    String name,
    double size,
  ) {
    String initial = 'G';

    if (name.trim().isNotEmpty) {
      initial =
          name.trim()[0].toUpperCase();
    }

    return Container(
      color:
          const Color(0xFF6366F1),
      alignment:
          Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.38,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }

  // ============================================================
  // ACCOUNT SECTION
  // ============================================================

  Widget _buildAccountSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon:
                Icons.person_rounded,
            title:
                'Informasi Akun',
            subtitle:
                'Data dasar akun guru',
            color:
                const Color(0xFF6366F1),
          ),

          const SizedBox(height: 18),

          _infoItem(
            icon:
                Icons.badge_rounded,
            title: 'Nama',
            value: _nama,
            color:
                const Color(0xFF6366F1),
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon:
                Icons.email_rounded,
            title: 'Email',
            value: _email,
            color:
                const Color(0xFF2563EB),
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon:
                Icons.verified_user_rounded,
            title: 'Peran',
            value: _role,
            color:
                const Color(0xFF8B5CF6),
          ),

          const SizedBox(height: 18),

          _editButton(),
        ],
      ),
    );
  }

  // ============================================================
  // PROFESSIONAL SECTION
  // ============================================================

  Widget _buildProfessionalSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon:
                Icons.work_rounded,
            title:
                'Informasi Profesional',
            subtitle:
                'Data pekerjaan dan pendidikan',
            color:
                const Color(0xFF8B5CF6),
          ),

          const SizedBox(height: 18),

          _infoItem(
            icon:
                Icons.credit_card_rounded,
            title: 'NIP',
            value: _nip,
            color:
                const Color(0xFF2563EB),
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon:
                Icons.school_rounded,
            title: 'Sekolah',
            value: _sekolah,
            color:
                const Color(0xFF8B5CF6),
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon:
                Icons.menu_book_rounded,
            title:
                'Mata Pelajaran',
            value:
                _mataPelajaran,
            color:
                const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTACT SECTION
  // ============================================================

  Widget _buildContactSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon:
                Icons.contact_phone_rounded,
            title:
                'Kontak',
            subtitle:
                'Informasi kontak guru',
            color:
                const Color(0xFF10B981),
          ),

          const SizedBox(height: 18),

          _infoItem(
            icon:
                Icons.phone_rounded,
            title:
                'Nomor HP',
            value:
                _nomorHp,
            color:
                const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BIO SECTION
  // ============================================================

  Widget _buildBioSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon:
                Icons.description_rounded,
            title: 'Bio',
            subtitle:
                'Tentang guru',
            color:
                const Color(0xFFEC4899),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(15),

            decoration:
                BoxDecoration(
              color: const Color(
                0xFFEC4899,
              ).withValues(
                alpha:
                    isDark ? 0.07 : 0.045,
              ),
              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),

            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,

                  decoration:
                      BoxDecoration(
                    color: const Color(
                      0xFFEC4899,
                    ).withValues(
                      alpha: 0.12,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: const Icon(
                    Icons.format_quote_rounded,
                    color:
                        Color(0xFFEC4899),
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    _bio,
                    style: TextStyle(
                      color:
                          textColor,
                      fontSize: 12,
                      height: 1.55,
                      fontWeight:
                          FontWeight.w500,
                    ),
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
  // EDIT BUTTON
  // ============================================================

  Widget _editButton() {
    return SizedBox(
      width: double.infinity,

      child:
          FilledButton.icon(
        onPressed:
            _editProfile,

        icon: const Icon(
          Icons.edit_rounded,
          size: 18,
        ),

        label: const Text(
          'Edit Profil',
        ),

        style:
            FilledButton.styleFrom(
          backgroundColor:
              const Color(0xFF6366F1),
          foregroundColor:
              Colors.white,
          padding:
              const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              15,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _editProfile() async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const EditProfilGuruPage(),
      ),
    );

    if (result == true &&
        mounted) {
      await _loadProfile();
    }
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _buildSecuritySection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon:
                Icons.security_rounded,
            title:
                'Keamanan',
            subtitle:
                'Kelola keamanan akun Anda',
            color:
                const Color(0xFFEF4444),
          ),

          const SizedBox(height: 18),

          _actionItem(
            icon:
                Icons.lock_reset_rounded,
            title:
                'Ubah Kata Sandi',
            subtitle:
                'Perbarui kata sandi akun guru',
            color:
                const Color(0xFFEF4444),
            onTap:
                _changePassword,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION
  // ============================================================

  Widget _buildInformationSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon:
                Icons.info_rounded,
            title:
                'Informasi Aplikasi',
            subtitle:
                'Informasi aplikasi AlgoSmart',
            color:
                const Color(0xFF06B6D4),
          ),

          const SizedBox(height: 18),

          _infoItem(
            icon:
                Icons.apps_rounded,
            title:
                'Aplikasi',
            value:
                'AlgoSmart',
            color:
                const Color(0xFF06B6D4),
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon:
                Icons.code_rounded,
            title:
                'Versi',
            value:
                '1.0.0',
            color:
                const Color(0xFF14B8A6),
          ),

          const SizedBox(height: 12),

          _infoItem(
            icon:
                Icons.menu_book_rounded,
            title:
                'Mata Pelajaran',
            value:
                _mataPelajaran,
            color:
                const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: isDark
              ? Colors.white
                  .withValues(
                  alpha: 0.06,
                )
              : const Color(
                  0xFFE5E7EB,
                ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha:
                  isDark
                      ? 0.14
                      : 0.035,
            ),
            blurRadius: 20,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: child,
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _sectionHeader({
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
                BorderRadius.circular(
              14,
            ),
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
                style:
                    TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style:
                    TextStyle(
                  color:
                      subtitleColor,
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
  // INFO ITEM
  // ============================================================

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(12),

      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha:
              isDark
                  ? 0.07
                  : 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    color:
                        subtitleColor,
                    fontSize: 9.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  value,
                  maxLines: 3,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      TextStyle(
                    color:
                        textColor,
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w800,
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
  // ACTION ITEM
  // ============================================================

  Widget _actionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color:
          Colors.transparent,

      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          17,
        ),

        child: Ink(
          padding:
              const EdgeInsets.all(
            12,
          ),

          decoration:
              BoxDecoration(
            color:
                color.withValues(
              alpha:
                  isDark
                      ? 0.07
                      : 0.045,
            ),
            borderRadius:
                BorderRadius.circular(
              17,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,

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
                      BorderRadius.circular(
                    13,
                  ),
                ),

                child: Icon(
                  icon,
                  color:
                      Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(
                        color:
                            textColor,
                        fontSize: 12.5,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      subtitle,
                      style:
                          TextStyle(
                        color:
                            subtitleColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color:
                    subtitleColor,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> _changePassword() async {
    final user =
        _auth.currentUser;

    if (user == null ||
        user.email == null) {
      _showMessage(
        'Akun tidak ditemukan.',
        isError: true,
      );
      return;
    }

    final newPasswordController =
        TextEditingController();

    final confirmPasswordController =
        TextEditingController();

    final result =
        await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) {
        bool obscureNew = true;
        bool obscureConfirm = true;

        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              backgroundColor:
                  cardColor,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),

              title: Text(
                'Ubah Kata Sandi',
                style:
                    TextStyle(
                  color:
                      textColor,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      'Masukkan kata sandi baru '
                      'untuk mengamankan akun Anda.',
                      style:
                          TextStyle(
                        color:
                            subtitleColor,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextField(
                      controller:
                          newPasswordController,
                      obscureText:
                          obscureNew,

                      decoration:
                          InputDecoration(
                        labelText:
                            'Kata Sandi Baru',
                        prefixIcon:
                            const Icon(
                          Icons
                              .lock_rounded,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed:
                              () {
                            setDialogState(
                              () {
                                obscureNew =
                                    !obscureNew;
                              },
                            );
                          },
                          icon: Icon(
                            obscureNew
                                ? Icons
                                    .visibility_rounded
                                : Icons
                                    .visibility_off_rounded,
                          ),
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          confirmPasswordController,
                      obscureText:
                          obscureConfirm,

                      decoration:
                          InputDecoration(
                        labelText:
                            'Konfirmasi Kata Sandi',
                        prefixIcon:
                            const Icon(
                          Icons
                              .lock_outline_rounded,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed:
                              () {
                            setDialogState(
                              () {
                                obscureConfirm =
                                    !obscureConfirm;
                              },
                            );
                          },
                          icon: Icon(
                            obscureConfirm
                                ? Icons
                                    .visibility_rounded
                                : Icons
                                    .visibility_off_rounded,
                          ),
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child:
                      const Text(
                    'Batal',
                  ),
                ),

                FilledButton(
                  onPressed: () {
                    final password =
                        newPasswordController
                            .text;

                    final confirm =
                        confirmPasswordController
                            .text;

                    if (password.length <
                        6) {
                      _showMessage(
                        'Kata sandi minimal 6 karakter.',
                        isError: true,
                      );
                      return;
                    }

                    if (password !=
                        confirm) {
                      _showMessage(
                        'Konfirmasi kata sandi tidak cocok.',
                        isError: true,
                      );
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child:
                      const Text(
                    'Simpan',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    final newPassword =
        newPasswordController.text;

    newPasswordController.dispose();
    confirmPasswordController
        .dispose();

    if (result != true) return;

    try {
      await user.updatePassword(
        newPassword,
      );

      if (!mounted) return;

      _showMessage(
        'Kata sandi berhasil diubah ✓',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          'Gagal mengubah kata sandi.';

      if (e.code ==
          'requires-recent-login') {
        message =
            'Demi keamanan, silakan login kembali '
            'sebelum mengubah kata sandi.';
      } else if (e.code ==
          'weak-password') {
        message =
            'Kata sandi terlalu lemah.';
      }

      _showMessage(
        message,
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan. Silakan coba lagi.',
        isError: true,
      );
    }
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
          content:
              Text(message),
          behavior:
              SnackBarBehavior
                  .floating,
          backgroundColor:
              isError
                  ? Colors.red
                  : const Color(
                      0xFF10B981,
                    ),
          duration:
              const Duration(
            seconds: 2,
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
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,

          decoration:
              BoxDecoration(
            gradient:
                const LinearGradient(
              colors: [
                Color(0xFF4F46E5),
                Color(0xFFDB2777),
              ],
            ),
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),

          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'AlgoSmart',
          style:
              TextStyle(
            color:
                textColor,
            fontSize: 13,
            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Profil Guru • Media Pembelajaran Interaktif',
          textAlign:
              TextAlign.center,
          style:
              TextStyle(
            color:
                subtitleColor,
            fontSize: 9.5,
          ),
        ),
      ],
    );
  }
}