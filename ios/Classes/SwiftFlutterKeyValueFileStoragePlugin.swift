import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftFlutterKeyValueFileStoragePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.icapps.flutter_key_value_file_storage", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterKeyValueFileStoragePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if let args = call.arguments as? Dictionary<String, Any> {
         switch (call.method) {
         default:
             result(FlutterError.init(code: "error", message: "unknown method", details: nil))
         }
      } else {
        result(FlutterError.init(code: "error", message: "data or format error", details: nil))
      }
  }
}
