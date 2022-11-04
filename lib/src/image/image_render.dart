import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_fade.dart';
import 'retry_cached_image.dart';

class AppImage extends StatefulWidget {
  const AppImage({
    super.key,
    required this.image,
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.center,
    this.duration,
    this.borderRadius,
    this.syncDuration,
    this.distractor = false,
    this.progress = false,
    this.color,
    this.scale,
  });

  final ImageProvider? image;
  final BoxFit fit;
  final double? borderRadius;
  final Alignment alignment;
  final Duration? duration;
  final Duration? syncDuration;
  final bool distractor;
  final bool progress;
  final Color? color;
  final double? scale;

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  ImageProvider? _displayImage;
  ImageProvider? _sourceImage;

  @override
  void didChangeDependencies() {
    _updateImage();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AppImage oldWidget) {
    _updateImage();
    super.didUpdateWidget(oldWidget);
  }

  void _updateImage() {
    if (widget.image == _sourceImage) return;
    _sourceImage = widget.image;
    _displayImage = _capImageSize(_addRetry(_sourceImage));
  }

  @override
  Widget build(BuildContext context) => ImageFade(
        image: _displayImage,
        fit: widget.fit,
        alignment: widget.alignment,
        borderRadius: widget.borderRadius ?? 16,
        duration: widget.duration ?? const Duration(milliseconds: 250),
        syncDuration: widget.syncDuration ?? Duration.zero,
        loadingBuilder: (_, value, ___) {
          if (!widget.distractor && !widget.progress) return const SizedBox();

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
        errorBuilder: (_, err) => Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (_, constraints) {
              final double size =
                  min(constraints.biggest.width, constraints.biggest.height);
              if (size < 16) return const SizedBox();

              return Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent.withOpacity(0.1),
                size: min(size, 15),
              );
            },
          ),
        ),
      );

  ImageProvider? _addRetry(ImageProvider? image) =>
      image == null ? image : RetryImage(image);

  ImageProvider? _capImageSize(ImageProvider? image) {
    if (image == null || widget.scale == null) return image;
    final mdq = MediaQuery.of(context);
    final screenSize = mdq.size * mdq.devicePixelRatio * (widget.scale ?? 1);

    return ResizeImage(image, width: screenSize.width.round());
  }
}
