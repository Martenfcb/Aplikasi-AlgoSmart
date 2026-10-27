class SimulationStep {
  final List<int> data;

  final int? firstIndex;

  final int? secondIndex;

  final String description;

  final bool swapped;

  final int comparison;

  final int swap;

  const SimulationStep({
    required this.data,
    this.firstIndex,
    this.secondIndex,
    required this.description,
    this.swapped = false,
    this.comparison = 0,
    this.swap = 0,
  });
}