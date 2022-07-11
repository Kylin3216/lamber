import 'dart:ffi';
import 'dart:io';
import 'src/bridge.dart';

const String _libName = 'lamber';

/// The dynamic library in which the symbols for [LamberBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.process();
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final Lamber lamber = LamberImpl(_dylib);

class LamberLocalServer {
  int _serverPointer = 0;

  static LamberLocalServer? _server;

  LamberLocalServer._();

  factory LamberLocalServer() => _server ?? LamberLocalServer._();

  Future<void> create(String path, {int port = 3216}) async {
    if (_serverPointer != 0) {
      throw ArgumentError("LocalServer Is Already Created!!!");
    }
    _serverPointer = await lamber.createLocalServer(path: path, port: port);
  }

  void start() {
    if (_serverPointer != 0) lamber.startLocalServer(pointer: _serverPointer);
  }

  void stop() async {
    if (_serverPointer != 0) {
      await lamber.stopLocalServer(pointer: _serverPointer);
      _serverPointer = 0;
    }
  }
}
