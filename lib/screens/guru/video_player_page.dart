import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerPage extends StatefulWidget {
  final String judul;
  final String deskripsi;
  final String url;

  const VideoPlayerPage({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.url,
  });

  @override
  State<VideoPlayerPage> createState() =>
      _VideoPlayerPageState();
}

class _VideoPlayerPageState
    extends State<VideoPlayerPage> {

  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    final videoId =
        YoutubePlayerController.convertUrlToId(
      widget.url,
    );

    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    if (videoId != null) {
      controller.loadVideoById(
        videoId: videoId,
      );
    }
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judul),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            YoutubePlayer(
              controller: controller,
              aspectRatio: 16 / 9,
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.judul,
                    style:
                        const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    widget.deskripsi,
                    style:
                        const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}