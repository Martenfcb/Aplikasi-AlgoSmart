import 'package:flutter/material.dart';

import '../siswa_dashboard.dart';
import '../petunjuk_siswa_page.dart';
import '../profile_page.dart';

class SiswaBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const SiswaBottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color textMuted = Color(0xFF8A90A3);

  @override
  State<SiswaBottomNavigation> createState() =>
      _SiswaBottomNavigationState();
}

class _SiswaBottomNavigationState
    extends State<SiswaBottomNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.94,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final barColor = isDark
        ? const Color(0xFF111827)
        : Colors.white;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          0,
          10,
          10,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: SiswaBottomNavigation.primary.withValues(
                  alpha: isDark ? 0.18 : 0.10,
                ),
                blurRadius: 25,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : const Color(0xFFE8EAF3),
              ),
            ),
            child: Row(
              children: [
                // ==================================================
                // 0 - BERANDA
                // ==================================================
                _buildItem(
                  context: context,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Beranda',
                ),

                // ==================================================
                // 1 - PETUNJUK
                // ==================================================
                _buildItem(
                  context: context,
                  index: 1,
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: 'Petunjuk',
                ),

                // ==================================================
                // 2 - PROFIL
                // ==================================================
                _buildItem(
                  context: context,
                  index: 2,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HANDLE TAP
  // ============================================================

  void _handleTap(
    BuildContext context,
    int index,
  ) {
    // Jika parent memberikan onTap,
    // gunakan callback tersebut.
    if (widget.onTap != null) {
      widget.onTap!(index);
      return;
    }

    // Jika sudah berada di halaman yang sama,
    // tidak perlu melakukan navigasi ulang.
    if (index == widget.currentIndex) {
      return;
    }

    _navigate(context, index);
  }

  // ============================================================
  // NAVIGASI
  // ============================================================

  void _navigate(
    BuildContext context,
    int index,
  ) {
    switch (index) {
      // ========================================================
      // 0 = BERANDA
      // ========================================================

      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const SiswaDashboard(),
          ),
          (route) => false,
        );
        break;

      // ========================================================
      // 1 = PETUNJUK
      // ========================================================

      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const PetunjukSiswaPage(),
          ),
        );
        break;

      // ========================================================
      // 2 = PROFIL
      // ========================================================

      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
        break;
    }
  }

  // ============================================================
  // BOTTOM NAV ITEM
  // ============================================================

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final selected =
        widget.currentIndex == index;

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _handleTap(
            context,
            index,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // ICON
              // ==================================================

              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (
                  context,
                  child,
                ) {
                  return Transform.scale(
                    scale: selected
                        ? _pulseAnimation.value
                        : 1.0,
                    child: child,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 280,
                  ),
                  curve: Curves.easeOutCubic,
                  width: selected ? 58 : 42,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              SiswaBottomNavigation.primary,
                              SiswaBottomNavigation.secondary,
                            ],
                          )
                        : null,
                    borderRadius:
                        BorderRadius.circular(13),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color:
                                  SiswaBottomNavigation
                                      .primary
                                      .withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 13,
                              spreadRadius: 1,
                              offset: const Offset(
                                0,
                                4,
                              ),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    selected
                        ? activeIcon
                        : icon,
                    size: selected ? 20 : 21,
                    color: selected
                        ? Colors.white
                        : isDark
                            ? const Color(
                                0xFF94A3B8,
                              )
                            : SiswaBottomNavigation
                                .textMuted,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ==================================================
              // LABEL
              // ==================================================

              AnimatedDefaultTextStyle(
                duration: const Duration(
                  milliseconds: 220,
                ),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: selected
                      ? 10
                      : 9.5,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: selected
                      ? SiswaBottomNavigation.primary
                      : isDark
                          ? const Color(
                              0xFF94A3B8,
                            )
                          : SiswaBottomNavigation
                              .textMuted,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}