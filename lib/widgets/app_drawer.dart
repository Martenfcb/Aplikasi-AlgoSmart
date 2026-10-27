import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth/landing_page.dart';
import '../screens/guru/guru_dashboard.dart';
import '../screens/guru/kelola_cp_atp_page.dart';
import '../screens/guru/kelola_materi_page.dart';
import '../screens/guru/kelola_quiz_page.dart';
import '../screens/guru/kelola_video_page.dart';
import '../screens/guru/kelola_user_page.dart';
import '../screens/guru/nilai_siswa_page.dart';
import '../screens/guru/petunjuk_page.dart';
import '../screens/guru/ranking_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      width: 320,
      elevation: 0,
      backgroundColor: isDark
          ? const Color(0xFF0B1120)
          : const Color(0xFFF8FAFC),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  12,
                  16,
                  12,
                  14,
                ),
                children: [
                  _sectionTitle(
                    context,
                    'UTAMA',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    subtitle: 'Ringkasan aplikasi',
                    color: const Color(0xFF6366F1),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),

                  _sectionTitle(
                    context,
                    'PEMBELAJARAN',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.auto_stories_rounded,
                    title: 'Kelola Materi',
                    subtitle: 'Materi pembelajaran',
                    color: const Color(0xFF2563EB),
                    onTap: () {
                      _openPage(
                        context,
                        const KelolaMateriPage(),
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.video_library_rounded,
                    title: 'Kelola Video',
                    subtitle: 'Video pembelajaran',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      _openPage(
                        context,
                        const KelolaVideoPage(),
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.quiz_rounded,
                    title: 'Kelola Quiz',
                    subtitle: 'Soal dan evaluasi',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      _openPage(
                        context,
                        const KelolaQuizPage(),
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.account_tree_rounded,
                    title: 'Kelola CP & ATP',
                    subtitle: 'Capaian pembelajaran',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      _openPage(
                        context,
                        const KelolaCPATPPage(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _sectionTitle(
                    context,
                    'DATA SISWA',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.groups_rounded,
                    title: 'Kelola User',
                    subtitle: 'Data guru dan siswa',
                    color: const Color(0xFF0EA5E9),
                    onTap: () {
                      _openPage(
                        context,
                        const KelolaUserPage(),
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.assessment_rounded,
                    title: 'Nilai Siswa',
                    subtitle: 'Hasil pembelajaran',
                    color: const Color(0xFF06B6D4),
                    onTap: () {
                      _openPage(
                        context,
                        const NilaiSiswaPage(),
                      );
                    },
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.emoji_events_rounded,
                    title: 'Ranking',
                    subtitle: 'Peringkat siswa',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      _openPage(
                        context,
                        const RankingPage(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _sectionTitle(
                    context,
                    'LAINNYA',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: 'Petunjuk',
                    subtitle:
                        'Panduan penggunaan AlgoSmart',
                    color: const Color(0xFF14B8A6),
                    onTap: () {
                      _openPage(
                        context,
                        const PetunjukPage(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Divider(
                      height: 1,
                      color: theme.dividerColor.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _sectionTitle(
                    context,
                    'AKUN',
                  ),

                  _logoutItem(context),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFDB2777),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -40,
            top: -55,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.06,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            right: 30,
            bottom: -70,
            child: Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.05,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius:
                          BorderRadius.circular(19),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.22,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 18,
                          offset:
                              const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.code_rounded,
                      color: Colors.white,
                      size: 31,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AlgoSmart',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Media Pembelajaran Interaktif',
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.5,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.09,
                    ),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panel Guru',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Kelola pembelajaran AlgoSmart',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.verified_rounded,
                      color: Colors.white70,
                      size: 17,
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

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10,
        5,
        10,
        8,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 12,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 7),

          Text(
            title,
            style: TextStyle(
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.40),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DRAWER ITEM
  // =============================================================

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(17),
        splashColor: color.withValues(
          alpha: 0.08,
        ),
        highlightColor: color.withValues(
          alpha: 0.04,
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 4,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(
                        alpha: 0.68,
                      ),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(
                        alpha: 0.17,
                      ),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 21,
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
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme
                            .colorScheme
                            .onSurface,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme
                            .colorScheme
                            .onSurface
                            .withValues(
                          alpha: 0.42,
                        ),
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOGOUT ITEM
  // =============================================================

  Widget _logoutItem(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showLogoutDialog(context);
        },
        borderRadius:
            BorderRadius.circular(17),
        child: Container(
          margin:
              const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.red.withValues(
              alpha: 0.07,
            ),
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color: Colors.red.withValues(
                alpha: 0.11,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keluar',
                      style: TextStyle(
                        color: theme
                            .colorScheme
                            .onSurface,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Keluar dari akun guru',
                      style: TextStyle(
                        color: theme
                            .colorScheme
                            .onSurface
                            .withValues(
                          alpha: 0.42,
                        ),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOGOUT DIALOG
  // =============================================================

  Future<void> _showLogoutDialog(
    BuildContext context,
  ) async {
    final theme = Theme.of(context);

    final result =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              theme.colorScheme.surface,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(26),
          ),
          contentPadding:
              const EdgeInsets.fromLTRB(
            24,
            25,
            24,
            18,
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 34,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Keluar dari AlgoSmart?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme
                      .colorScheme
                      .onSurface,
                  fontSize: 19,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                'Apakah Anda yakin ingin keluar '
                'dari akun guru?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme
                      .colorScheme
                      .onSurface
                      .withValues(
                    alpha: 0.55,
                  ),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                          false,
                        );
                      },
                      style:
                          OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(
                          0,
                          48,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                        ),
                      ),
                      child:
                          const Text('Batal'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                          true,
                        );
                      },
                      style:
                          FilledButton.styleFrom(
                        backgroundColor:
                            Colors.red,
                        foregroundColor:
                            Colors.white,
                        minimumSize:
                            const Size(
                          0,
                          48,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                        ),
                      ),
                      child:
                          const Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (result != true) {
      return;
    }

    await _logout(context);
  }

  // =============================================================
  // LOGOUT FIREBASE
  // =============================================================

  Future<void> _logout(
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const LandingPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior:
              SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Text(
            e.message ??
                'Gagal keluar dari akun.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior:
              SnackBarBehavior.floating,
          content: Text(
            'Terjadi kesalahan saat keluar dari akun.',
          ),
        ),
      );
    }
  }

  // =============================================================
  // FOOTER
  // =============================================================

  Widget _buildFooter(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        16,
      ),
      child: Column(
        children: [
          Divider(
            color: theme.dividerColor
                .withValues(alpha: 0.10),
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration:
                    BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    7,
                  ),
                ),
                child: const Icon(
                  Icons.code_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),

              const SizedBox(width: 7),

              Text(
                'AlgoSmart',
                style: TextStyle(
                  color: theme
                      .colorScheme
                      .onSurface,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            'Media Pembelajaran Algoritma & Pemrograman',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(
                alpha: 0.38,
              ),
              fontSize: 8.5,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Panel Guru',
            style: TextStyle(
              color: theme
                  .colorScheme
                  .onSurface
                  .withValues(
                alpha: 0.28,
              ),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // OPEN PAGE
  // =============================================================

  void _openPage(
    BuildContext context,
    Widget page,
  ) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }
}