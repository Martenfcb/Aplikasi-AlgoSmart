import 'package:flutter/material.dart';

import '../../models/soal_model.dart';
import '../../services/quiz_service.dart';

class EditQuizPage extends StatefulWidget {
  final String quizId;

  const EditQuizPage({
    super.key,
    required this.quizId,
  });

  @override
  State<EditQuizPage> createState() =>
      _EditQuizPageState();
}

class _EditQuizPageState
    extends State<EditQuizPage> {

  final GlobalKey<FormState>
      _formKey =
      GlobalKey<FormState>();

  final QuizService _service =
      QuizService();

  final TextEditingController
      judulController =
      TextEditingController();

  final TextEditingController
      deskripsiController =
      TextEditingController();

  final TextEditingController
      durasiController =
      TextEditingController();

  bool loading = true;

  bool saving = false;

  final List<Map<String, dynamic>>
      daftarSoal = [];

  @override
  void initState() {
    super.initState();

    loadQuiz();
  }
Future<void> loadQuiz() async {

  setState(() {

    loading = true;

  });

  try {

    final quiz =
        await _service.detailQuiz(widget.quizId);

    final data = quiz.data();

    if (data == null) {

      throw Exception("Quiz tidak ditemukan.");

    }

    judulController.text =
        data["judul"] ?? "";

    deskripsiController.text =
        data["deskripsi"] ?? "";

    durasiController.text =
        (data["durasi"] ?? 30).toString();

    final soal =
        await _service.getSoal(widget.quizId);

    daftarSoal.clear();

    for (final item in soal) {

      daftarSoal.add({

        "pertanyaan":
            TextEditingController(
          text: item.pertanyaan,
        ),

        "pilihanA":
            TextEditingController(
          text: item.pilihanA,
        ),

        "pilihanB":
            TextEditingController(
          text: item.pilihanB,
        ),

        "pilihanC":
            TextEditingController(
          text: item.pilihanC,
        ),

        "pilihanD":
            TextEditingController(
          text: item.pilihanD,
        ),

        "jawaban":
            item.jawaban,

      });

    }

    if (mounted) {

      setState(() {});

    }

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          e.toString(),
        ),

      ),

    );

  } finally {

    if (mounted) {

      setState(() {

        loading = false;

      });

    }

  }

}
///======================================
/// TAMBAH SOAL
///======================================

void tambahSoal() {

  if (daftarSoal.length >= 50) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(
          "Maksimal 50 soal",
        ),

      ),

    );

    return;

  }

  setState(() {

    daftarSoal.add({

      "pertanyaan":
          TextEditingController(),

      "pilihanA":
          TextEditingController(),

      "pilihanB":
          TextEditingController(),

      "pilihanC":
          TextEditingController(),

      "pilihanD":
          TextEditingController(),

      "jawaban": "A",

    });

  });

}

///======================================
/// HAPUS SOAL
///======================================

void hapusSoal(int index) {

  if (daftarSoal.length == 1) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(
          "Minimal harus ada 1 soal",
        ),

      ),

    );

    return;

  }

  setState(() {

    final soal = daftarSoal[index];

    (soal["pertanyaan"] as TextEditingController)
        .dispose();

    (soal["pilihanA"] as TextEditingController)
        .dispose();

    (soal["pilihanB"] as TextEditingController)
        .dispose();

    (soal["pilihanC"] as TextEditingController)
        .dispose();

    (soal["pilihanD"] as TextEditingController)
        .dispose();

    daftarSoal.removeAt(index);

  });

}

///======================================
/// SIMPAN PERUBAHAN
///======================================

Future<void> simpanPerubahan() async {

  if (!_formKey.currentState!.validate()) {
    return;
  }

 for (int i = 0; i < daftarSoal.length; i++) {

  final item = daftarSoal[i];

  if ((item["pertanyaan"] as TextEditingController)
      .text
      .trim()
      .isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          "Pertanyaan nomor ${i + 1} masih kosong.",
        ),

      ),

    );

    return;

  }

  if ((item["pilihanA"] as TextEditingController)
          .text
          .trim()
          .isEmpty ||

      (item["pilihanB"] as TextEditingController)
          .text
          .trim()
          .isEmpty ||

      (item["pilihanC"] as TextEditingController)
          .text
          .trim()
          .isEmpty ||

      (item["pilihanD"] as TextEditingController)
          .text
          .trim()
          .isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          "Pilihan jawaban soal ${i + 1} belum lengkap.",
        ),

      ),

    );

    return;

  }

} 

  setState(() {
    saving = true;
  });

  try {

    final List<SoalModel> soal = [];

    for (final item in daftarSoal) {

      soal.add(

        SoalModel(

          pertanyaan:
              (item["pertanyaan"] as TextEditingController)
                  .text
                  .trim(),

          pilihanA:
              (item["pilihanA"] as TextEditingController)
                  .text
                  .trim(),

          pilihanB:
              (item["pilihanB"] as TextEditingController)
                  .text
                  .trim(),

          pilihanC:
              (item["pilihanC"] as TextEditingController)
                  .text
                  .trim(),

          pilihanD:
              (item["pilihanD"] as TextEditingController)
                  .text
                  .trim(),

          jawaban:
              item["jawaban"],

        ),

      );

    }

    await _service.updateQuiz(

      quizId: widget.quizId,

      judul:
          judulController.text.trim(),

      deskripsi:
          deskripsiController.text.trim(),

      durasi:
          int.tryParse(
                durasiController.text,
              ) ??
              30,

      soal: soal,

    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        backgroundColor: Colors.green,

        content: Text(
          "Quiz berhasil diperbarui.",
        ),

      ),

    );

    Navigator.pop(context);

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(e.toString()),
      ),

    );

  } finally {

    if (mounted) {

      setState(() {

        saving = false;

      });

    }

  }

}

