import 'package:flutter/material.dart';

import '../../services/materi_service.dart';

class TambahMateriPage extends StatefulWidget {
  const TambahMateriPage({super.key});

  @override
  State<TambahMateriPage> createState() => _TambahMateriPageState();
}

class _TambahMateriPageState extends State<TambahMateriPage> {
  final _formKey = GlobalKey<FormState>();

  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final linkController = TextEditingController();

  bool isLoading = false;

  final MateriService _materiService = MateriService();

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    linkController.dispose();
    super.dispose();
  }

  Future<void> simpanMateri() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _materiService.tambahMateri(
        judul: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        link: linkController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Materi berhasil ditambahkan"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Terjadi kesalahan: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.indigo,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        title: const Text("Tambah Materi"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 45,
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Tambah Materi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Tambahkan materi pembelajaran menggunakan link Google Drive agar siswa dapat mengakses materi dengan mudah.",
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),                TextFormField(
                  controller: judulController,
                  decoration: inputDecoration(
                    label: "Judul Materi",
                    icon: Icons.book_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Judul materi wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: deskripsiController,
                  maxLines: 5,
                  decoration: inputDecoration(
                    label: "Deskripsi Materi",
                    icon: Icons.description_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi materi wajib diisi";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: linkController,
                  keyboardType: TextInputType.url,
                  decoration: inputDecoration(
                    label: "Link Google Drive",
                    icon: Icons.link_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Link Google Drive wajib diisi";
                    }

                    if (!value.startsWith("http")) {
                      return "Masukkan link yang valid";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.amber.shade300,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade800,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Cara mendapatkan link Google Drive:\n\n"
                          "1. Upload file ke Google Drive.\n"
                          "2. Klik Bagikan (Share).\n"
                          "3. Ubah akses menjadi 'Siapa saja yang memiliki link'.\n"
                          "4. Salin link dan tempelkan pada kolom di atas.",
                          style: TextStyle(
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : simpanMateri,
                    icon: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(
                      isLoading
                          ? "Menyimpan..."
                          : "Simpan Materi",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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
    );
  }
}