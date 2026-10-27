import '../models/algorithm_type.dart';
import '../models/simulation_step.dart';

class AlgorithmService {
  static const List<int> _defaultData = [
    5,
    3,
    8,
    2,
    1,
  ];

  static List<SimulationStep> generate(
    AlgorithmType algorithm, {
    List<int>? customData,
  }) {
    final data = customData ?? _defaultData;

    switch (algorithm) {
      case AlgorithmType.bubble:
        return _bubbleSort(data);

      case AlgorithmType.selection:
        return _selectionSort(data);

      case AlgorithmType.linear:
        return _linearSearch(data);

      case AlgorithmType.binary:
        return _binarySearch(data);

      case AlgorithmType.flowchart:
        return _flowchart();
    }
  }

  //=========================================================
  // BUBBLE SORT
  //=========================================================

  static List<SimulationStep> _bubbleSort(
    List<int> source,
  ) {
    final List<int> data = List.from(source);

    final List<SimulationStep> steps = [];

    int comparison = 0;
    int swap = 0;

    steps.add(
      SimulationStep(
        data: List.from(data),
        description: "Data awal Bubble Sort",
        comparison: comparison,
        swap: swap,
      ),
    );

    for (int i = 0; i < data.length - 1; i++) {
      for (int j = 0; j < data.length - i - 1; j++) {

        comparison++;

        int left = data[j];
        int right = data[j + 1];

        bool isSwap = left > right;

        if (isSwap) {
          data[j] = right;
          data[j + 1] = left;
          swap++;
        }

        steps.add(
          SimulationStep(
            data: List.from(data),

            firstIndex: j,

            secondIndex: j + 1,

            swapped: isSwap,

            comparison: comparison,

            swap: swap,

            description: isSwap
                ? "Membandingkan $left dengan $right, kemudian ditukar karena $left lebih besar dari $right."
                : "Membandingkan $left dengan $right, tidak perlu ditukar.",
          ),
        );
      }
    }

    steps.add(
      SimulationStep(
        data: List.from(data),
        comparison: comparison,
        swap: swap,
        description: "Bubble Sort selesai.",
      ),
    );

    return steps;
  }
    //=========================================================
  // SELECTION SORT
  //=========================================================

  static List<SimulationStep> _selectionSort(
    List<int> source,
  ) {
    final List<int> data = List.from(source);

    final List<SimulationStep> steps = [];

    int comparison = 0;
    int swap = 0;

    steps.add(
      SimulationStep(
        data: List.from(data),
        description: "Data awal Selection Sort",
        comparison: comparison,
        swap: swap,
      ),
    );

    for (int i = 0; i < data.length - 1; i++) {
      int minIndex = i;

      for (int j = i + 1; j < data.length; j++) {
        comparison++;

        steps.add(
          SimulationStep(
            data: List.from(data),
            firstIndex: minIndex,
            secondIndex: j,
            comparison: comparison,
            swap: swap,
            description:
                "Membandingkan ${data[minIndex]} dengan ${data[j]}.",
          ),
        );

        if (data[j] < data[minIndex]) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        int oldValue = data[i];
        int minValue = data[minIndex];

        data[i] = minValue;
        data[minIndex] = oldValue;

        swap++;

        steps.add(
          SimulationStep(
            data: List.from(data),
            firstIndex: i,
            secondIndex: minIndex,
            swapped: true,
            comparison: comparison,
            swap: swap,
            description:
                "Menukar $oldValue dengan $minValue karena $minValue adalah nilai terkecil.",
          ),
        );
      }
    }

    steps.add(
      SimulationStep(
        data: List.from(data),
        comparison: comparison,
        swap: swap,
        description: "Selection Sort selesai.",
      ),
    );

    return steps;
  }
    //=========================================================
  // LINEAR SEARCH
  //=========================================================

  static List<SimulationStep> _linearSearch(
    List<int> source,
  ) {
    const int target = 8;

    final List<int> data = List.from(source);

    final List<SimulationStep> steps = [];

    int comparison = 0;

    steps.add(
      SimulationStep(
        data: List.from(data),
        description: "Data awal Linear Search",
        comparison: comparison,
        swap: 0,
      ),
    );

    for (int i = 0; i < data.length; i++) {
      comparison++;

      bool found = data[i] == target;

      steps.add(
        SimulationStep(
          data: List.from(data),
          firstIndex: i,
          comparison: comparison,
          swap: 0,
          description: found
              ? "Data $target ditemukan pada indeks ke-$i."
              : "Membandingkan $target dengan ${data[i]}.",
        ),
      );

      if (found) {
        break;
      }
    }

    if (!data.contains(target)) {
      steps.add(
        SimulationStep(
          data: List.from(data),
          comparison: comparison,
          swap: 0,
          description: "Data $target tidak ditemukan.",
        ),
      );
    }

    return steps;
  }

