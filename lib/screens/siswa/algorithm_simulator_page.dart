import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/algorithm_type.dart';
import '../../models/simulation_step.dart';
import '../../services/algorithm_service.dart';
import '../../services/progress_service.dart';
import 'latihan_page.dart';
import 'widgets/siswa_bottom_navigation.dart';

class AlgorithmSimulatorPage extends StatefulWidget {
  final AlgorithmType algorithm;
  final String title;

  const AlgorithmSimulatorPage({
    super.key,
    required this.algorithm,
    required this.title,
  });

  @override
  State<AlgorithmSimulatorPage> createState() =>
      _AlgorithmSimulatorPageState();
}

class _AlgorithmSimulatorPageState
    extends State<AlgorithmSimulatorPage> {
  // ============================================================
  // DATA
  // ============================================================

  late List<SimulationStep> steps;

  late TextEditingController dataController;

  Timer? timer;

  int currentStep = 0;

  bool isPlaying = false;

  bool _simulasiSelesai = false;

  bool _sedangMenyelesaikan = false;

  double speed = 1.0;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    dataController = TextEditingController(
      text: '5,3,8,2,1',
    );

    steps = [];

    _loadSimulation();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    timer?.cancel();
    dataController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD SIMULATION
  // ============================================================

  void _loadSimulation({
    List<int>? customData,
  }) {
    timer?.cancel();

    final generatedSteps = AlgorithmService.generate(
      widget.algorithm,
      customData: customData,
    );

    if (!mounted) return;

    setState(() {
      steps = generatedSteps;
      currentStep = 0;
      isPlaying = false;
      _simulasiSelesai = false;
      _sedangMenyelesaikan = false;
    });
  }

  // ============================================================
  // GETTER
  // ============================================================

  SimulationStep get current => steps[currentStep];

  List<int> get currentData => current.data;

  int get totalStep => steps.length;

  bool get isFirstStep => currentStep <= 0;

  bool get isLastStep =>
      steps.isNotEmpty && currentStep >= steps.length - 1;

  double get progress {
    if (totalStep == 0) return 0;

    return (currentStep + 1) / totalStep;
  }

  // ============================================================
  // NEXT STEP
  // ============================================================

  void nextStep() {
    if (steps.isEmpty || _simulasiSelesai) return;

    if (isPlaying) {
      pauseSimulation();
    }

    if (isLastStep) {
      _selesaikanSimulasi();
      return;
    }

    setState(() {
      currentStep++;
    });

    if (isLastStep) {
      _selesaikanSimulasi();
    }
  }

  // ============================================================
  // PREVIOUS STEP
  // ============================================================

  void previousStep() {
    if (steps.isEmpty || isFirstStep) return;

    if (isPlaying) {
      pauseSimulation();
    }

    setState(() {
      currentStep--;
      _simulasiSelesai = false;
    });
  }

  // ============================================================
  // RESET SIMULATION
  // ============================================================

  void resetSimulation() {
    timer?.cancel();

    if (!mounted) return;

    setState(() {
      currentStep = 0;
      isPlaying = false;
      _simulasiSelesai = false;
      _sedangMenyelesaikan = false;
    });
  }

  // ============================================================
  // PLAY SIMULATION
  // ============================================================

  void playSimulation() {
    if (steps.isEmpty ||
        isPlaying ||
        _simulasiSelesai ||
        _sedangMenyelesaikan) {
      return;
    }

    if (isLastStep) {
      _selesaikanSimulasi();
      return;
    }

    timer?.cancel();

    setState(() {
      isPlaying = true;
    });

    _startTimer();
  }

  // ============================================================
  // START TIMER
  // ============================================================

  void _startTimer() {
    timer?.cancel();

    final milliseconds = max(
      100,
      (900 / speed).round(),
    );

    timer = Timer.periodic(
      Duration(milliseconds: milliseconds),
      (activeTimer) {
        if (!mounted) {
          activeTimer.cancel();
          return;
        }

        if (!isPlaying ||
            _simulasiSelesai ||
            _sedangMenyelesaikan) {
          activeTimer.cancel();
          return;
        }

        if (currentStep < totalStep - 1) {
          setState(() {
            currentStep++;
          });

          if (isLastStep) {
            activeTimer.cancel();

            setState(() {
              isPlaying = false;
            });

            _selesaikanSimulasi();
          }
        } else {
          activeTimer.cancel();

          setState(() {
            isPlaying = false;
          });

          _selesaikanSimulasi();
        }
      },
    );
  }

  // ============================================================
  // PAUSE SIMULATION
  // ============================================================

  void pauseSimulation() {
    timer?.cancel();

    if (!mounted) return;

    setState(() {
      isPlaying = false;
    });
  }

  // ============================================================
  // APPLY DATA
  // ============================================================

  void applyData() {
    if (dataController.text.trim().isEmpty) {
      _showMessage(
        'Masukkan data terlebih dahulu.',
        Colors.orange,
      );
      return;
    }

    try {
      final numbers = dataController.text
          .split(',')
          .map(
            (e) => int.parse(e.trim()),
          )
          .toList();

      if (numbers.isEmpty) {
        _showMessage(
          'Data tidak boleh kosong.',
          Colors.orange,
        );
        return;
      }

      if (numbers.length < 2) {
        _showMessage(
          'Masukkan minimal 2 angka.',
          Colors.orange,
        );
        return;
      }

      if (numbers.length > 15) {
        _showMessage(
          'Maksimal 15 angka agar simulasi tetap nyaman dilihat.',
          Colors.orange,
        );
        return;
      }

      _loadSimulation(
        customData: numbers,
      );

      _showMessage(
        'Data berhasil diterapkan.',
        Colors.green,
      );
    } catch (_) {
      _showMessage(
        'Format salah. Contoh: 5,3,8,2,1',
        Colors.red,
      );
    }
  }

  // ============================================================
  // RANDOM DATA
  // ============================================================

  void randomData() {
    final random = Random();

    final numbers = List.generate(
      6,
      (_) => random.nextInt(90) + 10,
    );

    dataController.text = numbers.join(',');

    _loadSimulation(
      customData: numbers,
    );

    _showMessage(
      'Data acak berhasil dibuat.',
      Colors.green,
    );
  }

  // ============================================================
  // COMPLETE SIMULATION
  // ============================================================

  Future<void> _selesaikanSimulasi() async {
    if (_simulasiSelesai ||
        _sedangMenyelesaikan ||
        !mounted) {
      return;
    }

    timer?.cancel();

    setState(() {
      isPlaying = false;
      _sedangMenyelesaikan = true;
      _simulasiSelesai = true;
    });

    final progressService = ProgressService();

    try {
      await progressService.selesaiSimulasi(
        widget.algorithm.name,
      );
    } catch (e) {
      debugPrint(
        'Gagal menyimpan progress simulasi: $e',
      );
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.celebration_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Simulasi Selesai!',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Kamu sudah menyelesaikan simulasi algoritma ini. '
            'Sekarang kamu bisa melanjutkan ke latihan '
            'untuk menguji pemahamanmu.',
            style: TextStyle(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Nanti',
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              icon: const Icon(
                Icons.assignment_rounded,
              ),
              label: const Text(
                'Mulai Latihan',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _sedangMenyelesaikan = false;
    });
  }

  // ============================================================
  // GO TO LATIHAN
  // ============================================================

  void _bukaLatihan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LatihanPage(),
      ),
    );
  }

  // ============================================================
  // BOX COLOR
  // ============================================================

  Color getBoxColor(int index) {
    if (index == current.firstIndex ||
        index == current.secondIndex) {
      if (current.swapped) {
        return Colors.green;
      }

      return Colors.orange;
    }

    return const Color(0xFF3B82F6);
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
    Color color,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
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
    if (steps.isEmpty) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor:
              const Color(0xFF2563EB),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 1,
      ),
);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (_simulasiSelesai)
            IconButton(
              tooltip: 'Latihan',
              onPressed: _bukaLatihan,
              icon: const Icon(
                Icons.assignment_rounded,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeroHeader(),

              const SizedBox(height: 18),

              _buildInputData(),

              const SizedBox(height: 18),

              _buildVisualization(),

              const SizedBox(height: 18),

              _buildStatistics(),

              const SizedBox(height: 18),

              _buildExplanation(),

              const SizedBox(height: 18),

              _buildPseudoCode(),

              const SizedBox(height: 18),

              _buildComplexity(),

              const SizedBox(height: 18),

              _buildControlPanel(),

              if (_simulasiSelesai) ...[
                const SizedBox(height: 18),
                _buildCompletionCard(),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO HEADER
  // ============================================================

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF4F46E5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF2563EB)
                    .withOpacity(.20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.memory_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            AlgorithmService.algorithmDescription(
              widget.algorithm,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(.88),
              fontSize: 13,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildHeroInfo(
                  'Time',
                  AlgorithmService.timeComplexity(
                    widget.algorithm,
                  ),
                  Icons.timer_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildHeroInfo(
                  'Space',
                  AlgorithmService.spaceComplexity(
                    widget.algorithm,
                  ),
                  Icons.storage_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroInfo(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(.70),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
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
  // INPUT DATA
  // ============================================================

  Widget _buildInputData() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            'Input Data Simulasi',
            Icons.numbers_rounded,
          ),

          const SizedBox(height: 14),

          TextField(
            controller: dataController,
            keyboardType:
                TextInputType.number,
            enabled: !_sedangMenyelesaikan,
            decoration: InputDecoration(
              hintText: 'Contoh: 5,3,8,2,1',
              prefixIcon: const Icon(
                Icons.numbers_rounded,
              ),
              filled: true,
              fillColor:
                  const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15),
                borderSide:
                    const BorderSide(
                  color:
                      Color(0xFF2563EB),
                  width: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      _sedangMenyelesaikan
                          ? null
                          : applyData,
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                  ),
                  label: const Text(
                    'Terapkan',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2563EB),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    minimumSize:
                        const Size.fromHeight(48),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _sedangMenyelesaikan
                          ? null
                          : randomData,
                  icon: const Icon(
                    Icons.casino_rounded,
                  ),
                  label: const Text(
                    'Random',
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(48),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VISUALIZATION
  // ============================================================

  Widget _buildVisualization() {
    return _buildCard(
      child: Column(
        children: [
          _buildSectionTitle(
            'Visualisasi Algoritma',
            Icons.bar_chart_rounded,
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              currentData.length,
              (index) {
                final active =
                    index == current.firstIndex ||
                        index == current.secondIndex;

                return AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: getBoxColor(index),
                    borderRadius:
                        BorderRadius.circular(17),
                    border: active
                        ? Border.all(
                            color: Colors.white,
                            width: 2,
                          )
                        : null,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      currentData[index].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w900,
                        fontSize: 21,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Text(
                'Langkah ${currentStep + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                'dari $totalStep',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor:
                  Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            title: 'Comparison',
            value:
                current.comparison.toString(),
            icon:
                Icons.compare_arrows_rounded,
            color: Colors.orange,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildInfoCard(
            title: 'Swap',
            value: current.swap.toString(),
            icon:
                Icons.swap_horiz_rounded,
            color: Colors.green,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildInfoCard(
            title: 'Step',
            value:
                '${currentStep + 1}/$totalStep',
            icon:
                Icons.timeline_rounded,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EXPLANATION
  // ============================================================

  Widget _buildExplanation() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            'Penjelasan Langkah',
            Icons.lightbulb_rounded,
          ),

          const SizedBox(height: 14),

          AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(currentStep),
              width: double.infinity,
              padding:
                  const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFFFFBEB),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Text(
                current.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.65,
                  color:
                      Color(0xFF4B5563),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PSEUDO CODE
  // ============================================================

  Widget _buildPseudoCode() {
    final pseudoCode =
        AlgorithmService.pseudoCode(
      widget.algorithm,
    );

    if (pseudoCode.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeIndex =
        currentStep % pseudoCode.length;

    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            'Pseudo Code',
            Icons.code_rounded,
          ),

          const SizedBox(height: 14),

          ...pseudoCode.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final line = entry.value;
              final active =
                  index == activeIndex;

              return AnimatedContainer(
                duration:
                    const Duration(milliseconds: 250),
                margin:
                    const EdgeInsets.only(
                  bottom: 7,
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFEEF2FF)
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(12),
                  border: active
                      ? Border.all(
                          color:
                              const Color(0xFFBFDBFE),
                        )
                      : null,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      active
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_right_rounded,
                      size: 18,
                      color: active
                          ? const Color(0xFF2563EB)
                          : Colors.grey,
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        line,
                        style: TextStyle(
                          fontFamily:
                              'monospace',
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: active
                              ? FontWeight.w900
                              : FontWeight.normal,
                          color: active
                              ? const Color(
                                  0xFF2563EB,
                                )
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPLEXITY
  // ============================================================

  Widget _buildComplexity() {
    return Row(
      children: [
        Expanded(
          child: _buildComplexityCard(
            title: 'Time Complexity',
            value:
                AlgorithmService.timeComplexity(
              widget.algorithm,
            ),
            icon: Icons.timer_rounded,
            color: Colors.blue,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildComplexityCard(
            title: 'Space Complexity',
            value:
                AlgorithmService.spaceComplexity(
              widget.algorithm,
            ),
            icon: Icons.storage_rounded,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildComplexityCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return _buildCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTROL PANEL
  // ============================================================

  Widget _buildControlPanel() {
    return _buildCard(
      child: Column(
        children: [
          _buildSectionTitle(
            'Kontrol Simulasi',
            Icons.tune_rounded,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      isFirstStep ||
                              _sedangMenyelesaikan
                          ? null
                          : previousStep,
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                  ),
                  label: const Text(
                    'Prev',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(50),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      _sedangMenyelesaikan
                          ? null
                          : isPlaying
                              ? pauseSimulation
                              : playSimulation,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    isPlaying
                        ? 'Pause'
                        : isLastStep
                            ? 'Selesai'
                            : 'Play',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green,
                    foregroundColor:
                        Colors.white,
                    minimumSize:
                        const Size.fromHeight(50),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      _sedangMenyelesaikan
                          ? null
                          : nextStep,
                  icon: const Icon(
                    Icons.skip_next_rounded,
                  ),
                  label: Text(
                    isLastStep
                        ? 'Selesai'
                        : 'Next',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2563EB),
                    foregroundColor:
                        Colors.white,
                    minimumSize:
                        const Size.fromHeight(50),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  _sedangMenyelesaikan
                      ? null
                      : resetSimulation,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Reset Simulasi',
              ),
              style:
                  OutlinedButton.styleFrom(
                minimumSize:
                    const Size.fromHeight(48),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                color:
                    Color(0xFF2563EB),
              ),

              const SizedBox(width: 9),

              const Text(
                'Kecepatan',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const Spacer(),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFEEF2FF),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  '${speed.toStringAsFixed(2)}x',
                  style: const TextStyle(
                    color:
                        Color(0xFF2563EB),
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          Slider(
            value: speed,
            min: 0.25,
            max: 3.0,
            divisions: 11,
            label:
                '${speed.toStringAsFixed(2)}x',
            activeColor:
                const Color(0xFF2563EB),
            onChanged:
                _sedangMenyelesaikan
                    ? null
                    : (value) {
                        final wasPlaying =
                            isPlaying;

                        if (wasPlaying) {
                          pauseSimulation();
                        }

                        setState(() {
                          speed = value;
                        });

                        if (wasPlaying) {
                          playSimulation();
                        }
                      },
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.25x',
                style: TextStyle(
                  fontSize: 10,
                  color:
                      Colors.grey.shade600,
                ),
              ),
              Text(
                '3.00x',
                style: TextStyle(
                  fontSize: 10,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPLETION CARD
  // ============================================================

  Widget _buildCompletionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFECFDF5),
            Color(0xFFF0FDF4),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xFFBBF7D0),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 45,
          ),

          const SizedBox(height: 10),

          const Text(
            'Simulasi Telah Selesai',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color:
                  Color(0xFF166534),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Kamu sudah menyelesaikan semua '
            'langkah simulasi. Lanjutkan ke '
            'latihan untuk menguji pemahaman.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color:
                  Color(0xFF166534),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _bukaLatihan,
              icon: const Icon(
                Icons.assignment_rounded,
              ),
              label: const Text(
                'Mulai Latihan',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF16A34A),
                foregroundColor:
                    Colors.white,
                elevation: 0,
                minimumSize:
                    const Size.fromHeight(48),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard({
    required Widget child,
    EdgeInsetsGeometry padding =
        const EdgeInsets.all(18),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  color.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
              color: color,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color:
                  Colors.grey.shade600,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color:
                const Color(0xFFEEF2FF),
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color:
                const Color(0xFF2563EB),
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w900,
              color:
                  Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }
}