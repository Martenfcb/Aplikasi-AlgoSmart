import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

class BubbleSortPage extends StatefulWidget {
  const BubbleSortPage({super.key});

  @override
  State<BubbleSortPage> createState() =>
      _BubbleSortPageState();
}

class _BubbleSortPageState
    extends State<BubbleSortPage> {

  List<int> angka = [
    5,
    3,
    8,
    2,
    1,
  ];

  int langkah = 0;

  List<List<int>> proses = [];

  @override
  void initState() {
    super.initState();
    buatSimulasi();
  }

  void buatSimulasi() {

    proses.clear();

    List<int> data =
        List.from(angka);

    proses.add(List.from(data));

    for (int i = 0; i < data.length - 1; i++) {

      for (int j = 0;
          j < data.length - i - 1;
          j++) {

        if (data[j] > data[j + 1]) {

          int temp = data[j];

          data[j] = data[j + 1];

          data[j + 1] = temp;

          proses.add(List.from(data));

        }

      }

    }

  }

  void nextStep() {

    if (langkah <
        proses.length - 1) {

      setState(() {

        langkah++;

      });

    }

  }

  void previousStep() {

    if (langkah > 0) {

      setState(() {

        langkah--;

      });

    }

  }

  void resetStep() {

    setState(() {

      langkah = 0;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      appBar: AppBar(

        centerTitle: true,

        title: const Text(
          "Bubble Sort",
        ),

      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        20),

                boxShadow: [

                  BoxShadow(

                    color:
                        Colors.black.withOpacity(
                            .05),

                    blurRadius: 15,

                    offset:
                        const Offset(
                            0,
                            6),

                  ),

                ],

              ),

              child: Column(

                children: [

                  const Text(

                    "Langkah Bubble Sort",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 20),                  Wrap(

                    alignment: WrapAlignment.center,

                    spacing: 12,

                    runSpacing: 12,

                    children: proses[langkah]

                        .map(

                          (angka) => AnimatedContainer(

                            duration: const Duration(
                              milliseconds: 400,
                            ),

                            width: 60,

                            height: 60,

                            decoration: BoxDecoration(

                              color: Colors.blue,

                              borderRadius:
                                  BorderRadius.circular(
                                      15),

                            ),

                            child: Center(

                              child: Text(

                                angka.toString(),

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize: 22,

                                  fontWeight:
                                      FontWeight.bold,

                                ),

                              ),

                            ),

                          ),

                        )

                        .toList(),

                  ),

                  const SizedBox(height: 30),

                  Text(

                    "Langkah ${langkah + 1} dari ${proses.length}",

                    style: const TextStyle(

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(

                    value:
                        (langkah + 1) /
                            proses.length,

                    minHeight: 10,

                    borderRadius:
                        BorderRadius.circular(
                            20),

                    backgroundColor:
                        Colors.grey.shade300,

                  ),

                ],

              ),

            ),

            const SizedBox(height: 30),            Row(

              children: [

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed:
                        langkah == 0
                            ? null
                            : previousStep,

                    icon: const Icon(
                      Icons.arrow_back,
                    ),

                    label: const Text(
                      "Sebelumnya",
                    ),

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.orange,

                      foregroundColor:
                          Colors.white,

                      minimumSize:
                          const Size(0, 50),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                                15),

                      ),

                    ),

                  ),

                ),

                const SizedBox(width: 12),

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed: resetStep,

                    icon: const Icon(
                      Icons.refresh,
                    ),

                    label: const Text(
                      "Reset",
                    ),

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.red,

                      foregroundColor:
                          Colors.white,

                      minimumSize:
                          const Size(0, 50),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                                15),

                      ),

                    ),

                  ),

                ),

                const SizedBox(width: 12),

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed:
                        langkah ==
                                proses.length - 1
                            ? null
                            : nextStep,

                    icon: const Icon(
                      Icons.arrow_forward,
                    ),

                    label: const Text(
                      "Selanjutnya",
                    ),

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.green,

                      foregroundColor:
                          Colors.white,

                      minimumSize:
                          const Size(0, 50),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                                15),

                      ),

                    ),

                  ),

                ),

              ],

            ),

            const SizedBox(height: 30),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.blue.shade50,

                borderRadius:
                    BorderRadius.circular(
                        18),

                border: Border.all(
                  color: Colors.blue.shade200,
                ),

              ),

              child: Text(

  "Bubble Sort membandingkan dua angka yang berdekatan. "
  "Jika angka di sebelah kiri lebih besar daripada angka di sebelah kanan, "
  "maka kedua angka akan ditukar. "
  "Proses ini diulang sampai seluruh data tersusun dari yang terkecil ke terbesar.",

  style: TextStyle(

    fontSize: 15,

    height: 1.6,

    color: Colors.blue.shade900,

  ),

),

),

],

),

),


      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 1,
      ),
);

}

}