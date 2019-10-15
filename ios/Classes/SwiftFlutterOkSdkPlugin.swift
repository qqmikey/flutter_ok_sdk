import Flutter
import UIKit

public class SwiftFlutterOkSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_ok_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterOkSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        if #available(iOS 9.0, *) {
            OKLogin.login(parent: rootController as! FlutterViewController) { okresult, error in
                if let token = okresult as? OKToken, error == nil {
                    let data: [String: Any?] = [
                        "access_token": token.tokenString,
                        "secret": token.sessionSecret
                    ]
                    result(data)
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: error, details: nil))
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
