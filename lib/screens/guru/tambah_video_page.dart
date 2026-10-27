import 'package:flutter/material.dart';

import '../../services/video_service.dart';

class TambahVideoPage extends StatefulWidget {
  const TambahVideoPage({super.key});

  @override
  State<TambahVideoPage> createState() =>
      _TambahVideoPageState();
}

class _TambahVideoPageState
    extends State<TambahVideoPage> {

  final _formKey = GlobalKey<FormState>();

  final judulController =
      TextEditingController();

  final deskripsiController =
      TextEditingController();

  final linkController =
      TextEditingController();

  bool loading = false;

  Future<void> simpanVideo() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await VideoService().tambahVideo(

        judul:
            judulController.text.trim(),

        deskripsi:
            deskripsiController.text.trim(),

        link:
            linkController.text.trim(),

      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Video berhasil ditambahkan",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.toString()),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Tambah Video",
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [              TextFormField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: "Judul Video",
                  hintText: "Contoh: Percabangan IF ELSE",
                  prefixIcon: const Icon(
                    Icons.video_library_rounded,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Judul video tidak boleh kosong";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: deskripsiController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  hintText:
                      "Masukkan deskripsi video...",
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Deskripsi tidak boleh kosong";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: linkController,
                decoration: InputDecoration(
                  labelText: "Link Video",
                  hintText:
                      "https://youtu.be/xxxxx",
                  prefixIcon: const Icon(
                    Icons.link_rounded,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Link video tidak boleh kosong";
                  }

                  if (!value.startsWith("http")) {
                    return "Masukkan link yang valid";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                  onPressed:
                      loading ? null : simpanVideo,

                  icon: loading
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
                          Icons.save_rounded,
                        ),

                  label: Text(
                    loading
                        ? "Menyimpan..."
                        : "Simpan Video",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),            ],
          ),
        ),
      ),
    );
  }
}