///======================================
/// KONFIRMASI KELUAR
///======================================

Future<bool> konfirmasiKeluar() async {

  if (judulController.text.trim().isEmpty &&
      deskripsiController.text.trim().isEmpty &&
      daftarSoal.isEmpty) {

    return true;

  }

  final hasil = await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: const Text(
          "Batalkan Perubahan?",
        ),

        content: const Text(

          "Semua perubahan yang belum disimpan akan hilang. Yakin ingin keluar?",

        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
                false,
              );

            },

            child: const Text(
              "Tidak",
            ),

          ),

          ElevatedButton(

            onPressed: () {

              Navigator.pop(
                context,
                true,
              );

            },

            child: const Text(
              "Ya",
            ),

          ),

        ],

      );

    },

  );

  return hasil ?? false;

}
///======================================
/// BUILD
///======================================

@override
Widget build(BuildContext context) {

  if (loading) {

    return const Scaffold(

      body: Center(

        child: CircularProgressIndicator(),

      ),

    );

  }

  return PopScope(

    canPop: false,

    onPopInvokedWithResult:
        (didPop, result) async {

      if (didPop) return;

      final keluar =
          await konfirmasiKeluar();

      if (keluar && mounted) {

        Navigator.pop(context);

      }

    },

    child: Scaffold(

      appBar: AppBar(

        title: const Text(
          "Edit Quiz",
        ),

        centerTitle: true,

      ),

      body: SafeArea(

        child: Form(

          key: _formKey,

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [ const Text(

  "Informasi Quiz",

  style: TextStyle(

    fontSize: 22,

    fontWeight:
        FontWeight.bold,

  ),

),

const SizedBox(height: 20),

TextFormField(

  controller: judulController,

  decoration: InputDecoration(

    labelText: "Judul Quiz",

    hintText:
        "Contoh : Bubble Sort",

    prefixIcon:
        const Icon(Icons.quiz),

    border: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(18),

    ),

  ),

  validator: (value) {

    if (value == null ||
        value.trim().isEmpty) {

      return
          "Judul Quiz wajib diisi";

    }

    return null;

  },

),

const SizedBox(height: 18),

TextFormField(

  controller:
      deskripsiController,

  maxLines: 3,

  decoration: InputDecoration(

    labelText: "Deskripsi",

    hintText:
        "Masukkan deskripsi quiz",

    prefixIcon:
        const Padding(

      padding:
          EdgeInsets.only(
        bottom: 55,
      ),

      child: Icon(
        Icons.description,
      ),

    ),

    border: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(18),

    ),

  ),

  validator: (value) {

    if (value == null ||
        value.trim().isEmpty) {

      return
          "Deskripsi wajib diisi";

    }

    return null;

  },

),

const SizedBox(height: 18),

TextFormField(

  controller:
      durasiController,

  keyboardType:
      TextInputType.number,

  decoration: InputDecoration(

    labelText:
        "Durasi (Menit)",

    hintText: "30",

    prefixIcon:
        const Icon(
      Icons.timer,
    ),

    border: OutlineInputBorder(

      borderRadius:
          BorderRadius.circular(18),

    ),

  ),

  validator: (value) {

    if (value == null ||
        value.trim().isEmpty) {

      return
          "Durasi wajib diisi";

    }

    return null;

  },

),

const SizedBox(height: 30),

Row(

  children: [

    const Icon(

      Icons.list_alt,

      color: Colors.blue,

    ),

    const SizedBox(width: 10),

    Text(

      "Daftar Soal (${daftarSoal.length}/50)",

      style: const TextStyle(

        fontSize: 20,

        fontWeight:
            FontWeight.bold,

      ),

    ),

  ],

),

const SizedBox(height: 20),

ListView.builder(

  shrinkWrap: true,

  physics:
      const NeverScrollableScrollPhysics(),

  itemCount: daftarSoal.length,

  itemBuilder: (context, index) {

    return Card(

      elevation: 3,

      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),

      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
          18,
        ),

      ),

      child: Padding(

        padding:
            const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                Text(

                  "Soal ${index + 1}",

                  style:
                      const TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),

                const Spacer(),

                if (daftarSoal.length > 1)

                  IconButton(

                    onPressed: () {

                      hapusSoal(index);

                    },

                    icon: const Icon(

                      Icons.delete,

                      color: Colors.red,

                    ),

                  ),

              ],

            ),

            const SizedBox(height: 20),

            TextFormField(

              controller:
                  daftarSoal[index]
                      ["pertanyaan"],

              maxLines: 3,

              decoration:
                  InputDecoration(

                labelText:
                    "Pertanyaan",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                ),

              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return
                      "Pertanyaan wajib diisi";

                }

                return null;

              },

            ),

            const SizedBox(height: 15),

            TextFormField(

              controller:
                  daftarSoal[index]
                      ["pilihanA"],

              decoration:
                  InputDecoration(

                labelText:
                    "Pilihan A",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                ),

              ),

            ),

            const SizedBox(height: 15),

            TextFormField(

              controller:
                  daftarSoal[index]
                      ["pilihanB"],

              decoration:
                  InputDecoration(

                labelText:
                    "Pilihan B",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                ),

              ),

            ),

            const SizedBox(height: 15),

            TextFormField(

              controller:
                  daftarSoal[index]
                      ["pilihanC"],

              decoration:
                  InputDecoration(

                labelText:
                    "Pilihan C",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                ),

              ),

            ),

            const SizedBox(height: 15),

            TextFormField(

              controller:
                  daftarSoal[index]
                      ["pilihanD"],

              decoration:
                  InputDecoration(

                labelText:
                    "Pilihan D",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                ),

              ),

            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(

              value:
                  daftarSoal[index]
                      ["jawaban"],

              decoration:
                  InputDecoration(

                labelText:
                    "Jawaban Benar",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                ),

              ),

              items: const [

                DropdownMenuItem(

                  value: "A",

                  child: Text(
                    "Pilihan A",
                  ),

                ),

                DropdownMenuItem(

                  value: "B",

                  child: Text(
                    "Pilihan B",
                  ),

                ),

                DropdownMenuItem(

                  value: "C",

                  child: Text(
                    "Pilihan C",
                  ),

                ),

                DropdownMenuItem(

                  value: "D",

                  child: Text(
                    "Pilihan D",
                  ),

                ),

              ],

              onChanged: (value) {

                if (value == null)
                  return;

                setState(() {

                  daftarSoal[index]
                      ["jawaban"] = value;

                });

              },

            ),

            const SizedBox(height: 20),

          ],

        ),

      ),

    );

  },

),
const SizedBox(height: 25),

