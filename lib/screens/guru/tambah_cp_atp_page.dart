import 'package:flutter/material.dart';
import '../../services/cp_atp_service.dart';

class TambahCPATPPage extends StatefulWidget {
  const TambahCPATPPage({super.key});

  @override
  State<TambahCPATPPage> createState() =>
      _TambahCPATPPageState();
}

class _TambahCPATPPageState
    extends State<TambahCPATPPage> {

  final judulController =
      TextEditingController();

  final isiController =
      TextEditingController();

  String kategori = "CP";

  bool isLoading = false;

  Future<void> simpan() async {

    if (judulController.text.isEmpty ||
        isiController.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await CPATPService().tambahData(
      judul: judulController.text,
      kategori: kategori,
      isi: isiController.text,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah CP & ATP",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller:
                  judulController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Judul",
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            DropdownButtonFormField(
              value: kategori,
              items: const [
                DropdownMenuItem(
                  value: "CP",
                  child: Text("CP"),
                ),
                DropdownMenuItem(
                  value: "ATP",
                  child: Text("ATP"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  kategori =
                      value!;
                });
              },
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller:
                  isiController,
              maxLines: 6,
              decoration:
                  const InputDecoration(
                labelText:
                    "Isi",
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : simpan,
                child: const Text(
                  "Simpan",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}