import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';


class YoutubeVideoWidget extends StatefulWidget {
  final String youtubeUrl;

  const YoutubeVideoWidget({super.key, required this.youtubeUrl});

  @override
  State<YoutubeVideoWidget> createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  late YoutubePlayerController _controller;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      final videoId = YoutubePlayerController.convertUrlToId(widget.youtubeUrl);

      if (videoId == null || videoId.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = "URL video tidak valid: ${widget.youtubeUrl}";
        });
        return;
      }

      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      )..loadVideoById(videoId: videoId);
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "Error saat menginisialisasi player: $e";
      });
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
              const SizedBox(height: 8),
              Text(
                _errorMessage ?? 'Terjadi kesalahan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[600]),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = null;
                  });
                  _initializePlayer();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: player,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tonton video ini untuk informasi lengkap!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
