import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

class LinearSearchPage extends StatefulWidget {
  const LinearSearchPage({super.key});

  @override
  State<LinearSearchPage> createState() =>
      _LinearSearchPageState();
}

class _LinearSearchPageState
    extends State<LinearSearchPage> {

  final List<int> data = [
    5,
    3,
    8,
    2,
    1,
    7,
    9,
  ];

  final int target = 8;

  int currentIndex = -1;

  bool ditemukan = false;

  void nextStep() {

    if (ditemukan) return;

    if (currentIndex < data.length - 1) {

      setState(() {

        currentIndex++;

        if (data[currentIndex] == target) {

          ditemukan = true;

        }

      });

    }

  }

  void reset() {

    setState(() {

      currentIndex = -1;

      ditemukan = false;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      appBar: AppBar(

        title: const Text(
          "Linear Search",
        ),

        centerTitle: true,

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
                        Colors.black.withOpacity(.05),

                    blurRadius: 15,

                    offset:
                        const Offset(0,6),

                  ),

                ],

              ),

              child: Column(

                children: [

                  const Text(

                    "Cari Angka",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 12),

                  Text(

                    target.toString(),

                    style: const TextStyle(

                      fontSize: 50,

                      color: Colors.red,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 25),
                                    Wrap(

                    alignment: WrapAlignment.center,

                    spacing: 12,

                    runSpacing: 12,

                    children: List.generate(

                      data.length,

                      (index) {

                        Color warna = Colors.grey.shade300;

                        Color teks = Colors.black;

                        if (index < currentIndex) {

                          warna = Colors.red.shade300;

                          teks = Colors.white;

                        }

                        if (index == currentIndex) {

                          warna = ditemukan
                              ? Colors.green
                              : Colors.orange;

                          teks = Colors.white;

                        }

                        return AnimatedContainer(

                          duration: const Duration(
                            milliseconds: 400,
                          ),

                          width: 60,

                          height: 60,

                          decoration: BoxDecoration(

                            color: warna,

                            borderRadius:
                                BorderRadius.circular(
                                    15),

                          ),

                          child: Center(

                            child: Text(

                              data[index].toString(),

                              style: TextStyle(

                                color: teks,

                                fontSize: 22,

                                fontWeight:
                                    FontWeight.bold,

                              ),

                            ),

                          ),

                        );

                      },

                    ),

                  ),

                  const SizedBox(height: 30),

                  Text(

                    currentIndex == -1
                        ? "Tekan tombol 'Langkah Berikutnya' untuk memulai pencarian."
                        : ditemukan
                            ? "🎉 Angka $target ditemukan pada indeks $currentIndex."
                            : "Memeriksa indeks $currentIndex...",

                    textAlign: TextAlign.center,

                    style: const TextStyle(

                      fontSize: 17,

                      fontWeight: FontWeight.w500,

                    ),

                  ),

                  const SizedBox(height: 20),

                  LinearProgressIndicator(

                    value: (currentIndex + 1) / data.length,

                    minHeight: 10,

                    borderRadius:
                        BorderRadius.circular(20),

                    backgroundColor:
                        Colors.grey.shade300,

                    valueColor:
                        const AlwaysStoppedAnimation(
                      Colors.deepPurple,
                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(height: 30),
                        Row(

              children: [

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed:
                        currentIndex >= data.length - 1 ||
                                ditemukan
                            ? null
                            : nextStep,

                    icon: const Icon(
                      Icons.play_arrow,
                    ),

                    label: const Text(
                      "Langkah Berikutnya",
                    ),

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.deepPurple,

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

                const SizedBox(width: 15),

                Expanded(

                  child: ElevatedButton.icon(

                    onPressed: reset,

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

              ],

            ),

            const SizedBox(height: 30),

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.deepPurple.shade50,

                borderRadius:
                    BorderRadius.circular(
                        18),

                border: Border.all(
                  color:
                      Colors.deepPurple.shade200,
                ),

              ),

                            child: Text(

                "Linear Search adalah algoritma pencarian yang bekerja dengan memeriksa setiap elemen dalam sebuah daftar secara berurutan mulai dari indeks pertama hingga elemen yang dicari ditemukan atau seluruh data telah diperiksa. Algoritma ini sederhana dan mudah dipahami, namun kurang efisien untuk data yang berukuran besar.",

                style: TextStyle(

                  fontSize: 15,

                  height: 1.6,

                  color: Colors.deepPurple.shade900,

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