import 'package:flutter/material.dart';

class SQLSimulatorPage extends StatefulWidget {
  const SQLSimulatorPage({super.key});

  @override
  State<SQLSimulatorPage> createState() =>
      _SQLSimulatorPageState();
}

class _SQLSimulatorPageState
    extends State<SQLSimulatorPage> {

  final TextEditingController sqlController =
      TextEditingController();

  String hasil = '';

  void jalankanSQL() {

    String query =
        sqlController.text
            .trim()
            .toLowerCase();

    if (query ==
        "select * from siswa;") {

      setState(() {
        hasil =
            '''
id | nama | kelas
--------------------
1 | Andi | X RPL
2 | Budi | X TKJ
3 | Citra | X RPL
''';
      });

    } else if (query ==
        "select nama from siswa;") {

      setState(() {
        hasil =
            '''
nama
---------
Andi
Budi
Citra
''';
      });

    } else {

      setState(() {
        hasil =
            "Syntax Error atau Query belum didukung";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        title:
            const Text("Simulasi SQL"),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Masukkan Query SQL",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller:
                  sqlController,
              maxLines: 5,
              decoration:
                  InputDecoration(
                hintText:
                    "SELECT * FROM siswa;",
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child:
                  ElevatedButton(
                onPressed:
                    jalankanSQL,
                child: const Text(
                  "Jalankan Query",
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            const Text(
              "Hasil",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(
              child: Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets
                        .all(16),
                decoration:
                    BoxDecoration(
                  color:
                      Colors.black,
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
                child:
                    SingleChildScrollView(
                  child: Text(
                    hasil,
                    style:
                        const TextStyle(
                      color:
                          Colors.green,
                      fontFamily:
                          'monospace',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}