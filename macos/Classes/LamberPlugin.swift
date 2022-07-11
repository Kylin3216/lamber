import Cocoa
import FlutterMacOS

public class LamberPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lamber", binaryMessenger: registrar.messenger)
    let instance = LamberPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    dummy_method_to_enforce_bundling()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