  //=========================================================
  // BINARY SEARCH
  //=========================================================

  static List<SimulationStep> _binarySearch(
    List<int> source,
  ) {
    const int target = 8;

    final List<int> data = List.from(source)..sort();

    final List<SimulationStep> steps = [];

    int comparison = 0;

    int left = 0;
    int right = data.length - 1;

    steps.add(
      SimulationStep(
        data: List.from(data),
        description: "Data diurutkan terlebih dahulu sebelum Binary Search.",
        comparison: comparison,
        swap: 0,
      ),
    );

    while (left <= right) {
      int middle = (left + right) ~/ 2;

      comparison++;

      bool found = data[middle] == target;

      steps.add(
        SimulationStep(
          data: List.from(data),
          firstIndex: middle,
          comparison: comparison,
          swap: 0,
          description: found
              ? "Data $target ditemukan pada indeks ke-$middle."
              : "Mengecek nilai tengah ${data[middle]}.",
        ),
      );

      if (found) {
        break;
      }

      if (data[middle] < target) {
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }

    if (!data.contains(target)) {
      steps.add(
        SimulationStep(
          data: List.from(data),
          comparison: comparison,
          swap: 0,
          description: "Data $target tidak ditemukan.",
        ),
      );
    }

    return steps;
  }
    //=========================================================
  // FLOWCHART
  //=========================================================

  static List<SimulationStep> _flowchart() {
    return [
      const SimulationStep(
        data: [],
        description: "START",
        comparison: 0,
        swap: 0,
      ),

      const SimulationStep(
        data: [],
        description: "Input Data",
        comparison: 0,
        swap: 0,
      ),

      const SimulationStep(
        data: [],
        description: "Proses Algoritma",
        comparison: 0,
        swap: 0,
      ),

      const SimulationStep(
        data: [],
        description: "Output Hasil",
        comparison: 0,
        swap: 0,
      ),

      const SimulationStep(
        data: [],
        description: "END",
        comparison: 0,
        swap: 0,
      ),
    ];
  }

  //=========================================================
  // COMPLEXITY
  //=========================================================

  static String timeComplexity(
    AlgorithmType algorithm,
  ) {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return "O(n²)";

      case AlgorithmType.selection:
        return "O(n²)";

      case AlgorithmType.linear:
        return "O(n)";

      case AlgorithmType.binary:
        return "O(log n)";

      case AlgorithmType.flowchart:
        return "-";
    }
  }

  static String spaceComplexity(
    AlgorithmType algorithm,
  ) {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return "O(1)";

      case AlgorithmType.selection:
        return "O(1)";

      case AlgorithmType.linear:
        return "O(1)";

      case AlgorithmType.binary:
        return "O(1)";

      case AlgorithmType.flowchart:
        return "-";
    }
  }

  static String algorithmDescription(
    AlgorithmType algorithm,
  ) {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return "Bubble Sort mengurutkan data dengan membandingkan dua elemen yang bersebelahan kemudian menukarnya apabila urutannya salah.";

      case AlgorithmType.selection:
        return "Selection Sort mencari nilai terkecil pada bagian data yang belum terurut kemudian menempatkannya di posisi yang benar.";

      case AlgorithmType.linear:
        return "Linear Search mencari data secara berurutan mulai dari indeks pertama hingga data ditemukan.";

      case AlgorithmType.binary:
        return "Binary Search bekerja pada data yang sudah terurut dengan membagi ruang pencarian menjadi dua bagian.";

      case AlgorithmType.flowchart:
        return "Flowchart digunakan untuk menggambarkan alur logika algoritma dalam bentuk diagram.";
    }
  }

  static List<String> pseudoCode(
    AlgorithmType algorithm,
  ) {
    switch (algorithm) {
      case AlgorithmType.bubble:
        return [
          "for i = 0 sampai n-1",
          "for j = 0 sampai n-i-1",
          "if data[j] > data[j+1]",
          "swap(data[j], data[j+1])",
        ];

      case AlgorithmType.selection:
        return [
          "for i = 0 sampai n-1",
          "cari nilai minimum",
          "swap(i, minimum)",
        ];

      case AlgorithmType.linear:
        return [
          "for setiap data",
          "bandingkan dengan target",
          "jika sama maka selesai",
        ];

      case AlgorithmType.binary:
        return [
          "urutkan data",
          "ambil nilai tengah",
          "bandingkan dengan target",
          "geser left/right",
        ];

      case AlgorithmType.flowchart:
        return [
          "START",
          "INPUT",
          "PROCESS",
          "OUTPUT",
          "END",
        ];
    }
  }
}