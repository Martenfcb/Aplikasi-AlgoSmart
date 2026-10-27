import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/siswa_bottom_navigation.dart';

class DetailVideoPage extends StatelessWidget {

  final String judul;
  final String deskripsi;
  final String link;

  const DetailVideoPage({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.link,
  });

  Future<void> tontonVideo(
      BuildContext context) async {

    final Uri url = Uri.parse(link);

    if (await canLaunchUrl(url)) {

      await launchUrl(

        url,

        mode:
            LaunchMode.externalApplication,

      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Video tidak dapat dibuka",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF4F7FC),

      appBar: AppBar(

        title:
            const Text("Detail Video"),

        centerTitle: true,

      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(

              width: double.infinity,

              height: 220,

              decoration: BoxDecoration(

                borderRadius:
                    BorderRadius.circular(24),

                gradient:
                    const LinearGradient(

                  colors: [

                    Color(0xff2563EB),

                    Color(0xff3B82F6),

                  ],
                ),
              ),

              child: const Center(

                child: Icon(

                  Icons.play_circle_fill,

                  size: 100,

                  color: Colors.white,

                ),
              ),
            ),

            const SizedBox(height: 30),
                        const Text(
              "Judul Video",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Deskripsi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                deskripsi,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(
                    width: 65,
                    height: 65,

                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.12),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Video Pembelajaran",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Klik tombol di bawah untuk membuka video.",
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(

                onPressed: () {

                  tontonVideo(context);

                },

                icon: const Icon(
                  Icons.play_arrow_rounded,
                ),

                label: const Text(
                  "Tonton Video",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff2563EB),
                  foregroundColor:
                      Colors.white,
                  elevation: 5,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 2,
      ),
);
  }
}