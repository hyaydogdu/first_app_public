import 'package:flutter/material.dart';
import 'package:first_app/Services/api_config.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String? url;
  final String fallbackPath;

  final double borderRadius;
  final Color backgroundColor;

  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowScrubbing;

  const AppVideoPlayer({
    super.key,
    required this.url,
    this.fallbackPath = "",
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
  int _bootVersion = 0;

  String get baseUrl => ApiConfig.baseUrl;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final sourceChanged =
        oldWidget.url != widget.url ||
        oldWidget.fallbackPath != widget.fallbackPath;

    final behaviorChanged =
        oldWidget.autoPlay != widget.autoPlay ||
        oldWidget.looping != widget.looping;

    if (sourceChanged || behaviorChanged) {
      _boot();
    }
  }

  String? _resolveUrl() {
    final raw = (widget.url == null || widget.url!.trim().isEmpty)
        ? widget.fallbackPath.trim()
        : widget.url!.trim();

    if (raw.isEmpty) return null;

    final uri = Uri.tryParse(raw);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      return raw;
    }

    final cleanBase = baseUrl.trim();
    if (cleanBase.isEmpty) return null;

    final base = cleanBase.endsWith("/")
        ? cleanBase.substring(0, cleanBase.length - 1)
        : cleanBase;

    final path = raw.startsWith("/") ? raw : "/$raw";
    return "$base$path";
  }

  void _boot() {
    final bootVersion = ++_bootVersion;

    _error = null;
    _initFuture = null;
    _disposeController();

    final resolved = _resolveUrl();

    if (resolved == null || resolved.isEmpty) {
      _error = "Video kaynağı yok";
      if (mounted) setState(() {});
      return;
    }

    final uri = Uri.tryParse(resolved);
    if (uri == null || !uri.hasScheme) {
      _error = "Geçersiz video adresi";
      if (mounted) setState(() {});
      return;
    }

    debugPrint("VIDEO_URL => $resolved");

    final controller = VideoPlayerController.networkUrl(uri);
    _controller = controller;
    controller.addListener(() => _handleControllerUpdate(controller));

    _initFuture = () async {
      try {
        await controller.initialize();

        if (bootVersion != _bootVersion) return;

        await controller.setLooping(widget.looping);

        if (widget.autoPlay) {
          await controller.play();
        }
      } catch (e) {
        if (bootVersion == _bootVersion) {
          _error = "Video açılamadı: $e";
        }
      }

      if (mounted && bootVersion == _bootVersion) {
        setState(() {});
      }
    }();

    if (mounted) setState(() {});
  }

  void _handleControllerUpdate(VideoPlayerController controller) {
    if (!mounted || _controller != controller || _error != null) return;

    final value = controller.value;
    if (!value.hasError) return;

    setState(() {
      _error = _formatVideoError(value.errorDescription);
    });
  }

  String _formatVideoError(Object? error) {
    final detail = error?.toString().trim();
    if (detail == null || detail.isEmpty) {
      return "Video oynatıcı bilinmeyen bir hata aldı";
    }

    return "Video oynatıcı hatası: $detail";
  }

  void _disposeController() {
    final controller = _controller;
    _controller = null;
    controller?.dispose();
  }

  @override
  void dispose() {
    _bootVersion++;
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        color: widget.backgroundColor,
        constraints: const BoxConstraints(minHeight: 180),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return _ErrorView(message: _error!, onRetry: _boot);
    }

    if (_initFuture == null) {
      return const _StatusView(message: "Video hazırlanıyor");
    }

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        final controller = _controller;

        if (_error != null) {
          return _ErrorView(message: _error!, onRetry: _boot);
        }

        if (snapshot.hasError) {
          return _ErrorView(
            message: _formatVideoError(snapshot.error),
            onRetry: _boot,
          );
        }

        if (controller != null && controller.value.hasError) {
          return _ErrorView(
            message: _formatVideoError(controller.value.errorDescription),
            onRetry: _boot,
          );
        }

        if (snapshot.connectionState != ConnectionState.done ||
            controller == null ||
            !controller.value.isInitialized) {
          return const _StatusView(message: "Video yükleniyor");
        }

        try {
          final aspect = controller.value.aspectRatio <= 0
              ? 16 / 9
              : controller.value.aspectRatio;

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(aspectRatio: aspect, child: VideoPlayer(controller)),
              if (widget.showControls)
                _ControlsBar(
                  controller: controller,
                  allowScrubbing: widget.allowScrubbing,
                  onError: (error) {
                    if (!mounted) return;
                    setState(() {
                      _error = _formatVideoError(error);
                    });
                  },
                ),
            ],
          );
        } catch (e) {
          _error = _formatVideoError(e);
          return _ErrorView(message: _error!, onRetry: _boot);
        }
      },
    );
  }
}

class _ControlsBar extends StatelessWidget {
  final VideoPlayerController controller;
  final bool allowScrubbing;
  final ValueChanged<Object> onError;

  const _ControlsBar({
    required this.controller,
    required this.allowScrubbing,
    required this.onError,
  });

  String _fmt(Duration duration) {
    String two(int n) => n.toString().padLeft(2, "0");

    final hours = duration.inHours;
    final minutes = two(duration.inMinutes.remainder(60));
    final seconds = two(duration.inSeconds.remainder(60));

    return hours > 0 ? "${two(hours)}:$minutes:$seconds" : "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(90),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final pos = value.position;
          final dur = value.duration;
          final maxMs = dur.inMilliseconds <= 0 ? 1 : dur.inMilliseconds;
          final sliderValue = pos.inMilliseconds.clamp(0, maxMs).toDouble();

          return Row(
            children: [
              IconButton(
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () async {
                  try {
                    value.isPlaying
                        ? await controller.pause()
                        : await controller.play();
                  } catch (e) {
                    onError(e);
                  }
                },
              ),
              const SizedBox(width: 6),
              Text(
                _fmt(pos),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: maxMs.toDouble(),
                  onChanged: allowScrubbing
                      ? (x) async {
                          try {
                            await controller.seekTo(
                              Duration(milliseconds: x.toInt()),
                            );
                          } catch (e) {
                            onError(e);
                          }
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _fmt(dur),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  final String message;

  const _StatusView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
              "Video gösterilemiyor",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 4,
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
