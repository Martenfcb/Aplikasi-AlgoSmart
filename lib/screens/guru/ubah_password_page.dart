import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/guru_profile_service.dart';

class UbahPasswordPage
    extends StatefulWidget {
  const UbahPasswordPage({
    super.key,
  });

  @override
  State<UbahPasswordPage>
      createState() =>
          _UbahPasswordPageState();
}

class _UbahPasswordPageState
    extends State<UbahPasswordPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _service =
      GuruProfileService();

  final _currentController =
      TextEditingController();

  final _newController =
      TextEditingController();

  final _confirmController =
      TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Ubah Password'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
              const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(22),
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
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.lock_rounded,
                    color:
                        Colors.white,
                    size: 45,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Keamanan Akun',
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Gunakan password yang kuat dan mudah kamu ingat.',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            _passwordField(
              controller:
                  _currentController,
              label:
                  'Password Saat Ini',
              obscure:
                  _hideCurrent,
              onToggle: () {
                setState(() {
                  _hideCurrent =
                      !_hideCurrent;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Password saat ini wajib diisi';
                }

                return null;
              },
            ),

            _passwordField(
              controller:
                  _newController,
              label:
                  'Password Baru',
              obscure:
                  _hideNew,
              onToggle: () {
                setState(() {
                  _hideNew =
                      !_hideNew;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Password baru wajib diisi';
                }

                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }

                return null;
              },
            ),

            _passwordField(
              controller:
                  _confirmController,
              label:
                  'Konfirmasi Password Baru',
              obscure:
                  _hideConfirm,
              onToggle: () {
                setState(() {
                  _hideConfirm =
                      !_hideConfirm;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Konfirmasi password wajib diisi';
                }

                if (value !=
                    _newController
                        .text) {
                  return 'Password tidak sama';
                }

                return null;
              },
            ),

            const SizedBox(
              height: 12,
            ),

            SizedBox(
              height: 52,
              child:
                  FilledButton.icon(
                onPressed:
                    _loading
                        ? null
                        : _changePassword,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons
                            .security_rounded,
                      ),
                label: Text(
                  _loading
                      ? 'Memproses...'
                      : 'Ubah Password',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController
        controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)?
        validator,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 15,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration:
            InputDecoration(
          labelText: label,
          prefixIcon:
              const Icon(
            Icons.lock_outline_rounded,
          ),
          suffixIcon:
              IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons
                      .visibility_off_rounded
                  : Icons
                      .visibility_rounded,
            ),
          ),
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
      ),
    );
  }

Future<void> _changePassword() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _loading = true;
  });

  try {
    await _service.reauthenticate(
      _currentController.text,
    );

    await _service.changePassword(
      _newController.text,
    );

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Berhasil',
        ),
        content: const Text(
          'Password akun berhasil diubah.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        message = 'Password saat ini salah.';
        break;

      case 'requires-recent-login':
        message =
            'Sesi login sudah terlalu lama. Silakan login kembali.';
        break;

      case 'weak-password':
        message = 'Password baru terlalu lemah.';
        break;

      default:
        message =
            e.message ?? 'Gagal mengubah password.';
    }

    _showError(message);
  } catch (e) {
    _showError(
      'Terjadi kesalahan: $e',
    );
  } finally {
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}

  void _showError(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(message),
        backgroundColor:
            Colors.red,
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}