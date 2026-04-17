import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  /// url null olabilir.
  /// - null/empty ise fallbackPath kullanılır.
  /// - "/exercises/Videos/Video1.mp4" gibi relative gelirse baseUrl ile birleştirilir.
  /// - "http..." gelirse olduğu gibi kullanılır.
  final String? url;

  /// Örn (emulator): "http://10.0.2.2:5018"
  /// Örn (real device): "http://192.168.1.15:5018"

  /// url null/empty ise kullanılacak path
  final String fallbackPath;

  /// UI
  final double borderRadius;
  final Color backgroundColor;

  /// Behavior
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowScrubbing;

  const AppVideoPlayer({
    super.key,
    required this.url,
    this.fallbackPath = "/exercises/Videos/Video1.mp4",
    this.borderRadius = 16,
    this.backgroundColor = Colors.black,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.allowScrubbing = true,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initFuture;
  String? _error;

  String baseUrl = "http://10.0.2.2:5018";

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || baseUrl != baseUrl) {
      _boot();
    }
  }

  String _resolveUrl() {
    final raw = (widget.url == null || widget.url!.trim().isEmpty)
        ? widget.fallbackPath
        : widget.url!.trim();

    // Zaten tam URL ise dokunma
    if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;

    // baseUrl + path
    final base = baseUrl.endsWith("/")
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final path = raw.startsWith("/") ? raw : "/$raw";
    return "$base$path";
  }

  void _boot() {
    _error = null;
    _disposeController();

    final resolved = _resolveUrl();
    debugPrint("VIDEO_URL => $resolved");

    final c = VideoPlayerController.networkUrl(Uri.parse(resolved));
    _controller = c;

    _initFuture = () async {
      try {
        await c.initialize();
        await c.setLooping(widget.looping);
        if (widget.autoPlay) {
          await c.play();
        }
      } catch (e) {
        _error = e.toString();
      }
      if (mounted) setState(() {});
    }();
  }

  void _disposeController() {
    final c = _controller;
    _controller = null;
    c?.dispose();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        color: widget.backgroundColor,
        child: _initFuture == null
            ? const SizedBox.shrink()
            : FutureBuilder<void>(
                future: _initFuture,
                builder: (context, snapshot) {
                  if (_error != null) {
                    return _ErrorView(message: _error!, onRetry: _boot);
                  }

                  if (snapshot.connectionState != ConnectionState.done ||
                      _controller == null ||
                      !_controller!.value.isInitialized) {
                    return const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final c = _controller!;
                  final aspect = c.value.aspectRatio == 0
                      ? (16 / 9)
                      : c.value.aspectRatio;

                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(aspectRatio: aspect, child: VideoPlayer(c)),
                      if (widget.showControls)
                        _ControlsBar(
                          controller: c,
                          allowScrubbing: widget.allowScrubbing,
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _ControlsBar extends StatelessWidget {
  final VideoPlayerController controller;
  final bool allowScrubbing;

  const _ControlsBar({required this.controller, required this.allowScrubbing});

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    final h = d.inHours;
    return h > 0 ? "${two(h)}:$m:$s" : "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            },
          ),
          const SizedBox(width: 6),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, VideoPlayerValue v, _) {
              final pos = v.position;
              final dur = v.duration;
              final maxMs = dur.inMilliseconds <= 0 ? 1 : dur.inMilliseconds;
              final value = pos.inMilliseconds.clamp(0, maxMs).toDouble();

              return Expanded(
                child: Row(
                  children: [
                    Text(
                      _fmt(pos),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: value,
                        min: 0,
                        max: maxMs.toDouble(),
                        onChanged: allowScrubbing
                            ? (x) => controller.seekTo(
                                Duration(milliseconds: x.toInt()),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _fmt(dur),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 34),
            const SizedBox(height: 10),
            const Text(
              "Video açılamadı",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
              ),
              child: const Text("Tekrar dene"),
            ),
          ],
        ),
      ),
    );
  }
}
