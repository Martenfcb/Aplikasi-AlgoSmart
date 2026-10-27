import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

class BinarySearchPage extends StatefulWidget {
  const BinarySearchPage({super.key});

  @override
  State<BinarySearchPage> createState() =>
      _BinarySearchPageState();
}

class _BinarySearchPageState
    extends State<BinarySearchPage> {

  final List<int> data = [
    1,
    2,
    3,
    5,
    7,
    8,
    9,
    12,
    15,
  ];

  final int target = 8;

  int left = 0;
  int right = 8;
  int middle = -1;

  bool ditemukan = false;
  bool selesai = false;

  @override
  void initState() {
    super.initState();
    middle = (left + right) ~/ 2;
  }

  void nextStep() {

    if (selesai) return;

    setState(() {

      middle = (left + right) ~/ 2;

      if (data[middle] == target) {

        ditemukan = true;
        selesai = true;

      } else if (data[middle] < target) {

        left = middle + 1;

      } else {

        right = middle - 1;

      }

      if (left > right) {

        selesai = true;

      }

    });

  }

  void reset() {

    setState(() {

      left = 0;
      right = data.length - 1;
      middle = (left + right) ~/ 2;
      ditemukan = false;
      selesai = false;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(

        centerTitle: true,

        title: const Text(
          "Binary Search",
        ),

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(20),

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

                    "Target Pencarian",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 10),

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

                    spacing: 10,

                    runSpacing: 10,

                    children: List.generate(

                      data.length,

                      (index) {

                        Color warna = Colors.grey.shade300;
                        Color teks = Colors.black;

                        // Data di luar area pencarian
                        if (index < left || index > right) {
                          warna = Colors.grey.shade200;
                          teks = Colors.grey;
                        }

                        // Area pencarian aktif
                        if (index >= left && index <= right) {
                          warna = Colors.blue.shade300;
                          teks = Colors.white;
                        }

                        // Posisi tengah (middle)
                        if (index == middle) {
                          warna = ditemukan
                              ? Colors.green
                              : Colors.orange;

                          teks = Colors.white;
                        }

                        return AnimatedContainer(

                          duration: const Duration(
                            milliseconds: 400,
                          ),

                          width: 58,

                          height: 58,

                          decoration: BoxDecoration(

                            color: warna,

                            borderRadius:
                                BorderRadius.circular(15),

                          ),

                          child: Center(

                            child: Text(

                              data[index].toString(),

                              style: TextStyle(

                                color: teks,

                                fontWeight:
                                    FontWeight.bold,

                                fontSize: 20,

                              ),

                            ),

                          ),

                        );

                      },

                    ),

                  ),

                  const SizedBox(height: 25),

                  Text(

                    ditemukan
                        ? "🎉 Data ditemukan pada indeks $middle"
                        : selesai
                            ? "❌ Data tidak ditemukan"
                            : "Memeriksa indeks tengah ($middle)",

                    textAlign: TextAlign.center,

                    style: const TextStyle(

                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 15),

                  Text(

                    "Left : $left    |    Middle : $middle    |    Right : $right",

                    style: const TextStyle(

                      fontSize: 16,

                      color: Colors.grey,

                    ),

                  ),

                  const SizedBox(height: 25),

                  LinearProgressIndicator(

                    value: ditemukan
                        ? 1
                        : (middle + 1) / data.length,

                    minHeight: 10,

                    borderRadius:
                        BorderRadius.circular(20),

                    backgroundColor:
                        Colors.grey.shade300,

                    valueColor:
                        const AlwaysStoppedAnimation(
                      Colors.blue,
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

                    onPressed: selesai
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
                          Colors.blue,

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

                color: Colors.blue.shade50,

                borderRadius:
                    BorderRadius.circular(
                        18),

                border: Border.all(
                  color:
                      Colors.blue.shade200,
                ),

              ),

              child: Text(

  "Binary Search adalah algoritma pencarian yang bekerja pada data yang sudah terurut. "
  "Algoritma ini selalu memeriksa elemen di tengah. "
  "Jika nilai tengah lebih kecil dari target, pencarian dilanjutkan ke bagian kanan. "
  "Jika nilai tengah lebih besar dari target, pencarian dilanjutkan ke bagian kiri. "
  "Proses ini terus diulang hingga data ditemukan atau ruang pencarian habis.",

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