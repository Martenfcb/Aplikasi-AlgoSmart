import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> userData;

  const EditUserPage({
    super.key,
    required this.docId,
    required this.userData,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _noHpController;

  String _role = 'siswa';
  bool _isSaving = false;

 @override
void initState() {
  super.initState();

  _namaController = TextEditingController(
    text: widget.userData['nama']?.toString() ?? '',
  );

  _emailController = TextEditingController(
    text: widget.userData['email']?.toString() ?? '',
  );

  _noHpController = TextEditingController(
    text: widget.userData['nomorHp']?.toString() ??
        widget.userData['noHp']?.toString() ??
        '',
  );

  final role =
      widget.userData['role']?.toString().toLowerCase();

  if (role == 'guru' || role == 'siswa') {
    _role = role!;
  } else {
    _role = 'siswa';
  }
}

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();

    super.dispose();
  }

  // ============================================================
  // SIMPAN PERUBAHAN
  // ============================================================

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final nama = _namaController.text.trim();
      final email = _emailController.text.trim();
      final noHp = _noHpController.text.trim();

      await _firestore
          .collection('users')
          .doc(widget.docId)
          .update({
        'nama': nama,
        'email': email,
        'noHp': noHp,
        'role': _role,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showMessage(
        'Data user berhasil diperbarui ✓',
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      _showMessage(
        e.message ??
            'Gagal memperbarui data user.',
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan. Silakan coba lagi.',
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
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? Colors.red : Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
        centerTitle: true,
        title: const Text(
          'Edit User',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(),

                const SizedBox(height: 25),

                _buildTextField(
                  controller: _namaController,
                  label: 'Nama',
                  hint: 'Masukkan nama user',
                  icon: Icons.person_rounded,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email',
                  icon: Icons.email_rounded,
                  keyboardType:
                      TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }

                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                _buildTextField(
                  controller: _noHpController,
                  label: 'Nomor HP',
                  hint: 'Masukkan nomor HP',
                  icon: Icons.phone_rounded,
                  keyboardType:
                      TextInputType.phone,
                ),

                const SizedBox(height: 15),

                _buildRoleDropdown(),

                const SizedBox(height: 30),

                _buildSaveButton(),
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
    final nama =
        _namaController.text.trim();

    String initial = 'U';

    if (nama.isNotEmpty) {
      initial = nama[0].toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  Colors.white.withValues(
                alpha: 0.18,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    Colors.white.withValues(
                  alpha: 0.4,
                ),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Edit Data User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Perbarui informasi akun pengguna',
            style: TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.75,
              ),
              fontSize: 11,
            ),
          ),
        ],
      ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,

      style: TextStyle(
        color:
            theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),

        filled: true,

        fillColor:
            theme.colorScheme.surface,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                theme.dividerColor,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                theme.dividerColor
                    .withValues(alpha: 0.4),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color: Color(0xFF6366F1),
            width: 2,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ROLE
  // ============================================================

Widget _buildRoleDropdown() {
  final theme = Theme.of(context);

  return DropdownButtonFormField<String>(
    initialValue: _role,

    decoration: InputDecoration(
      labelText: 'Role',
      prefixIcon: const Icon(
        Icons.admin_panel_settings_rounded,
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF6366F1),
          width: 2,
        ),
      ),
    ),

    items: const [
      DropdownMenuItem(
        value: 'guru',
        child: Row(
          children: [
            Icon(
              Icons.school_rounded,
              color: Color(0xFF6366F1),
              size: 20,
            ),
            SizedBox(width: 10),
            Text('Guru'),
          ],
        ),
      ),

      DropdownMenuItem(
        value: 'siswa',
        child: Row(
          children: [
            Icon(
              Icons.person_rounded,
              color: Color(0xFF10B981),
              size: 20,
            ),
            SizedBox(width: 10),
            Text('Siswa'),
          ],
        ),
      ),
    ],

    onChanged: _isSaving
        ? null
        : (value) {
            if (value == null) return;

            setState(() {
              _role = value;
            });
          },
  );
}

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed:
            _isSaving ? null : _saveUser,

        icon: _isSaving
            ? const SizedBox(
                width: 19,
                height: 19,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.save_rounded,
              ),

        label: Text(
          _isSaving
              ? 'Menyimpan...'
              : 'Simpan Perubahan',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),

        style: FilledButton.styleFrom(
          backgroundColor:
              const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}