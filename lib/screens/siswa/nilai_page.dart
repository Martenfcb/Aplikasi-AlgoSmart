import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nilai Saya"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nilai')
            .where(
              'email',
              isEqualTo: user?.email,
            )
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final nilaiData = snapshot.data!.docs;

          if (nilaiData.isEmpty) {

            return const Center(
              child: Text(
                "Belum ada nilai",
              ),
            );
          }

          return ListView.builder(
            itemCount: nilaiData.length,

            itemBuilder: (context, index) {

              final data = nilaiData[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      "${index + 1}",
                    ),
                  ),

                  title: Text(
                    "Nilai: ${data['nilai']}",
                  ),

                  subtitle: Text(
                    data['email'],
                  ),
                ),
              );
            },
          );
        },
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 4,
      ),
);
  }
}