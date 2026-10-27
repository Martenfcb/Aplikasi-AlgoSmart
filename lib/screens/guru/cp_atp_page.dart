import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CPATPPage extends StatelessWidget {
  const CPATPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          "CP & ATP",
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cp_atp')
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data?.docs ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada data CP & ATP",
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {

              final item = data[index];

              return Card(
                elevation: 3,
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
                child: ExpansionTile(
                  leading: Icon(
                    item['kategori'] ==
                            "CP"
                        ? Icons.school
                        : Icons.route,
                    color: Colors.blue,
                  ),
                  title: Text(
                    item['judul'],
                  ),
                  subtitle: Text(
                    item['kategori'],
                  ),
                  children: [

                    Padding(
                      padding:
                          const EdgeInsets
                              .all(16),
                      child: Text(
                        item['isi'],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}