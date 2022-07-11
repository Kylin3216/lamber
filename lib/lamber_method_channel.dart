import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'lamber_platform_interface.dart';

/// An implementation of [LamberPlatform] that uses method channels.
class MethodChannelLamber extends LamberPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('lamber');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
