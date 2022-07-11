import 'package:flutter_test/flutter_test.dart';
import 'package:lamber/lamber.dart';
import 'package:lamber/lamber_platform_interface.dart';
import 'package:lamber/lamber_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLamberPlatform 
    with MockPlatformInterfaceMixin
    implements LamberPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LamberPlatform initialPlatform = LamberPlatform.instance;

  test('$MethodChannelLamber is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLamber>());
  });

  test('getPlatformVersion', () async {
    // Lamber lamberPlugin = Lamber();
    // MockLamberPlatform fakePlatform = MockLamberPlatform();
    // LamberPlatform.instance = fakePlatform;
  
    // expect(await lamberPlugin.getPlatformVersion(), '42');
  });
}
