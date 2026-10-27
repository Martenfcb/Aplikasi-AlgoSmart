import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/siswa_bottom_navigation.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({
    super.key,
  });

  @override
  State<RankingPage> createState() =>
      _RankingPageState();
}

class _RankingPageState
    extends State<RankingPage> {

  //--------------------------------------------------
  // FIRESTORE
  //--------------------------------------------------

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  //--------------------------------------------------
  // REFRESH
  //--------------------------------------------------

  Future<void> refreshData() async {

    setState(() {});

    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

  }
    //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      appBar: AppBar(

        title: const Text(
          "Ranking Quiz",
        ),

        centerTitle: true,

        backgroundColor:
            Colors.deepPurple,

        foregroundColor:
            Colors.white,

        elevation: 0,

      ),

      body: RefreshIndicator(

        onRefresh: refreshData,

        child: StreamBuilder<

            QuerySnapshot<Map<String, dynamic>>>(

          stream: firestore

              .collection("nilai")

              .orderBy(

                "nilai",

                descending: true,

              )

              .snapshots(),

          builder: (context, snapshot) {

            //------------------------------------------------
            // LOADING
            //------------------------------------------------

            if (snapshot.connectionState ==
                ConnectionState.waiting) {

              return const Center(

                child:
                    CircularProgressIndicator(),

              );

            }

            //------------------------------------------------
            // BELUM ADA DATA
            //------------------------------------------------

            if (!snapshot.hasData ||

                snapshot.data!.docs.isEmpty) {

              return const Center(

                child: Text(

                  "Belum ada data ranking.",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

              );

            }

            final ranking =
                snapshot.data!.docs;
                         //------------------------------------------------
            // LIST RANKING
            //------------------------------------------------

            return ListView.builder(

              padding:
                  const EdgeInsets.all(16),

              itemCount: ranking.length,

              itemBuilder: (context, index) {

                final data =
                    ranking[index].data();

                final nama =
                    data["nama"] ?? "-";

                final quiz =
                    data["quiz"] ?? "-";

                final nilai =
                    data["nilai"] ?? 0;

                Color warnaRank =
                    Colors.blueGrey;

                IconData iconRank =
                    Icons.emoji_events;

                if (index == 0) {

                  warnaRank =
                      Colors.amber;

                } else if (index == 1) {

                  warnaRank =
                      Colors.grey;

                } else if (index == 2) {

                  warnaRank =
                      Colors.brown;

                }   
                                return Card(

                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),

                  elevation: 4,

                  shadowColor:
                      Colors.black12,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),

                  ),

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Row(

                      children: [

                        //------------------------------------------------
                        // RANK
                        //------------------------------------------------

                        CircleAvatar(

                          radius: 25,

                          backgroundColor:
                              warnaRank,

                          child: Text(

                            "${index + 1}",

                            style:
                                const TextStyle(

                              color: Colors.white,

                              fontWeight:
                                  FontWeight.bold,

                              fontSize: 18,

                            ),

                          ),

                        ),

                        const SizedBox(width: 15),

                        //------------------------------------------------
                        // ICON SISWA
                        //------------------------------------------------

                        CircleAvatar(

                          radius: 28,

                          backgroundColor:
                              Colors.deepPurple
                                  .shade100,

                          child: const Icon(

                            Icons.person,

                            size: 30,

                            color:
                                Colors.deepPurple,

                          ),

                        ),

                        const SizedBox(width: 15),

                        //------------------------------------------------
                        // NAMA & QUIZ
                        //------------------------------------------------

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                nama,

                                style:
                                    const TextStyle(

                                  fontSize: 18,

                                  fontWeight:
                                      FontWeight.bold,

                                ),

                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(

                                quiz,

                                style:
                                    TextStyle(

                                  color:
                                      Colors.grey
                                          .shade700,

                                ),

                              ),

                            ],

                          ),

                        ),

                        //------------------------------------------------
                        // NILAI
                        //------------------------------------------------

                        Container(

                          padding:
                              const EdgeInsets
                                  .symmetric(

                            horizontal: 18,

                            vertical: 10,

                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                Colors.green
                                    .shade50,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),

                          ),

                          child: Column(

                            children: [

                              const Text(

                                "Nilai",

                                style:
                                    TextStyle(

                                  fontSize: 12,

                                ),

                              ),

                              Text(

                                nilai.toString(),

                                style:
                                    const TextStyle(

                                  fontSize: 24,

                                  fontWeight:
                                      FontWeight.bold,

                                  color:
                                      Colors.green,

                                ),

                              ),

                            ],

                          ),

                        ),

                      ],

                    ),

                  ),

                );
                              },

            );

          },

        ),

      ),

    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 4,
      ),
);

  }

}