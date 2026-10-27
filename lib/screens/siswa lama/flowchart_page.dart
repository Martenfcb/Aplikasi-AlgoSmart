import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/flow_node_model.dart';
import '../../widgets/flowchart/flow_arrow.dart';
import '../../widgets/flowchart/flow_node.dart';

class FlowchartPage extends StatefulWidget {
  const FlowchartPage({super.key});

  @override
  State<FlowchartPage> createState() => _FlowchartPageState();
}

class _FlowchartPageState extends State<FlowchartPage> {
  Timer? _timer;

  bool _isPlaying = false;

  int _currentStep = 0;

  double _speed = 1.0;

  late List<FlowNodeModel> _nodes;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _nodes = [
      const FlowNodeModel(
        title: 'START',
        description: 'Program dimulai.',
        type: FlowNodeType.start,
        color: Colors.green,
        active: true,
      ),
      const FlowNodeModel(
        title: 'Input Data',
        description: 'Masukkan data yang akan diproses.',
        type: FlowNodeType.input,
        color: Colors.orange,
      ),
      const FlowNodeModel(
        title: 'Bandingkan\nA > B ?',
        description:
            'Bandingkan dua elemen yang bersebelahan. Jika A lebih besar dari B, data perlu ditukar.',
        type: FlowNodeType.decision,
        color: Colors.red,
      ),
      const FlowNodeModel(
        title: 'Tukar Data',
        description:
            'Tukar posisi data A dan B karena A lebih besar dari B.',
        type: FlowNodeType.process,
        color: Colors.blue,
      ),
      const FlowNodeModel(
        title: 'Output',
        description:
            'Tampilkan data yang telah diproses menggunakan algoritma Bubble Sort.',
        type: FlowNodeType.output,
        color: Colors.deepPurple,
      ),
      const FlowNodeModel(
        title: 'END',
        description: 'Algoritma selesai.',
        type: FlowNodeType.end,
        color: Colors.green,
      ),
    ];
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ============================================================
  // CURRENT NODE
  // ============================================================

  FlowNodeModel get _currentNode => _nodes[_currentStep];

  // ============================================================
  // UPDATE STEP
  // ============================================================

  void _updateStep(int step) {
    if (step < 0 || step >= _nodes.length) {
      return;
    }

    setState(() {
      _currentStep = step;

      _nodes = List.generate(
        _nodes.length,
        (index) => _nodes[index].copyWith(
          active: index == step,
        ),
      );
    });
  }

  // ============================================================
  // NEXT
  // ============================================================

  void _nextStep() {
    if (_currentStep >= _nodes.length - 1) {
      return;
    }

    _updateStep(_currentStep + 1);
  }

  // ============================================================
  // PREVIOUS
  // ============================================================

  void _previousStep() {
    if (_currentStep <= 0) {
      return;
    }

    _updateStep(_currentStep - 1);
  }

  // ============================================================
  // RESET
  // ============================================================

  void _resetSimulation() {
    _timer?.cancel();

    setState(() {
      _isPlaying = false;
      _currentStep = 0;

      _nodes = List.generate(
        _nodes.length,
        (index) => _nodes[index].copyWith(
          active: index == 0,
        ),
      );
    });
  }

  // ============================================================
  // PLAY
  // ============================================================

