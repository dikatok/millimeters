import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'millimeters_platform_interface.dart';

/// An implementation of [MillimetersPlatform] that uses method channels.
class MethodChannelMillimeters extends MillimetersPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('millimeters');

  MethodChannelMillimeters() {
    methodChannel.setMethodCallHandler((call) {
      switch ((call.method, call.arguments)) {
        case (
            "updateResolution",
            {"Width": final num width, "Height": final num height}
          ):
          resolutionController.add(Size(width.toDouble(), height.toDouble()));
          return Future.value(null);
        case (
            "updateSize",
            {"Width": final num width, "Height": final num height}
          ):
          sizeController.add(Size(width.toDouble(), height.toDouble()));
          return Future.value(null);
        default:
          return Future(
            () => throw MissingPluginException(
                "No implementation found for method ${call.method}"),
          );
      }
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Size?> getSize() async {
    final size = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('getSize');

    return switch (size) {
      {"Width": 0 as num, "Height": 0 as num} => null,
      {"Width": final num width, "Height": final num height} =>
        Size(width.toDouble(), height.toDouble()),
      _ => null
    };
  }

  @override
  Future<Size?> getResolution() async {
    final size = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('getResolution');

    return switch (size) {
      {"Width": 0 as num, "Height": 0 as num} => null,
      {"Width": final num width, "Height": final num height} =>
        Size(width.toDouble(), height.toDouble()),
      _ => null
    };
  }
}
