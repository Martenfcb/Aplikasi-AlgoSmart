import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ===============================================================
  // CONTROLLERS
  // ===============================================================

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  // ===============================================================
  // STATE
  // ===============================================================

  bool isLoading = false;
  bool obscurePassword = true;

  // Mode default = siswa
  bool _isTeacherMode = false;

  // Secret tap
  int _logoTapCount = 0;
  DateTime? _lastLogoTap;

  // Role otomatis
  String get selectedRole =>
      _isTeacherMode ? 'guru' : 'siswa';

  // ===============================================================
  // COLORS
  // ===============================================================

  static const Color primary =
      Color(0xFF4F46E5);

  static const Color primaryDark =
      Color(0xFF3730A3);

  static const Color purple =
      Color(0xFF7C3AED);

  static const Color green =
      Color(0xFF10B981);

  static const Color red =
      Color(0xFFEF4444);

  static const Color background =
      Color(0xFFF6F7FB);

  static const Color textPrimary =
      Color(0xFF111827);

  static const Color textSecondary =
      Color(0xFF6B7280);

  static const Color border =
      Color(0xFFE5E7EB);

  // ===============================================================
  // DISPOSE
  // ===============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ===============================================================
  // SECRET LOGO TAP
  // ===============================================================

  void _handleLogoTap() {
    if (isLoading) return;

    final now = DateTime.now();

    // Jika jeda terlalu lama,
    // hitungan dimulai kembali.
    if (_lastLogoTap == null ||
        now.difference(_lastLogoTap!).inSeconds > 3) {
      _logoTapCount = 0;
    }

    _lastLogoTap = now;
    _logoTapCount++;

    // =============================================================
    // 5 KALI TAP
    // =============================================================

    if (_logoTapCount >= 5) {
      _logoTapCount = 0;

      if (!mounted) return;

      _showSecretTeacherMenu();
    }
  }

  // ===============================================================
  // SECRET TEACHER MENU
  // ===============================================================

  void _showSecretTeacherMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: false,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: primary.withValues(
                      alpha: .10,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: primary,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Pendaftaran Khusus',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Pilih jenis akun yang ingin dibuat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 22),

                // =================================================
                // GURU
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);

                      if (!mounted) return;

                      setState(() {
                        _isTeacherMode = true;
                      });

                      _showSuccess(
                        'Mode pendaftaran guru aktif.',
                      );
                    },
                    icon: const Icon(
                      Icons.school_rounded,
                      size: 20,
                    ),
                    label: const Text(
                      'DAFTAR SEBAGAI GURU',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .3,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // =================================================
                // BATAL
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textSecondary,
                      side: const BorderSide(
                        color: border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'BATAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===============================================================
  // REGISTER
  // ===============================================================

  Future<void> register() async {
    final email =
        emailController.text.trim();

    final password =
        passwordController.text.trim();

    // =============================================================
    // VALIDASI EMAIL
    // =============================================================

    if (email.isEmpty) {
      _showError(
        'Silakan masukkan email terlebih dahulu.',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      _showError(
        'Format email tidak valid.',
      );
      return;
    }

    // =============================================================
    // VALIDASI PASSWORD
    // =============================================================

    if (password.isEmpty) {
      _showError(
        'Silakan masukkan password terlebih dahulu.',
      );
      return;
    }

    if (password.length < 6) {
      _showError(
        'Password minimal 6 karakter.',
      );
      return;
    }

    // =============================================================
    // LOADING
    // =============================================================

    setState(() {
      isLoading = true;
    });

    try {
      // ===========================================================
      // REGISTER
      // ===========================================================

      await AuthService().register(
        email: email,
        password: password,
        role: selectedRole,
      );

      if (!mounted) return;

      final accountType =
          _isTeacherMode
              ? 'guru'
              : 'siswa';

      _showSuccess(
        'Akun $accountType berhasil dibuat.',
      );

      // Beri waktu snackbar tampil
      await Future.delayed(
        const Duration(
          milliseconds: 900,
        ),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      String message =
          e.toString();

      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.replaceFirst(
          'Exception: ',
          '',
        );
      }

      _showError(message);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ===============================================================
  // VALIDATE EMAIL
  // ===============================================================

  bool _isValidEmail(
    String email,
  ) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }

  // ===============================================================
  // ERROR MESSAGE
  // ===============================================================

  void _showError(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(16),
          backgroundColor:
              const Color(0xFF1F2937),
          duration:
              const Duration(seconds: 3),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration:
                    BoxDecoration(
                  color:
                      red.withValues(
                    alpha: .12,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons
                      .error_outline_rounded,
                  color: red,
                  size: 19,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  message,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ===============================================================
  // SUCCESS MESSAGE
  // ===============================================================

  void _showSuccess(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(16),
          backgroundColor:
              const Color(0xFF1F2937),
          duration:
              const Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration:
                    BoxDecoration(
                  color:
                      green.withValues(
                    alpha: .12,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons
                      .check_circle_outline_rounded,
                  color: green,
                  size: 20,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  message,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          background,

      appBar: AppBar(
        backgroundColor:
            background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(
                    context,
                  );
                },
          icon: const Icon(
            Icons
                .arrow_back_rounded,
            color: textPrimary,
          ),
        ),
        title: const Text(
          'Daftar',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight:
                FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder:
              (
                context,
                constraints,
              ) {
            final isWide =
                constraints.maxWidth >
                    700;

            return Center(
              child:
                  SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    EdgeInsets.fromLTRB(
                  isWide ? 32 : 20,
                  20,
                  isWide ? 32 : 20,
                  30,
                ),
                child:
                    ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 480,
                  ),
                  child:
                      _buildRegisterContent(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===============================================================
  // REGISTER CONTENT
  // ===============================================================

  Widget _buildRegisterContent() {
    return Column(
      children: [
        // =========================================================
        // LOGO
        // =========================================================

        GestureDetector(
          onTap:
              _handleLogoTap,
          behavior:
              HitTestBehavior.opaque,
          child:
              _buildLogo(),
        ),

        const SizedBox(
          height: 18,
        ),

        // =========================================================
        // TITLE
        // =========================================================

        Text(
          _isTeacherMode
              ? 'Daftar Akun Guru'
              : 'Buat Akun Baru',
          textAlign:
              TextAlign.center,
          style:
              const TextStyle(
            color: textPrimary,
            fontSize: 25,
            fontWeight:
                FontWeight.w900,
            letterSpacing:
                -.5,
          ),
        ),

        const SizedBox(
          height: 7,
        ),

        Text(
          _isTeacherMode
              ? 'Buat akun untuk mengelola pembelajaran'
              : 'Mulai belajar Algoritma & Pemrograman',
          textAlign:
              TextAlign.center,
          style:
              const TextStyle(
            color:
                textSecondary,
            fontSize: 12,
          ),
        ),

        const SizedBox(
          height: 26,
        ),

        // =========================================================
        // FORM CARD
        // =========================================================

        _buildFormCard(),

        const SizedBox(
          height: 22,
        ),

        // =========================================================
        // FOOTER
        // =========================================================

        _buildFooter(),
      ],
    );
  }

  // ===============================================================
  // LOGO
  // ===============================================================

  Widget _buildLogo() {
    return Container(
      width: 86,
      height: 86,
      padding:
          const EdgeInsets.all(3),
      decoration:
          const BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            LinearGradient(
          colors: [
            primary,
            purple,
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding:
            const EdgeInsets.all(5),
        decoration:
            const BoxDecoration(
          shape:
              BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child:
              Image.asset(
            'assets/images/logoo.png',
            fit: BoxFit.cover,
            errorBuilder:
                (
              context,
              error,
              stackTrace,
            ) {
              return const Icon(
                Icons.code_rounded,
                color: primary,
                size: 38,
              );
            },
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // FORM CARD
  // ===============================================================

  Widget _buildFormCard() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color: border,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: .04,
            ),
            blurRadius: 18,
            offset:
                const Offset(
              0,
              7,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =======================================================
          // ACCOUNT TYPE
          // =======================================================

          _buildAccountType(),

          const SizedBox(
            height: 22,
          ),

          // =======================================================
          // EMAIL
          // =======================================================

          _buildLabel(
            'Email',
            Icons
                .email_outlined,
          ),

          const SizedBox(
            height: 8,
          ),

          _buildTextField(
            controller:
                emailController,
            hint:
                'Masukkan email',
            icon:
                Icons
                    .email_outlined,
            keyboardType:
                TextInputType
                    .emailAddress,
          ),

          const SizedBox(
            height: 18,
          ),

          // =======================================================
          // PASSWORD
          // =======================================================

          _buildLabel(
            'Password',
            Icons
                .lock_outline_rounded,
          ),

          const SizedBox(
            height: 8,
          ),

          _buildTextField(
            controller:
                passwordController,
            hint:
                'Minimal 6 karakter',
            icon:
                Icons
                    .lock_outline_rounded,
            obscureText:
                obscurePassword,
            suffix:
                IconButton(
              tooltip:
                  obscurePassword
                      ? 'Tampilkan password'
                      : 'Sembunyikan password',
              onPressed:
                  isLoading
                      ? null
                      : () {
                          setState(
                            () {
                              obscurePassword =
                                  !obscurePassword;
                            },
                          );
                        },
              icon:
                  Icon(
                obscurePassword
                    ? Icons
                        .visibility_off_outlined
                    : Icons
                        .visibility_outlined,
                color:
                    textSecondary,
                size: 20,
              ),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // =======================================================
          // PASSWORD INFO
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons
                    .info_outline_rounded,
                color:
                    textSecondary,
                size: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              const Text(
                'Password minimal 6 karakter',
                style:
                    TextStyle(
                  color:
                      textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 22,
          ),

          // =======================================================
          // REGISTER BUTTON
          // =======================================================

          _buildRegisterButton(),

          const SizedBox(
            height: 12,
          ),

          // =======================================================
          // LOGIN BUTTON
          // =======================================================

          SizedBox(
            width:
                double.infinity,
            height: 48,
            child:
                OutlinedButton(
              onPressed:
                  isLoading
                      ? null
                      : () {
                          Navigator.pop(
                            context,
                          );
                        },
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    primary,
                side:
                    BorderSide(
                  color:
                      primary.withValues(
                    alpha: .25,
                  ),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
              child:
                  const Text(
                'SUDAH PUNYA AKUN? MASUK',
                style:
                    TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),

          // =======================================================
          // TEACHER MODE
          // =======================================================

          if (_isTeacherMode) ...[
            const SizedBox(
              height: 14,
            ),
            _buildTeacherModeInfo(),
          ],
        ],
      ),
    );
  }

  // ===============================================================
  // ACCOUNT TYPE
  // ===============================================================

  Widget _buildAccountType() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(13),
      decoration:
          BoxDecoration(
        color:
            primary.withValues(
          alpha: .06,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
        border:
            Border.all(
          color:
              primary.withValues(
            alpha: .10,
          ),
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
                  primary.withValues(
                alpha: .10,
              ),
              shape:
                  BoxShape.circle,
            ),
            child:
                Icon(
              _isTeacherMode
                  ? Icons
                      .admin_panel_settings_rounded
                  : Icons
                      .school_rounded,
              color:
                  primary,
              size: 21,
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  _isTeacherMode
                      ? 'Akun Guru'
                      : 'Akun Siswa',
                  style:
                      const TextStyle(
                    color:
                        textPrimary,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  _isTeacherMode
                      ? 'Digunakan untuk mengelola pembelajaran'
                      : 'Digunakan untuk mengikuti pembelajaran',
                  style:
                      const TextStyle(
                    color:
                        textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // TEACHER MODE INFO
  // ===============================================================

  Widget _buildTeacherModeInfo() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFFFF7ED,
        ),
        borderRadius:
            BorderRadius.circular(
          13,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFFF59E0B,
          ).withValues(
            alpha: .25,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .lock_open_rounded,
            color:
                Color(0xFFD97706),
            size: 17,
          ),

          const SizedBox(
            width: 8,
          ),

          const Expanded(
            child: Text(
              'Mode pendaftaran guru aktif.',
              style:
                  TextStyle(
                color:
                    Color(0xFF92400E),
                fontSize: 10,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

          TextButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                        setState(
                          () {
                            _isTeacherMode =
                                false;
                          },
                        );
                      },
            style:
                TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              minimumSize:
                  const Size(
                0,
                32,
              ),
            ),
            child:
                const Text(
              'Siswa',
              style:
                  TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // REGISTER BUTTON
  // ===============================================================

  Widget _buildRegisterButton() {
    return SizedBox(
      width:
          double.infinity,
      height: 52,
      child:
          ElevatedButton(
        onPressed:
            isLoading
                ? null
                : register,
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              primary,
          foregroundColor:
              Colors.white,
          disabledBackgroundColor:
              primary.withValues(
            alpha: .5,
          ),
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth:
                          2.3,
                      color:
                          Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Icon(
                        _isTeacherMode
                            ? Icons
                                .school_rounded
                            : Icons
                                .person_add_alt_1_rounded,
                        size: 19,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        _isTeacherMode
                            ? 'BUAT AKUN GURU'
                            : 'BUAT AKUN SISWA',
                        style:
                            const TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing:
                              .3,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  // ===============================================================
  // LABEL
  // ===============================================================

  Widget _buildLabel(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: primary,
          size: 15,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          title,
          style:
              const TextStyle(
            color: textPrimary,
            fontSize: 12,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // TEXT FIELD
  // ===============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller:
          controller,
      keyboardType:
          keyboardType,
      obscureText:
          obscureText,
      enabled:
          !isLoading,
      textInputAction:
          obscureText
              ? TextInputAction.done
              : TextInputAction.next,
      style:
          const TextStyle(
        color:
            textPrimary,
        fontSize: 13,
        fontWeight:
            FontWeight.w600,
      ),
      decoration:
          InputDecoration(
        hintText:
            hint,
        hintStyle:
            const TextStyle(
          color:
              Color(0xFF9CA3AF),
          fontSize: 12,
          fontWeight:
              FontWeight.w400,
        ),
        prefixIcon:
            Icon(
          icon,
          color:
              primary,
          size: 20,
        ),
        suffixIcon:
            suffix,
        filled:
            true,
        fillColor:
            const Color(
          0xFFF8F9FC,
        ),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                border,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                primary,
            width:
                1.4,
          ),
        ),
        disabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                border,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // FOOTER
  // ===============================================================

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons
                  .verified_user_outlined,
              color:
                  green,
              size: 15,
            ),
            const SizedBox(
              width: 6,
            ),
            const Text(
              'Data akun terlindungi',
              style:
                  TextStyle(
                color:
                    textSecondary,
                fontSize: 10,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 8,
        ),

        const Text(
          'AlgoSmart • SMK Negeri 1 Sijunjung • v1.0',
          textAlign:
              TextAlign.center,
          style:
              TextStyle(
            color:
                Color(0xFF9CA3AF),
            fontSize: 9,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ],
    );
  }
}