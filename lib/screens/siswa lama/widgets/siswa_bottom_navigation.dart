import 'package:flutter/material.dart';

class SiswaBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SiswaBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color background = Color(0xFFF8F9FF);
  static const Color textMuted = Color(0xFF8A90A3);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final barColor = isDark
        ? const Color(0xFF111827)
        : Colors.white;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          12,
          0,
          12,
          12,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE8EAF3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.25 : 0.08,
              ),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildItem(
              context: context,
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Beranda',
            ),
            _buildItem(
              context: context,
              index: 1,
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book_rounded,
              label: 'Materi',
            ),
            _buildItem(
              context: context,
              index: 2,
              icon: Icons.play_circle_outline_rounded,
              activeIcon: Icons.play_circle_fill_rounded,
              label: 'Video',
            ),
            _buildItem(
              context: context,
              index: 3,
              icon: Icons.quiz_outlined,
              activeIcon: Icons.quiz_rounded,
              label: 'Quiz',
            ),
            _buildItem(
              context: context,
              index: 4,
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final selected = currentIndex == index;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeOutCubic,
                width: selected ? 58 : 42,
                height: 32,
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primary,
                            primaryDark,
                          ],
                        )
                      : null,
                  color: selected
                      ? null
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(12),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: primary.withValues(
                              alpha: 0.25,
                            ),
                            blurRadius: 10,
                            offset: const Offset(
                              0,
                              4,
                            ),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  selected ? activeIcon : icon,
                  size: selected ? 19 : 21,
                  color: selected
                      ? Colors.white
                      : isDark
                          ? const Color(0xFF94A3B8)
                          : textMuted,
                ),
              ),

              const SizedBox(height: 4),

              AnimatedDefaultTextStyle(
                duration: const Duration(
                  milliseconds: 200,
                ),
                style: TextStyle(
                  fontSize: selected ? 10 : 9.5,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: selected
                      ? primary
                      : isDark
                          ? const Color(0xFF94A3B8)
                          : textMuted,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}