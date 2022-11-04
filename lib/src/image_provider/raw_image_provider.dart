import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// Wraps an already loaded image into an [ImageProvider].
class RawImageProvider extends ImageProvider<RawImageProvider> {
  final Image _image;

  RawImageProvider(this._image);

  @override
  // clone is important here, otherwise the RawImageProvider might dispose the original image
  // ignore: deprecated_member_use
  ImageStreamCompleter load(RawImageProvider key, DecoderCallback decode) =>
      _RawImageStreamCompleter(_image.clone());

  @override
  Future<RawImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<RawImageProvider>(this);
}

class _RawImageStreamCompleter extends ImageStreamCompleter {
  _RawImageStreamCompleter(Image image) {
    setImage(ImageInfo(image: image));
  }
}
