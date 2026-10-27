import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static const primary = Color(0xFF6366F1);
  static const primaryDark = Color(0xFF4338CA);
  static const violet = Color(0xFF8B5CF6);
  static const cyan = Color(0xFF06B6D4);
  static const pink = Color(0xFFEC4899);
  static const green = Color(0xFF10B981);
  static const orange = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const background = Color(0xFFF6F7FB);
  static const dark = Color(0xFF111827);
  static const grey = Color(0xFF667085);
  static const softGrey = Color(0xFF98A2B3);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LandingPage.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final small = w < 360;
            final phone = w < 600;
            final tablet = w >= 600;
            final wide = w >= 900;
            final hPad = tablet ? (wide ? 40.0 : 28.0) : (small ? 12.0 : 16.0);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    children: [
                      _appHeader(small, tablet),
                      _hero(context, small, phone, tablet),
                      _features(hPad, small, tablet),
                      _learning(hPad, small),
                      _loginSection(context, hPad, small, tablet),
                      _footer(small),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _appHeader(bool small, bool tablet) {
    return Padding(
      padding: EdgeInsets.fromLTRB(tablet ? 28 : small ? 12 : 16, 9,
          tablet ? 28 : small ? 12 : 16, 4),
      child: Container(
        height: small ? 58 : tablet ? 70 : 62,
        padding: EdgeInsets.symmetric(horizontal: small ? 8 : 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: const Color(0xFFE7E9F1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .055),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: small ? 41 : tablet ? 48 : 43,
              height: small ? 41 : tablet ? 48 : 43,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [LandingPage.primaryDark, LandingPage.violet],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  'assets/images/logoo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AlgoSmart',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: LandingPage.dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      )),
                  SizedBox(height: 2),
                  Text('Algoritma & Pemrograman',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: LandingPage.grey,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            if (!small)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: LandingPage.green, size: 7),
                    SizedBox(width: 5),
                    Text('AKTIF',
                        style: TextStyle(
                          color: Color(0xFF059669),
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context, bool small, bool phone, bool tablet) {
    final logo = tablet ? 138.0 : small ? 84.0 : 102.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(tablet ? 28 : small ? 12 : 14, 9,
          tablet ? 28 : small ? 12 : 14, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
            tablet ? 38 : small ? 15 : 19,
            tablet ? 34 : small ? 19 : 24,
            tablet ? 38 : small ? 15 : 19,
            tablet ? 32 : small ? 21 : 25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF312E81),
              Color(0xFF4F46E5),
              Color(0xFF7C3AED),
              Color(0xFF9333EA)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(tablet ? 34 : small ? 27 : 31),
          boxShadow: [
            BoxShadow(
              color: LandingPage.primary.withValues(alpha: .25),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _decoration(155, -60, -72, true),
            _decoration(125, null, -58, false),
            Positioned(
              right: 14,
              bottom: 16,
              child: Transform.rotate(
                angle: -.1,
                child: Icon(Icons.code_rounded,
                    color: Colors.white.withValues(alpha: .045),
                    size: tablet ? 92 : 72),
              ),
            ),
            Column(
              children: [
                _heroLogo(logo),
                SizedBox(height: tablet ? 18 : 14),
                _badge(small),
                const SizedBox(height: 13),
                Text('AlgoSmart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: tablet ? 39 : small ? 28 : 33,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.3,
                    )),
                const SizedBox(height: 8),
                Text('Belajar Algoritma & Pemrograman',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: tablet ? 15 : 12.5,
                      fontWeight: FontWeight.w800,
                    )),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Text(
                    'Belajar materi, menonton video, mengerjakan quiz, '
                    'dan latihan dengan cara yang lebih mudah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.55,
                    ),
                  ),
                ),
                SizedBox(height: small ? 17 : 20),
                SizedBox(
                  width: double.infinity,
                  height: tablet ? 55 : 50,
                  child: FilledButton.icon(
                    onPressed: () => _login(context),
                    icon: const Icon(Icons.login_rounded, size: 19),
                    label: const Text('MASUK KE ALGOSMART',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .5,
                        )),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: LandingPage.primaryDark,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Text('Mulai belajar dalam beberapa detik ✨',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .58),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _decoration(double size, double? x, double y, bool right) {
    return Positioned(
      right: right ? x : null,
      left: right ? null : x,
      top: y,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          final t = _controller.value * math.pi * 2;
          return Transform.translate(
            offset: Offset(math.sin(t) * 7, math.cos(t) * 5),
            child: child,
          );
        },
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(bool small) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 9 : 12, vertical: small ? 6 : 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: .15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome_rounded,
              color: Color(0xFFFFD166), size: 14),
          const SizedBox(width: 6),
          Text('MEDIA PEMBELAJARAN INTERAKTIF',
              style: TextStyle(
                color: Colors.white,
                fontSize: small ? 7 : 8,
                fontWeight: FontWeight.w900,
                letterSpacing: .65,
              )),
        ],
      ),
    );
  }

  Widget _heroLogo(double size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final t = _controller.value * math.pi * 2;
        return Transform.translate(
          offset: Offset(0, math.sin(t) * 3),
          child: Transform.rotate(angle: math.sin(t) * .025, child: child),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size + 24,
            height: size + 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: LandingPage.cyan.withValues(alpha: .25),
                  blurRadius: 34,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [LandingPage.cyan, Colors.white, LandingPage.pink],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logoo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.code_rounded,
                    color: LandingPage.primary,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _features(double hp, bool small, bool tablet) {
    const items = [
      _FeatureData(Icons.auto_stories_rounded, 'Materi', 'Pelajari konsep',
          LandingPage.primary, LandingPage.violet, '01'),
      _FeatureData(Icons.ondemand_video_rounded, 'Video', 'Belajar visual',
          LandingPage.red, Color(0xFFFB7185), '02'),
      _FeatureData(Icons.quiz_rounded, 'Quiz', 'Uji kemampuan',
          LandingPage.green, Color(0xFF34D399), '03'),
      _FeatureData(Icons.code_rounded, 'Latihan', 'Latihan coding',
          LandingPage.cyan, Color(0xFF22D3EE), '04'),
      _FeatureData(Icons.emoji_events_rounded, 'Ranking', 'Lihat peringkat',
          LandingPage.orange, Color(0xFFFBBF24), '05'),
      _FeatureData(Icons.insights_rounded, 'Progress', 'Pantau belajar',
          LandingPage.pink, Color(0xFFF472B6), '06'),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 27, hp, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'Fitur Pembelajaran',
            subtitle: 'Semua kebutuhan belajar dalam satu aplikasi',
            icon: Icons.apps_rounded,
            color: LandingPage.primary,
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: tablet ? 3 : 2,
              crossAxisSpacing: small ? 9 : 11,
              mainAxisSpacing: small ? 9 : 11,
              mainAxisExtent: small ? 164 : tablet ? 178 : 172,
            ),
            itemBuilder: (_, i) => _FeatureCard(data: items[i], index: i),
          ),
        ],
      ),
    );
  }

  Widget _learning(double hp, bool small) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 27, hp, 0),
      child: Container(
        padding: EdgeInsets.all(small ? 14 : 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFE6E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .035),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LearningHeader(),
            SizedBox(height: 16),
            _LearningItem(Icons.menu_book_rounded, 'Pelajari materi',
                'Pahami konsep dasar', LandingPage.primary, '01'),
            SizedBox(height: 9),
            _LearningItem(Icons.code_rounded, 'Kerjakan latihan',
                'Asah kemampuan coding', LandingPage.cyan, '02'),
            SizedBox(height: 9),
            _LearningItem(Icons.quiz_rounded, 'Ikuti quiz',
                'Uji pemahamanmu', LandingPage.green, '03'),
            SizedBox(height: 9),
            _LearningItem(Icons.emoji_events_rounded, 'Tingkatkan ranking',
                'Kumpulkan nilai terbaik', LandingPage.orange, '04'),
          ],
        ),
      ),
    );
  }

  Widget _loginSection(
      BuildContext context, double hp, bool small, bool tablet) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 27, hp, 0),
      child: Container(
        padding: EdgeInsets.all(small ? 16 : tablet ? 25 : 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF), Color(0xFFFDF4FF)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: LandingPage.primary.withValues(alpha: .10),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [LandingPage.primary, LandingPage.violet],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: LandingPage.primary.withValues(alpha: .20),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.rocket_launch_rounded,
                  color: Colors.white, size: 27),
            ),
            const SizedBox(height: 13),
            const Text('Siap untuk belajar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: LandingPage.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                )),
            const SizedBox(height: 5),
            const Text(
              'Masuk ke akunmu dan lanjutkan perjalanan belajar di AlgoSmart.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LandingPage.grey,
                fontSize: 10.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              width: double.infinity,
              height: 51,
              child: FilledButton.icon(
                onPressed: () => _login(context),
                icon: const Icon(Icons.login_rounded, size: 18),
                label: const Text('MASUK SEKARANG',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5,
                    )),
                style: FilledButton.styleFrom(
                  backgroundColor: LandingPage.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer(bool small) {
    return Padding(
      padding: EdgeInsets.fromLTRB(small ? 12 : 18, 28, small ? 12 : 18, 23),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EF)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                'assets/images/logoo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.school_rounded,
                  color: LandingPage.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          const Text('AlgoSmart',
              style: TextStyle(
                color: LandingPage.dark,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 4),
          const Text('Media Pembelajaran Algoritma & Pemrograman',
              textAlign: TextAlign.center,
              style: TextStyle(color: LandingPage.softGrey, fontSize: 9)),
          const SizedBox(height: 5),
          const Text('SMK Negeri 1 Sijunjung • © 2026',
              style: TextStyle(color: LandingPage.softGrey, fontSize: 8.5)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: .70)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: .18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    color: LandingPage.dark,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  )),
              const SizedBox(height: 3),
              Text(subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: LandingPage.grey,
                    fontSize: 9.5,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title, subtitle, number;
  final Color color, secondary;

  const _FeatureData(
      this.icon, this.title, this.subtitle, this.color, this.secondary, this.number);
}

class _FeatureCard extends StatefulWidget {
  final _FeatureData data;
  final int index;

  const _FeatureCard({required this.data, required this.index});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1900 + widget.index * 120),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return AnimatedScale(
      scale: pressed ? .965 : 1,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          borderRadius: BorderRadius.circular(23),
          onTap: () {},
          onTapDown: (_) => setState(() => pressed = true),
          onTapCancel: () => setState(() => pressed = false),
          onTapUp: (_) => setState(() => pressed = false),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: d.color.withValues(alpha: .13)),
              boxShadow: [
                BoxShadow(
                  color: d.color.withValues(alpha: .09),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -27,
                  top: -27,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: d.color.withValues(alpha: .055),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -18,
                  bottom: -18,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: d.secondary.withValues(alpha: .045),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (_, child) => Transform.translate(
                              offset: Offset(
                                0,
                                math.sin(_controller.value * math.pi) * -3,
                              ),
                              child: child,
                            ),
                            child: Container(
                              width: 49,
                              height: 49,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [d.color, d.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: d.color.withValues(alpha: .22),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(d.icon,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              color: d.color.withValues(alpha: .08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                color: d.color, size: 10),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: LandingPage.dark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                    )),
                                const SizedBox(height: 3),
                                Text(d.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: LandingPage.grey,
                                      fontSize: 8.8,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ),
                          Text(d.number,
                              style: TextStyle(
                                color: d.color.withValues(alpha: .18),
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: d.color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 5),
                          Text('Jelajahi fitur',
                              style: TextStyle(
                                color: d.color,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LearningHeader extends StatelessWidget {
  const _LearningHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB703), LandingPage.orange],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.lightbulb_rounded,
              color: Colors.white, size: 23),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Belajar Lebih Terarah',
                  style: TextStyle(
                    color: LandingPage.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  )),
              SizedBox(height: 3),
              Text('Ikuti langkah belajar secara bertahap.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: LandingPage.grey, fontSize: 9.5)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_rounded,
            color: LandingPage.orange, size: 18),
      ],
    );
  }
}

class _LearningItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, step;
  final Color color;

  const _LearningItem(
      this.icon, this.title, this.subtitle, this.color, this.step);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {},
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: .065), color.withValues(alpha: .018)],
            ),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: color.withValues(alpha: .09)),
          ),
          child: Row(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: .70)],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF344054),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LandingPage.softGrey,
                          fontSize: 8.5,
                        )),
                  ],
                ),
              ),
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .09),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(step,
                      style: TextStyle(
                        color: color,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
