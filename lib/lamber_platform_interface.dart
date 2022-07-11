import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'lamber_method_channel.dart';

abstract class LamberPlatform extends PlatformInterface {
  /// Constructs a LamberPlatform.
  LamberPlatform() : super(token: _token);

  static final Object _token = Object();

  static LamberPlatform _instance = MethodChannelLamber();

  /// The default instance of [LamberPlatform] to use.
  ///
  /// Defaults to [MethodChannelLamber].
  static LamberPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LamberPlatform] when
  /// they register themselves.
  static set instance(LamberPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
