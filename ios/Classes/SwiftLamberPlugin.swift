import Flutter
import UIKit

public class SwiftLamberPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lamber", binaryMessenger: registrar.messenger())
    let instance = SwiftLamberPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let dummy=dummy_method_to_enforce_bundling()
    print(dummy)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
