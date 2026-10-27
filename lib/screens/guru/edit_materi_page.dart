import 'package:flutter/material.dart';

import '../../services/materi_service.dart';

class EditMateriPage extends StatefulWidget {
  final String docId;
  final String judul;
  final String deskripsi;
  final String link;

  const EditMateriPage({
    super.key,
    required this.docId,
    required this.judul,
    required this.deskripsi,
    required this.link,
  });

  @override
  State<EditMateriPage> createState() =>
      _EditMateriPageState();
}

class _EditMateriPageState
    extends State<EditMateriPage> {

  final _formKey = GlobalKey<FormState>();

  final MateriService materiService =
      MateriService();

  late TextEditingController judulController;
  late TextEditingController deskripsiController;
  late TextEditingController linkController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    judulController =
        TextEditingController(
      text: widget.judul,
    );

    deskripsiController =
        TextEditingController(
      text: widget.deskripsi,
    );

    linkController =
        TextEditingController(
      text: widget.link,
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    linkController.dispose();
    super.dispose();
  }

  Future<void> updateMateri() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await materiService.updateMateri(
        docId: widget.docId,
        judul: judulController.text.trim(),
        deskripsi:
            deskripsiController.text.trim(),
        link: linkController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Materi berhasil diperbarui",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {

      setState(() {
        isLoading = false;
      });
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

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide:
            const BorderSide(
          color: Colors.indigo,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF4F7FC),

      appBar: AppBar(

        backgroundColor:
            Colors.indigo,

        foregroundColor:
            Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Edit Materi",
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Form(

            key: _formKey,

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(24),

                  decoration: BoxDecoration(

                    color: Colors.indigo,

                    borderRadius:
                        BorderRadius.circular(
                            22),
                  ),

                  child: const Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Icon(
                        Icons.edit_document,
                        color: Colors.white,
                        size: 45,
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Edit Materi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Perbarui informasi materi pembelajaran.",
                        style: TextStyle(
                          color:
                              Colors.white70,
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
                    icon: Icons.menu_book_rounded,
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
                      return "Masukkan link Google Drive yang valid";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.blue.shade200,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Pastikan link Google Drive masih aktif dan aksesnya diatur menjadi 'Siapa saja yang memiliki link dapat melihat'.",
                          style: TextStyle(
                            height: 1.5,
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
                    onPressed: isLoading ? null : updateMateri,
                    icon: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_as_rounded),
                    label: Text(
                      isLoading
                          ? "Menyimpan..."
                          : "Simpan Perubahan",
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