import 'package:flutter/material.dart';

import '../../models/algorithm_type.dart';
import 'algorithm_simulator_page.dart';

class SimulasiPage extends StatefulWidget {
  const SimulasiPage({super.key});

  @override
  State<SimulasiPage> createState() => _SimulasiPageState();
}

class _SimulasiPageState extends State<SimulasiPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(context),
                ),

                SliverToBoxAdapter(
                  child: _buildIntroduction(),
                ),

                SliverToBoxAdapter(
                  child: _buildSectionTitle(),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    30,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildAlgorithmCard(
                        context,
                        title: 'Bubble Sort',
                        subtitle:
                            'Mengurutkan data dengan membandingkan dua elemen yang berdekatan.',
                        icon: Icons.swap_vert_rounded,
                        colors: const [
                          Color(0xFFFF7A59),
                          Color(0xFFFFB347),
                        ],
                        lightColor: const Color(0xFFFFF3E8),
                        algorithm: AlgorithmType.bubble,
                        number: '01',
                      ),

                      const SizedBox(height: 14),

                      _buildAlgorithmCard(
                        context,
                        title: 'Selection Sort',
                        subtitle:
                            'Mengurutkan data dengan memilih nilai terkecil terlebih dahulu.',
                        icon: Icons.sort_rounded,
                        colors: const [
                          Color(0xFF10B981),
                          Color(0xFF34D399),
                        ],
                        lightColor: const Color(0xFFECFDF5),
                        algorithm: AlgorithmType.selection,
                        number: '02',
                      ),

                      const SizedBox(height: 14),

                      _buildAlgorithmCard(
                        context,
                        title: 'Linear Search',
                        subtitle:
                            'Mencari data satu per satu secara berurutan hingga menemukan nilai yang dicari.',
                        icon: Icons.search_rounded,
                        colors: const [
                          Color(0xFF6366F1),
                          Color(0xFF8B5CF6),
                        ],
                        lightColor: const Color(0xFFF1F0FF),
                        algorithm: AlgorithmType.linear,
                        number: '03',
                      ),

                      const SizedBox(height: 14),

                      _buildAlgorithmCard(
                        context,
                        title: 'Binary Search',
                        subtitle:
                            'Mencari data pada array yang sudah terurut dengan membagi area pencarian.',
                        icon: Icons.manage_search_rounded,
                        colors: const [
                          Color(0xFFEF4444),
                          Color(0xFFF97316),
                        ],
                        lightColor: const Color(0xFFFFF0EE),
                        algorithm: AlgorithmType.binary,
                        number: '04',
                      ),

                      const SizedBox(height: 14),

                      _buildAlgorithmCard(
                        context,
                        title: 'Flowchart',
                        subtitle:
                            'Belajar memahami alur logika algoritma menggunakan flowchart interaktif.',
                        icon: Icons.account_tree_rounded,
                        colors: const [
                          Color(0xFF0EA5E9),
                          Color(0xFF06B6D4),
                        ],
                        lightColor: const Color(0xFFEAF9FF),
                        algorithm: AlgorithmType.flowchart,
                        number: '05',
                      ),
                    ]),
                  ),
                ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFEC4899),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.25),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBackButton(context),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simulasi Algoritma',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Belajar sambil mencoba 🚀',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.13),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 13),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eksplorasi Algoritma',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lihat bagaimana algoritma bekerja secara visual dan interaktif.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
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
  // BACK BUTTON
  // ============================================================

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
        },
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INTRODUCTION
  // ============================================================

  Widget _buildIntroduction() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE9ECF4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD166),
                  Color(0xFFFFA62B),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belajar Lebih Mudah',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pilih salah satu simulasi dan lihat proses algoritma langkah demi langkah.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    height: 1.45,
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
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.category_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Simulasi',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Mulai eksplorasi algoritma favoritmu',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '5 SIMULASI',
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ALGORITHM CARD
  // ============================================================

  Widget _buildAlgorithmCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required Color lightColor,
    required AlgorithmType algorithm,
    required String number,
  }) {
    return _SimulationCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      colors: colors,
      lightColor: lightColor,
      number: number,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlgorithmSimulatorPage(
              title: title,
              algorithm: algorithm,
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// SIMULATION CARD
// ================================================================

class _SimulationCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Color lightColor;
  final String number;
  final VoidCallback onTap;

  const _SimulationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.lightColor,
    required this.number,
    required this.onTap,
  });

  @override
  State<_SimulationCard> createState() => _SimulationCardState();
}

class _SimulationCardState extends State<_SimulationCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onTap,
          onTapDown: (_) {
            setState(() {
              _pressed = true;
            });
          },
          onTapCancel: () {
            setState(() {
              _pressed = false;
            });
          },
          onTapUp: (_) {
            setState(() {
              _pressed = false;
            });
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.lightColor,
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.colors.first.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ICON
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: widget.colors.first
                              .withValues(alpha: 0.20),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 31,
                    ),
                  ),

                  const SizedBox(width: 15),

                  // CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.lightColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                widget.number,
                                style: TextStyle(
                                  color: widget.colors.first,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.subtitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11.5,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              'Mulai simulasi',
                              style: TextStyle(
                                color: widget.colors.first,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(width: 5),

                            Icon(
                              Icons.arrow_forward_rounded,
                              color: widget.colors.first,
                              size: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ARROW
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: widget.lightColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: widget.colors.first,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}