import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../guru/guru_dashboard.dart';
import '../siswa/siswa_dashboard.dart';
import 'register_page.dart';

const Color _primary = Color(0xFF6366F1);
const Color _primaryDark = Color(0xFF4F46E5);
const Color _violet = Color(0xFF8B5CF6);
const Color _cyan = Color(0xFF06B6D4);
const Color _pink = Color(0xFFEC4899);

const Color _background = Color(0xFFF6F7FB);
const Color _textDark = Color(0xFF111827);
const Color _textMuted = Color(0xFF667085);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

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
  // LOGIN
  // ===============================================================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      _showError('Masukkan email terlebih dahulu.');
      return;
    }

    if (password.isEmpty) {
      _showError('Masukkan password terlebih dahulu.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await AuthService().login(
        email: email,
        password: password,
      );

      if (user == null) {
        throw Exception(
          'Email atau password tidak sesuai.',
        );
      }

      final userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userData.exists) {
        throw Exception(
          'Data pengguna tidak ditemukan.',
        );
      }

      final data = userData.data();
      final role = data?['role'];

      if (!mounted) return;

      // ===========================================================
      // GURU
      // ===========================================================

      if (role == 'guru') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const GuruDashboard(),
          ),
        );
      }

      // ===========================================================
      // SISWA
      // ===========================================================

      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SiswaDashboard(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      var message = e.toString();

      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
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
  // ERROR
  // ===============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFFDC2626),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width = constraints.maxWidth;

            final bool smallPhone = width < 360;
            final bool phone = width < 600;
            final bool tablet = width >= 600;

            final double horizontalPadding = tablet
                ? 55
                : smallPhone
                    ? 14
                    : 20;

            return Stack(
              children: [
                // =================================================
                // BACKGROUND
                // =================================================

                Positioned.fill(
                  child: _buildBackground(
                    width,
                    tablet,
                  ),
                ),

                // =================================================
                // CONTENT
                // =================================================

                SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    tablet ? 35 : 18,
                    horizontalPadding,
                    25,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(
                        maxWidth: 470,
                      ),
                      child: Column(
                        children: [
                          // Back button
                          Align(
                            alignment:
                                Alignment.centerLeft,
                            child:
                                _buildBackButton(
                                  context,
                                ),
                          ),

                          SizedBox(
                            height: tablet
                                ? 20
                                : 10,
                          ),

                          _buildLogo(
                            smallPhone,
                            tablet,
                          ),

                          SizedBox(
                            height: tablet
                                ? 28
                                : 22,
                          ),

                          _buildLoginCard(
                            context,
                            smallPhone,
                            tablet,
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          _buildRegisterSection(
                            context,
                            smallPhone,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ===============================================================
  // BACKGROUND
  // ===============================================================

  Widget _buildBackground(
    double width,
    bool tablet,
  ) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -90,
          child: _glowCircle(
            tablet ? 300 : 230,
            _violet.withValues(alpha: .10),
          ),
        ),

        Positioned(
          top: 220,
          left: -100,
          child: _glowCircle(
            tablet ? 260 : 200,
            _cyan.withValues(alpha: .07),
          ),
        ),

        Positioned(
          bottom: -100,
          right: -80,
          child: _glowCircle(
            tablet ? 280 : 210,
            _pink.withValues(alpha: .06),
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // BACK BUTTON
  // ===============================================================

  Widget _buildBackButton(
    BuildContext context,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
        },
        child: Ink(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE7E8EF),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(
                  alpha: .035,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: _textDark,
            size: 21,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // LOGO
  // ===============================================================

  Widget _buildLogo(
    bool smallPhone,
    bool tablet,
  ) {
    final double size = tablet
        ? 105
        : smallPhone
            ? 78
            : 88;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow
            Container(
              width: size + 30,
              height: size + 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        _primary.withValues(
                      alpha: .18,
                    ),
                    blurRadius: 35,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),

            // Gradient ring
            Container(
              width: size,
              height: size,
              padding:
                  const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _cyan,
                    _primary,
                    _pink,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.all(6),
                decoration:
                    const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logoo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.code_rounded,
                        color: _primary,
                        size: 42,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          'AlgoSmart',
          style: TextStyle(
            color: _textDark,
            fontSize: tablet
                ? 29
                : smallPhone
                    ? 24
                    : 27,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Media Pembelajaran Algoritma & Pemrograman',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textMuted,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // LOGIN CARD
  // ===============================================================

  Widget _buildLoginCard(
    BuildContext context,
    bool smallPhone,
    bool tablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        tablet
            ? 28
            : smallPhone
                ? 17
                : 21,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(27),
        border: Border.all(
          color: const Color(0xFFE8EAF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .055,
            ),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =======================================================
          // CARD HEADER
          // =======================================================

          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      _primary,
                      _violet,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _primary.withValues(
                        alpha: .20,
                      ),
                      blurRadius: 12,
                      offset:
                          const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang 👋',
                      style: TextStyle(
                        color: _textDark,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Masuk untuk melanjutkan belajar.',
                      style: TextStyle(
                        color: _textMuted,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =======================================================
          // EMAIL
          // =======================================================

          _buildLabel(
            'Email',
            Icons.email_outlined,
          ),

          const SizedBox(height: 8),

          _buildTextField(
            controller: emailController,
            hint: 'Masukkan email kamu',
            icon: Icons.email_outlined,
            keyboardType:
                TextInputType.emailAddress,
          ),

          const SizedBox(height: 17),

          // =======================================================
          // PASSWORD
          // =======================================================

          _buildLabel(
            'Password',
            Icons.lock_outline_rounded,
          ),

          const SizedBox(height: 8),

          _buildTextField(
            controller: passwordController,
            hint: 'Masukkan password',
            icon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
            suffix: IconButton(
              tooltip: obscurePassword
                  ? 'Tampilkan password'
                  : 'Sembunyikan password',
              onPressed: () {
                setState(() {
                  obscurePassword =
                      !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons
                        .visibility_outlined
                    : Icons
                        .visibility_off_outlined,
                color: _textMuted,
                size: 21,
              ),
            ),
          ),

          const SizedBox(height: 22),

          // =======================================================
          // LOGIN BUTTON
          // =======================================================

          SizedBox(
            width: double.infinity,
            height: tablet ? 56 : 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    _primary,
                    _primaryDark,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius:
                    BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:
                        _primary.withValues(
                      alpha: .24,
                    ),
                    blurRadius: 15,
                    offset:
                        const Offset(0, 7),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : login,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent,
                  disabledBackgroundColor:
                      Colors.transparent,
                  foregroundColor:
                      Colors.white,
                  shadowColor:
                      Colors.transparent,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<
                                  Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            Icons
                                .login_rounded,
                            size: 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'MASUK SEKARANG',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w900,
                              letterSpacing: .5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // LABEL
  // ===============================================================

  Widget _buildLabel(
    String text,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: _primary,
          size: 15,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: _textDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
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
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: obscureText
          ? TextInputAction.done
          : TextInputAction.next,
      onSubmitted: obscureText
          ? (_) => login()
          : null,
      style: const TextStyle(
        color: _textDark,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFA3A6B5),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),

        prefixIcon: Container(
          margin: const EdgeInsets.only(
            left: 7,
            right: 5,
          ),
          child: Icon(
            icon,
            color: _primary,
            size: 20,
          ),
        ),

        suffixIcon: suffix,

        filled: true,

        fillColor: const Color(0xFFF8F9FD),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE7E9F0),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: _primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // REGISTER SECTION
  // ===============================================================

  Widget _buildRegisterSection(
    BuildContext context,
    bool smallPhone,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: smallPhone ? 14 : 18,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: .82,
        ),
        borderRadius:
            BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE7E8EF),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Belum punya akun?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Material(
            color: Colors.transparent,
            borderRadius:
                BorderRadius.circular(13),
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(13),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const RegisterPage(),
                  ),
                );
              },
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color:
                      _primary.withValues(
                    alpha: .07,
                  ),
                  borderRadius:
                      BorderRadius.circular(13),
                  border: Border.all(
                    color:
                        _primary.withValues(
                      alpha: .12,
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons
                          .person_add_alt_1_rounded,
                      color: _primary,
                      size: 17,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Daftar Akun',
                      style: TextStyle(
                        color: _primaryDark,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons
                          .arrow_forward_rounded,
                      color: _primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
            Container(
              width: 6,
              height: 6,
              decoration:
                  const BoxDecoration(
                color: _greenColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'AlgoSmart siap digunakan',
              style: TextStyle(
                color: _textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        const Text(
          'SMK Negeri 1 Sijunjung • © 2026',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 8.5,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // GLOW
  // ===============================================================

  Widget _glowCircle(
    double size,
    Color color,
  ) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 35,
        sigmaY: 35,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ===================================================================
// EXTRA COLOR
// ===================================================================

const Color _greenColor = Color(0xFF10B981);