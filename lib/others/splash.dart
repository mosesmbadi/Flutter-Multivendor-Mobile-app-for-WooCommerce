library network_to_file_image;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkToFileImage extends ImageProvider<NetworkToFileImage> {
  //
  const NetworkToFileImage({
    @required this.file,
    @required this.url,
    this.scale = 1.0,
    this.headers,
    this.debug = false,
    ProcessError processError,
  })  : assert(file != null || url != null),
        assert(scale != null);

  final File file;
  final String url;
  final double scale;
  final Map<String, String> headers;
  final bool debug;

  static final Map<String, Uint8List> _mockFiles = {};
  static final Map<String, Uint8List> _mockUrls = {};

  static void stopHttpOverride() {
    HttpOverrides.global = null;
  }

  /// You can set mock files. It searches for an exact file.path (string comparison).
  /// For example, to set an empty file: setMockFile(File("photo.png"), null);
  static void setMockFile(File file, Uint8List bytes) {
    assert(file != null);
    _mockFiles[file.path] = bytes;
  }

  /// You can set mock urls. It searches for an exact url (string comparison).
  static void setMockUrl(String url, Uint8List bytes) {
    assert(url != null);
    _mockUrls[url] = bytes;
  }

  static void clearMocks() {
    clearMockFiles();
    clearMockUrls();
  }

  static void clearMockFiles() {
    _mockFiles.clear();
  }

  static void clearMockUrls() {
    _mockUrls.clear();
  }

  @override
  Future<NetworkToFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkToFileImage>(this);
  }

  @override
  ImageStreamCompleter load(NetworkToFileImage key, DecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents = StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, chunkEvents, decode),
        chunkEvents: chunkEvents.stream,
        scale: key.scale,
        informationCollector: () sync* {
          yield ErrorDescription('Image provider: $this');
          yield ErrorDescription('File: ${file?.path}');
          yield ErrorDescription('Url: $url');
        });
  }

  Future<ui.Codec> _loadAsync(
      NetworkToFileImage key,
      StreamController<ImageChunkEvent> chunkEvents,
      DecoderCallback decode,
      ) async {
    try {
      assert(key == this);
      // ---

      Uint8List bytes;

      // Reads a MOCK file.
      if (file != null && _mockFiles.containsKey(file.path)) {
        bytes = _mockFiles[file.path];
      }

      // Reads from the local file.
      else if (file != null && _ifFileExistsLocally()) {
        bytes = await _readFromTheLocalFile();
      }

      // Reads from the MOCK network and saves it to the local file.
      // Note: This wouldn't be necessary when startHttpOverride() is called.
      else if (url != null && url.isNotEmpty && _mockUrls.containsKey(url)) {
        bytes = await _downloadFromTheMockNetworkAndSaveToTheLocalFile();
      }

      // Reads from the network and saves it to the local file.
      else if (url != null && url.isNotEmpty) {
        bytes = await _downloadFromTheNetworkAndSaveToTheLocalFile(chunkEvents);
      }

      else if(url.isEmpty) {
        final byteData = await rootBundle.load('lib/assets/images/splash.jpg');
        bytes  = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      }

      // ---

      // Empty file.
      if ((bytes != null) && (bytes.lengthInBytes == 0)) bytes = null;

      return await decode(bytes);
    } finally {
      chunkEvents.close();
    }
  }

  bool _ifFileExistsLocally() => file.existsSync();

  Future<Uint8List> _readFromTheLocalFile() async {
    if (debug) print("Reading image file: ${file?.path}");

    final Uint8List bytes = await file.readAsBytes();
    if (bytes.lengthInBytes == 0) return null;

    return bytes;
  }

  Future<Uint8List> _downloadFromTheNetworkAndSaveToTheLocalFile(
      StreamController<ImageChunkEvent> chunkEvents,
      ) async {
    assert(url != null && url.isNotEmpty);
    if (debug) print("Fetching image from: $url");
    // ---

    final Uri resolved = Uri.base.resolve(url);
    final HttpClientRequest request = await HttpClient().getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok)
      throw NetworkImageLoadException(statusCode: response.statusCode, uri: resolved);

    final Uint8List bytes = await consolidateHttpClientResponseBytes(
      response,
      onBytesReceived: (int cumulative, int total) {
        chunkEvents.add(ImageChunkEvent(
          cumulativeBytesLoaded: cumulative,
          expectedTotalBytes: total,
        ));
      },
    );

    if (bytes.lengthInBytes == 0) {
      throw Exception('NetworkImage is an empty file: $resolved');
    }

    if (file != null) saveImageToTheLocalFile(bytes);

    return bytes;
  }

  Future<Uint8List> _downloadFromTheMockNetworkAndSaveToTheLocalFile() async {
    assert(url != null && url.isNotEmpty);
    if (debug) print("Fetching image from: $url");
    // ---

    final Uri resolved = Uri.base.resolve(url);
    Uint8List bytes = _mockUrls[url];
    if (bytes.lengthInBytes == 0) {
      throw Exception('NetworkImage is an empty file: $resolved');
    }
    if (file != null) saveImageToTheLocalFile(bytes);
    return bytes;
  }

  void saveImageToTheLocalFile(Uint8List bytes) async {
    if (debug) print("Saving image to file: ${file?.path}");
    file.writeAsBytes(bytes, flush: true);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    final NetworkToFileImage typedOther = other;
    return url == typedOther.url &&
        file?.path == typedOther.file?.path &&
        scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, file?.path, scale);

  @override
  String toString() => '$runtimeType("${file?.path}", "$url", scale: $scale)';
}

typedef ProcessError = void Function(dynamic error);