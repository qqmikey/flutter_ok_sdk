import Flutter
import UIKit
import SafariServices

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
                    let data: [String: String] = [
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


@available(iOS 9.0, *)
public class OKLogin {
    static var appId: String? {
        return Bundle.main.object(forInfoDictionaryKey: "OkAppId") as? String
    }

    static var appSecret: String? {
        return Bundle.main.object(forInfoDictionaryKey: "OkAppSecret") as? String
    }

    static var cb: ((Any?, String?) -> ())? = nil
    static var vc: OKLoginViewController? = nil
    
    static func login(parent: UIViewController, cb: ((Any?, String?) -> ())?=nil) {
        guard let appId = OKLogin.appId else {
            self.cb?(nil, "OK login error")
            return
        }
        let vc = OKLoginViewController(url: URL(string: "https://connect.ok.ru/oauth/authorize?client_id=\(appId)&scope=VALUABLE_ACCESS;LONG_ACCESS_TOKEN&response_type=token&redirect_uri=ok\(appId)://authorize&layout=m&state=odnoklassniki")!)
        self.cb = cb
        self.vc = vc
        vc.cb = cb
        parent.present(vc, animated: true, completion: nil)
    }
    
    public static func processOpen(_ passedUrl: URL!, _ sourceApplication: String! = "") {
        guard let appId = OKLogin.appId else {
            self.cb?(nil, "OK login error")
            return
        }
        if passedUrl.scheme == "ok\(appId)" {
            if let url = URL(string: passedUrl.absoluteString.replacingOccurrences(of: "#", with: "?", options: .literal, range: nil)), let accessToken = url.getQueryStringParameter(param: "access_token"), let sessionSecret = url.getQueryStringParameter(param: "session_secret_key") {
                let token = OKToken(tokenString: accessToken, sessionSecret: sessionSecret)
                self.cb?(token, nil)
                self.vc?.dismiss(animated: true, completion: nil)
            } else {
                self.cb?(nil, "OK login error")
                self.vc?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

struct OKToken {
    var tokenString: String
    var sessionSecret: String
}

@available(iOS 9.0, *)
class OKLoginViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    var cb: ((Any?, String?) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.cb?(nil, "dissmiss")
        self.dismiss(animated: true, completion: nil)
    }
}

extension URL {
    func getQueryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