  void _playSimulation() {
    if (_isPlaying) {
      return;
    }

    if (_currentStep >= _nodes.length - 1) {
      _updateStep(0);
    }

    setState(() {
      _isPlaying = true;
    });

    _timer?.cancel();

    final milliseconds = (1000 / _speed).round();

    _timer = Timer.periodic(
      Duration(milliseconds: milliseconds),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_currentStep < _nodes.length - 1) {
          _updateStep(_currentStep + 1);
        } else {
          timer.cancel();

          setState(() {
            _isPlaying = false;
          });
        }
      },
    );
  }

  // ============================================================
  // PAUSE
  // ============================================================

  void _pauseSimulation() {
    _timer?.cancel();

    setState(() {
      _isPlaying = false;
    });
  }

  // ============================================================
  // SPEED
  // ============================================================

  void _changeSpeed(double value) {
    setState(() {
      _speed = value;
    });

    if (_isPlaying) {
      _pauseSimulation();
      _playSimulation();
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final progress =
        (_currentStep + 1) / _nodes.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            SliverToBoxAdapter(
              child: _buildIntroCard(),
            ),

            SliverToBoxAdapter(
              child: _buildFlowchartCard(),
            ),

            SliverToBoxAdapter(
              child: _buildCurrentStepCard(),
            ),

            SliverToBoxAdapter(
              child: _buildProgressCard(progress),
            ),

            SliverToBoxAdapter(
              child: _buildControlCard(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 35),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        18,
      ),

      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        18,
        20,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFFEC4899),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1)
                .withValues(alpha: 0.28),

            blurRadius: 25,

            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              _buildHeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flowchart Interaktif',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Algoritma dan Pemrograman',
                      style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: 0.80),
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.20),
                  ),
                ),
                child: const Icon(
                  Icons.account_tree_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Belajar sambil melihat alurnya 🚀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Ikuti setiap langkah Bubble Sort secara interaktif.',
                      style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: 0.78),
                        fontSize: 11,
                        height: 1.4,
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
  // HEADER BUTTON
  // ============================================================

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(14),

        child: Ink(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.16),

            borderRadius:
                BorderRadius.circular(14),

            border: Border.all(
              color: Colors.white
                  .withValues(alpha: 0.16),
            ),
          ),

          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INTRO CARD
  // ============================================================

  Widget _buildIntroCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        18,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: const Color(0xFFE8EAF3),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.045),

            blurRadius: 18,

            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF06B6D4),
                  Color(0xFF3B82F6),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(18),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6)
                      .withValues(alpha: 0.20),

                  blurRadius: 12,

                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: const Icon(
              Icons.sort_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Bubble Sort',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Pelajari proses pengurutan data dari awal sampai selesai melalui flowchart.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
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
  // FLOWCHART CARD
  // ============================================================

  Widget _buildFlowchartCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(13),
                    ),

                    child: const Icon(
                      Icons.account_tree_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alur Flowchart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w900,
                            color:
                                Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Ikuti alur proses Bubble Sort',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),

                    child: Text(
                      '${_currentStep + 1}/${_nodes.length}',
                      style: const TextStyle(
                        color:
                            Color(0xFF7C3AED),
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              padding:
                  const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 8,
              ),

              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(0xFFF8FAFF),
                    Color(0xFFF9F5FF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),

                borderRadius:
                    BorderRadius.circular(20),

                border: Border.all(
                  color:
                      const Color(0xFFEDE9FE),
                ),
              ),

              child: SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,

                physics:
                    const BouncingScrollPhysics(),

                child: SizedBox(
                  width: 390,

                  child: Column(
                    children: [
                      FlowNode(
                        node: _nodes[0],
                      ),

                      const FlowArrow(),

                      FlowNode(
                        node: _nodes[1],
                      ),

                      const FlowArrow(),

                      FlowNode(
                        node: _nodes[2],
                      ),

                      const FlowArrow(
                        showBranch: true,
                        leftLabel: 'Ya',
                        rightLabel: 'Tidak',
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Column(
                            children: [
                              FlowNode(
                                node: _nodes[3],
                              ),

                              const FlowArrow(),

                              FlowNode(
                                node: _nodes[4],
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              const SizedBox(
                                height: 45,
                              ),

                              Container(
                                width: 120,

                                padding:
                                    const EdgeInsets
                                        .all(12),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFF1F5F9,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(14),

                                  border:
                                      Border.all(
                                    color:
                                        const Color(
                                      0xFFCBD5E1,
                                    ),
                                  ),
                                ),

                                child:
                                    const Column(
                                  children: [
                                    Icon(
                                      Icons
                                          .loop_rounded,
                                      color:
                                          Color(
                                        0xFF64748B,
                                      ),
                                      size: 22,
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      'Lanjut Iterasi',
                                      textAlign:
                                          TextAlign
                                              .center,
                                      style:
                                          TextStyle(
                                        color:
                                            Color(
                                          0xFF475569,
                                        ),
                                        fontSize: 10,
                                        fontWeight:
                                            FontWeight
                                                .w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const FlowArrow(),

                      FlowNode(
                        node: _nodes[5],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color:
                        Colors.grey.shade500,
                    size: 17,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      'Gunakan tombol kontrol di bawah untuk menjalankan simulasi.',
                      style: TextStyle(
                        color:
                            Colors.grey.shade500,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CURRENT STEP
  // ============================================================

  Widget _buildCurrentStepCard() {
    final color = _currentNode.color;

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 300),

      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        18,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.10),
            Colors.white,
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color:
              color.withValues(alpha: 0.18),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,

                decoration: BoxDecoration(
                  color:
                      color.withValues(
                    alpha: 0.13,
                  ),

                  borderRadius:
                      BorderRadius.circular(13),
                ),

                child: Icon(
                  _iconForNode(
                    _currentNode.type,
                  ),
                  color: color,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Langkah ${_currentStep + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _currentNode.title
                          .replaceAll('\n', ' '),
                      style: const TextStyle(
                        color:
                            Color(0xFF1F2937),
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              if (_isPlaying)
                _buildPlayingBadge(),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(16),

              border: Border.all(
                color:
                    const Color(0xFFE5E7EB),
              ),
            ),

            child: Text(
              _currentNode.description,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PLAYING BADGE
  // ============================================================

  Widget _buildPlayingBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),

        borderRadius:
            BorderRadius.circular(10),
      ),

      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.equalizer_rounded,
            color: Color(0xFF10B981),
            size: 15,
          ),

          SizedBox(width: 4),

          Text(
            'PLAY',
            style: TextStyle(
              color: Color(0xFF059669),
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgressCard(
    double progress,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        18,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.045),

            blurRadius: 17,

            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Progress Simulasi',
                  style: TextStyle(
                    color:
                        Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),

              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color:
                      Color(0xFF6366F1),
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),

            child:
                LinearProgressIndicator(
              value: progress,

              minHeight: 11,

              backgroundColor:
                  const Color(0xFFEDE9FE),

              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                Color(0xFF7C3AED),
              ),
            ),
          ),

          const SizedBox(height: 9),

          Text(
            _currentStep ==
                    _nodes.length - 1
                ? 'Simulasi selesai 🎉'
                : 'Lanjutkan langkah berikutnya untuk memahami algoritma.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTROL CARD
  // ============================================================

  Widget _buildControlCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        0,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF8FAFF),
          ],
        ),

        borderRadius:
            BorderRadius.circular(26),

        border: Border.all(
          color:
              const Color(0xFFE5E7EB),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),

            blurRadius: 18,

            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ControlButton(
                  label: 'Prev',
                  icon:
                      Icons.skip_previous_rounded,
                  color:
                      const Color(0xFF3B82F6),
                  enabled:
                      _currentStep > 0,
                  onPressed:
                      _previousStep,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: _ControlButton(
                  label: _isPlaying
                      ? 'Pause'
                      : 'Play',

                  icon: _isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,

                  color: _isPlaying
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981),

                  enabled: true,

                  onPressed: _isPlaying
                      ? _pauseSimulation
                      : _playSimulation,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: _ControlButton(
                  label: 'Next',
                  icon:
                      Icons.skip_next_rounded,
                  color:
                      const Color(0xFF8B5CF6),
                  enabled:
                      _currentStep <
                          _nodes.length - 1,
                  onPressed:
                      _nextStep,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          SizedBox(
            width: double.infinity,

            child: OutlinedButton.icon(
              onPressed:
                  _resetSimulation,

              style:
                  OutlinedButton.styleFrom(
                minimumSize:
                    const Size.fromHeight(48),

                side: const BorderSide(
                  color: Color(0xFFF43F5E),
                  width: 1.2,
                ),

                foregroundColor:
                    const Color(0xFFE11D48),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),

              icon: const Icon(
                Icons.restart_alt_rounded,
                size: 20,
              ),

              label: const Text(
                'Reset Simulasi',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Container(
            padding:
                const EdgeInsets.all(15),

            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFFF0F9FF),
                  Color(0xFFF5F3FF),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(18),

              border: Border.all(
                color:
                    const Color(0xFFE0E7FF),
              ),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFF6366F1,
                        ).withValues(
                          alpha: 0.10,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          11,
                        ),
                      ),

                      child: const Icon(
                        Icons.speed_rounded,
                        color:
                            Color(0xFF6366F1),
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 11),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kecepatan Simulasi',
                            style: TextStyle(
                              color:
                                  Color(
                                0xFF1F2937,
                              ),
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Atur kecepatan perpindahan langkah',
                            style: TextStyle(
                              color:
                                  Color(
                                0xFF6B7280,
                              ),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),

                      child: Text(
                        '${_speed.toStringAsFixed(1)}x',
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF6366F1),
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),

                SliderTheme(
                  data:
                      SliderTheme.of(context)
                          .copyWith(
                    activeTrackColor:
                        const Color(
                      0xFF6366F1,
                    ),

                    inactiveTrackColor:
                        const Color(
                      0xFFE0E7FF,
                    ),

                    thumbColor:
                        const Color(
                      0xFF7C3AED,
                    ),

                    overlayColor:
                        const Color(
                      0xFF6366F1,
                    ).withValues(
                      alpha: 0.12,
                    ),

                    trackHeight: 6,

                    thumbShape:
                        const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),

                  child: Slider(
                    value: _speed,
                    min: 0.5,
                    max: 3.0,
                    divisions: 5,
                    onChanged:
                        _changeSpeed,
                  ),
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: const [
                    Text(
                      '0.5x',
                      style: TextStyle(
                        color:
                            Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    Text(
                      '1x',
                      style: TextStyle(
                        color:
                            Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    Text(
                      '2x',
                      style: TextStyle(
                        color:
                            Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    Text(
                      '3x',
                      style: TextStyle(
                        color:
                            Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NODE ICON
  // ============================================================

  IconData _iconForNode(
    FlowNodeType type,
  ) {
    switch (type) {
      case FlowNodeType.start:
        return Icons.play_circle_fill_rounded;

      case FlowNodeType.input:
        return Icons.input_rounded;

      case FlowNodeType.decision:
        return Icons.help_center_rounded;

      case FlowNodeType.process:
        return Icons.swap_horiz_rounded;

      case FlowNodeType.output:
        return Icons.output_rounded;

      case FlowNodeType.end:
        return Icons.flag_rounded;
    }
  }
}

// ================================================================
// CONTROL BUTTON
// ================================================================

class _ControlButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration:
          const Duration(milliseconds: 200),

      opacity: enabled ? 1 : 0.40,

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: enabled
              ? onPressed
              : null,

          borderRadius:
              BorderRadius.circular(15),

          child: Ink(
            height: 52,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(
                    alpha: 0.78,
                  ),
                ],

                begin:
                    Alignment.topLeft,

                end:
                    Alignment.bottomRight,
              ),

              borderRadius:
                  BorderRadius.circular(15),

              boxShadow: [
                BoxShadow(
                  color: color.withValues(
                    alpha: 0.18,
                  ),

                  blurRadius: 10,

                  offset:
                      const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
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