SizedBox(

  width: double.infinity,

  height: 55,

  child: OutlinedButton.icon(

    onPressed:
        daftarSoal.length >= 50
            ? null
            : tambahSoal,

    icon: const Icon(Icons.add),

    label: Text(

      daftarSoal.length >= 50
          ? "Maksimal 50 Soal"
          : "Tambah Soal",

    ),

    style: OutlinedButton.styleFrom(

      foregroundColor: Colors.blue,

      side: const BorderSide(
        color: Colors.blue,
      ),

      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
          15,
        ),

      ),

    ),

  ),

),

const SizedBox(height: 30),

SizedBox(

  width: double.infinity,

  height: 55,

  child: ElevatedButton.icon(

    onPressed: saving

    ? null

    : () async {

        FocusScope.of(context)
            .unfocus();

        await simpanPerubahan();

      },

   icon: saving

    ? const SizedBox(

        width: 22,

        height: 22,

        child:
            CircularProgressIndicator(

          strokeWidth: 2,

          color: Colors.white,

        ),

      )

    : const Icon(
        Icons.save,
      ),

   label: Text(

  saving

      ? "Menyimpan..."

      : "Simpan Perubahan",

),

    style: ElevatedButton.styleFrom(

      backgroundColor:
          Colors.orange,

      foregroundColor:
          Colors.white,

      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
          15,
        ),

      ),

    ),

  ),

),

const SizedBox(height: 30),
            ],

          ),

        ),

      ),

    ),

  ),

);

}

@override
void dispose() {

  judulController.dispose();

  deskripsiController.dispose();

  durasiController.dispose();

  for (final soal in daftarSoal) {

    (soal["pertanyaan"] as TextEditingController)
        .dispose();

    (soal["pilihanA"] as TextEditingController)
        .dispose();

    (soal["pilihanB"] as TextEditingController)
        .dispose();

    (soal["pilihanC"] as TextEditingController)
        .dispose();

    (soal["pilihanD"] as TextEditingController)
        .dispose();

  }

  super.dispose();

}
}